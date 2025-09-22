const std = @import("std");

const out_writer = std.io.getStdOut().writer();
const err_writer = std.io.getStdErr().writer();

pub fn clear() void {
    out_writer.print("\x1B[2J\x1B[H", .{}) catch unreachable;
}

pub fn print(comptime fmt: []const u8, args: anytype) void {
    out_writer.print(fmt, args) catch unreachable;
}

pub fn err(comptime fmt: []const u8, args: anytype) void {
    err_writer.print(fmt, args) catch unreachable;
}

pub fn fatal(comptime fmt: []const u8, args: anytype) void {
    err_writer.print(fmt, args) catch unreachable;
    std.process.exit(1);
}
