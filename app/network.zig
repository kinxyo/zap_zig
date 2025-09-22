const std = @import("std");
const Uri = std.Uri;
const Method = std.http.Method;
const Header = std.http.Header;
const ClientRequest = std.http.Client.Request;

const terminal = @import("utils/mod.zig").terminal;

pub fn serve(allocator: std.mem.Allocator, method: Method, url: std.Uri, headers: []const Header, payload: ?[]const u8) !void {
    terminal.print("{s} {s}\n", .{ @tagName(method), url.path.percent_encoded }); // wth is `percent_encoded` ???

    if (method.requestHasBody()) {
        terminal.print("Payload: \n{s}\n", .{payload.?});
        try curl(allocator, method, headers, url, payload);
    } else {
        try curl(allocator, method, headers, url, null);
    }
}

fn curl(allocator: std.mem.Allocator, method: Method, headers: []const Header, url: std.Uri, payload: ?[]const u8) !void {
    var server_header_buffer: [1024]u8 = undefined;

    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    var request: ClientRequest = try client.open(method, url, .{
        .server_header_buffer = &server_header_buffer,
        .extra_headers = headers,
    });
    defer request.deinit();

    if (payload) |p| {
        request.transfer_encoding = .{ .content_length = p.len };
    }

    try request.send();

    if (payload) |p| {
        try request.writeAll(p);
    }

    try request.finish();
    try request.wait();

    terminal.print("Status: {any}", .{request.response.status});

    var buffer: [4096]u8 = undefined;
    const bytes_read = try request.readAll(&buffer);
    const response = buffer[0..bytes_read];

    terminal.print("Response: {s}\n", .{response});
}
