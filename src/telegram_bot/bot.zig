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

        var trace_data_for_header: [4096]u8 = undefined;
        // var buffer[1024]u8 = undefined; // buffer to store the response
        // show("Calling URL: {s}\n", .{url}); // checking the url
        var request = try fetch.open(.GET, url_parsed, .{ .server_header_buffer = &trace_data_for_header }); // sending the request and this is how to do a get request :/ tf

        try request.send();
        try request.finish();
        try request.wait();

        const body = try request.reader().readAllAlloc(self.allocator, 8196);
        defer self.allocator.free(body);
        show("Bot profile fetched successfully!\n\n{s}\n", .{body});

        defer request.deinit();
    }

    pub fn sendMessage(self: Telebot, chat_id: []const u8, text: []const u8) !void {
        const url = try std.fmt.allocPrint(self.allocator, "{s}/sendMessage", .{self.tg_base_url});
        defer self.allocator.free(url);
        var fetch = std.http.Client{ .allocator = self.allocator };
        defer fetch.deinit();
        const url_parsed = try std.Uri.parse(url);

        var trace_data_for_header: [4096]u8 = undefined;

        var request = try fetch.open(.POST, url_parsed, .{
            .server_header_buffer = &trace_data_for_header,
            .extra_headers = &.{
                .{ .name = "Content-Type", .value = "application/json" }, // this is used to declare the content type its an inbuilt function idk
            },
        });

        const payload = try std.fmt.allocPrint(self.allocator, "{{\"chat_id\": {s}, \"text\": \"{s}\"}}", .{ chat_id, text });
        defer self.allocator.free(payload);

        request.transfer_encoding = .{ .content_length = payload.len };

        try request.send();

        _ = try request.write(payload);

        try request.finish();
        try request.wait();

        defer request.deinit();
        const body = try request.reader().readAllAlloc(self.allocator, 1024 * 1024);

        defer self.allocator.free(body);
        show("\nMessage sent successfully!\n\n{s}\n", .{body});
    }
};
