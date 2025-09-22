const std = @import("std");
const Uri = std.Uri;
const Method = std.http.Method;

const terminal = @import("utils/mod.zig").terminal;

pub fn serve(allocator: std.mem.Allocator, method: Method, url: std.Uri) !void {
    terminal.print("{s} {s}\n", .{ @tagName(method), url.path.percent_encoded }); // wth is `percent_encoded` ???

    switch (method) {
        .GET => try get(allocator, url),
        else => unreachable,
    }
}

fn get(allocator: std.mem.Allocator, url: std.Uri) !void {
    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    const headers = &[_]std.http.Header{
        .{ .name = "Content-Type", .value = "application/json" },
    };

    var server_header_buffer: [1024]u8 = undefined;

    var request = try client.open(.GET, url, .{
        .server_header_buffer = &server_header_buffer,
        .extra_headers = headers,
    });
    defer request.deinit();

    try request.send();
    try request.finish();
    try request.wait();

    terminal.print("Status: {any}", .{request.response.status});

    var res_buffer: [4096]u8 = undefined;
    const bytes_read = try request.readAll(&res_buffer);
    const response = res_buffer[0..bytes_read];

    terminal.print("Response: {s}\n", .{response});
}
