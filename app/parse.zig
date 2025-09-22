// STD
const std = @import("std");
const Uri = std.Uri;
const Method = std.http.Method;

// UTILS
const utils = @import("utils/mod.zig");
const Terminal = utils.terminal;
const Inputs = utils.inputs;
const Json = utils.json;

// NETWORK
const Network = @import("network.zig");

pub fn parseDefault(allocator: std.mem.Allocator, method_arg: []const u8, path_arg: []const u8) !void {
    const PORT: u16 = Json.parseQuickConfig() orelse 8000;

    const method: Method = try Inputs.parseMethod(allocator, method_arg);
    const path: Uri = try Inputs.parsePath(allocator, path_arg, PORT);

    try Network.serve(allocator, method, path);
}
