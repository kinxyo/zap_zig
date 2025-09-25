const std = @import("std");

pub const Args = struct {
    method: []const u8,
    path: []const u8,

    pub fn init(iters: *std.process.ArgIterator) Args {
        const first_arg: []const u8 = iters.next().?;

        const is_first_arg_method: bool = std.mem.indexOfScalar(u8, first_arg, '/') == null;

        switch (is_first_arg_method) {
            false => {
                std.debug.print("hitting true", .{});

                return Args{
                    .method = "GET",
                    .path = first_arg,
                };
            },
            true => {
                std.debug.print("hitting false", .{});

                const second_arg: []const u8 = iters.next() orelse "/"; // log warning

                return Args{
                    .method = first_arg,
                    .path = second_arg,
                };
            },
        }
    }

    pub fn parseMethod(self: *const Args, allocator: std.mem.Allocator) !std.http.Method {
        const trimmed: []const u8 = std.mem.trim(u8, self.method, "\t\n\r");

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

    pub fn parsePath(self: *const Args, allocator: std.mem.Allocator, port: u16) !std.Uri {
        const trimmed = std.mem.trim(u8, self.path, "\t\n\r");

        const url = try std.fmt.allocPrint(allocator, "http://localhost:{d}{s}", .{ port, trimmed });

        std.debug.print("URL: {s}\n", .{url});

        return try std.Uri.parse(url);
    }
};
