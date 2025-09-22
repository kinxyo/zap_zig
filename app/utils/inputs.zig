const std = @import("std");

pub fn parseMethod(allocator: std.mem.Allocator, str: []const u8) !std.http.Method {
    const trimmed: []const u8 = std.mem.trim(u8, str, "\t\n\r");

    var upper_buf: []u8 = try allocator.alloc(u8, trimmed.len);
    defer allocator.free(upper_buf);

    for (trimmed, 0..) |char, i| {
        upper_buf[i] = std.ascii.toUpper(char);
    }

    const eql = std.mem.eql;
    if (eql(u8, "GET", upper_buf)) return .GET;
    if (eql(u8, "POST", upper_buf)) return .POST;
    if (eql(u8, "PUT", upper_buf)) return .PUT;
    if (eql(u8, "PATCH", upper_buf)) return .PATCH;
    if (eql(u8, "DELETE", upper_buf)) return .DELETE;

    return .GET; //replace it with custom app error later.
}

pub fn parsePath(allocator: std.mem.Allocator, str: []const u8, port: u16) !std.Uri {
    const trimmed = std.mem.trim(u8, str, "\t\n\r");

    const url = try std.fmt.allocPrint(allocator, "http://localhost:{d}{s}", .{ port, trimmed });

    return try std.Uri.parse(url);
}
