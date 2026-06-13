const std = @import("std");
const types = @import("types.zig");
const memory = std.mem;
const show = std.debug.print;

pub const Message = types.Message;
pub const Update = types.Update;

pub const Telebot = struct {
    bot_token: []const u8,
    tg_base_url: []const u8,
    allocator: memory.Allocator,

    pub fn init(allocator: memory.Allocator, bot_token: []const u8) !Telebot {
        const tg_base_url = try std.fmt.allocPrint(allocator, "https://api.telegram.org/bot{s}", .{bot_token}); //base api of the official telegram api
        return Telebot{
            .bot_token = bot_token,
            .tg_base_url = tg_base_url,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Telebot) void {
        defer self.allocator.free(self.tg_base_url);
    }

    pub fn getMe(self: Telebot) !void {
        const url = try std.fmt.allocPrint(self.allocator, "{s}/getMe", .{self.tg_base_url});
        defer self.allocator.free(url);
        var fetch = std.http.Client{ .allocator = self.allocator };
        defer fetch.deinit();
        const url_parsed = try std.Uri.parse(url);

        var fuckwhatisthis: [4096]u8 = undefined;
        // var buffer[1024]u8 = undefined; // buffer to store the response

        show("Calling URL: {s}\n", .{url}); // checking the url
        var request = try fetch.open(.GET, url_parsed, .{ .server_header_buffer = &fuckwhatisthis });

        try request.send();
        try request.finish();
        try request.wait();

        show("Request opened successfully!\n {any}", .{request});

        defer request.deinit();
    }
};
