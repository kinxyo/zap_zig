const std = @import("std");
const app = @import("app/mod.zig");

const terminal = app.terminal;
const parser = app.parser;

pub fn main() void {
    terminal.clear();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    _ = std.process.argsAlloc(allocator) catch |err| {
        terminal.fatal("Program ran out of memory: {any}", .{err});
        return;
    };

    var iters = std.process.args();
    _ = iters.skip();

    const method_arg: []const u8 = iters.next().?;
    const path_arg: []const u8 = iters.next().?;

    parser.parseDefault(allocator, method_arg, path_arg) catch |err| {
        terminal.err("Couldn't run the request: {any}", .{err});
    };
}
