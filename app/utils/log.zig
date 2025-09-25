const std = @import("std");

var stdout_buffer: [4096]u8 = undefined;
var stderr_buffer: [4096]u8 = undefined;

var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
var stderr_writer = std.fs.File.stderr().writer(&stderr_buffer);

pub const out_writer = &stdout_writer.interface;
pub const err_writer = &stderr_writer.interface;

pub fn flush() void {
    out_writer.flush() catch unreachable;
}

pub fn clear() void {
    out_writer.print("\x1B[2J\x1B[H", .{}) catch unreachable;
    flush();
}

pub fn print(comptime fmt: []const u8, args: anytype) void {
    out_writer.print(fmt, args) catch unreachable;
    // not auto flushing for performance
}

pub fn err(comptime fmt: []const u8, args: anytype) void {
    err_writer.print(fmt, args) catch unreachable;
    err_writer.flush() catch unreachable; // Always flush errors immediately
}

pub fn fatal(comptime fmt: []const u8, args: anytype) void {
    err_writer.print(fmt, args) catch unreachable;
    err_writer.flush() catch unreachable;
    std.process.exit(1);
}
