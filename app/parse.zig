// STD
const std = @import("std");
const Uri = std.Uri;
const Method = std.http.Method;
const Header = std.http.Header;

// UTILS
const utils = @import("utils/mod.zig");
const Terminal = utils.terminal;
const Inputs = utils.inputs;
const Json = utils.json;

// NETWORK
const Network = @import("network.zig");

pub fn parseArgs(allocator: std.mem.Allocator, method_arg: []const u8, path_arg: []const u8) !void {
    const PORT: u16 = Json.parseQuickConfig() orelse 8000;

    const method: Method = try Inputs.parseMethod(allocator, method_arg);
    const path: Uri = try Inputs.parsePath(allocator, path_arg, PORT);

    const headers = [_]Header{
        .{ .name = "Content-Type", .value = "application/json" },
    };

    try Network.serve(allocator, method, path, &headers, null);
}

// pub fn parseConfig(allocator: std.mem.Allocator, method_arg: []const u8, path_arg: []const u8) !void {
//     const PORT: u16 = Json.parseQuickConfig() orelse 8000;

//     const method: Method = try Inputs.parseMethod(allocator, method_arg);
//     const path: Uri = try Inputs.parsePath(allocator, path_arg, PORT);

//     const headers = [_]Header{
//         .{ .name = "Content-Type", .value = "application/json" },
//     };

//     const Payload = struct {
//         name: []const u8,
//         age: u8,
//     };

//     var payload = std.ArrayList(u8).init(allocator);
//     defer payload.deinit();

//     try std.json.stringify(Payload, .{}, payload.writer());

//     try Network.serve(allocator, method, path, &headers, payload.items);
// }
