const std = @import("std");
const Uri = std.Uri;
const Method = std.http.Method;
const Header = std.http.Header;

const Terminal = @import("utils/mod.zig").terminal;

pub fn serve(allocator: std.mem.Allocator, method: Method, url: std.Uri, headers: []const Header, payload: ?[]const u8) !void {
    Terminal.print("{s} {s}\n", .{ @tagName(method), url.path.percent_encoded });

    if (method.requestHasBody()) {
        Terminal.print("Payload: \n{s}\n", .{payload.?});
    }

    Terminal.flush();

    if (method.requestHasBody()) {
        try curl(allocator, method, headers, url, payload);
    } else {
        try curl(allocator, method, headers, url, null);
    }
}

fn curl(allocator: std.mem.Allocator, method: Method, headers: []const Header, url: std.Uri, payload: ?[]const u8) !void {
    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    var buffer: [4096]u8 = undefined;
    var body = std.Io.Writer.fixed(&buffer);

    const response = try client.fetch(.{
        .method = method,
        .location = .{ .uri = url },
        .extra_headers = headers,
        .payload = payload,
        .response_writer = &body,
    });

    Terminal.print("Status: {any}\n", .{response.status});
    Terminal.print("Body: {s}\n", .{body.buffer});
    Terminal.flush();
}

fn curl_no_body(allocator: std.mem.Allocator, method: Method, headers: []const Header, url: std.Uri, payload: ?[]const u8) !void {
    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    const response = try client.fetch(.{
        .method = method,
        .location = .{ .uri = url },
        .extra_headers = headers,
        .payload = payload,
        // Don't provide response_writer - let it handle response internally
    });

    Terminal.print("Status: {any}\n", .{response.status});
    Terminal.flush();
    // The body is discarded when no response_writer is provided
    // If you need the response body, we'll need a different approach
}
