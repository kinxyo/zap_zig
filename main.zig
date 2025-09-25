const std = @import("std");
const app = @import("app/mod.zig");
const Args = @import("app/args.zig").Args;

const Terminal = app.terminal;
const parser = app.parser;

pub fn main() void {
    Terminal.clear();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    _ = std.process.argsAlloc(allocator) catch |err| {
        Terminal.fatal("Program ran out of memory: {any}", .{err});
        return;
    };

    var iters = std.process.args();
    _ = iters.skip();

    const args = Args.init(&iters);

    parser.parseArgs(allocator, args) catch |err| {
        Terminal.err("Couldn't run the request: {any}", .{err});
    };
}
