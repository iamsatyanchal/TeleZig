const std = @import("std");
const show = std.debug.print;
const memory = std.mem;
const heap = std.heap;
const telegram = @import("telegram_bot/bot.zig");

pub fn main() !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var bot = try telegram.Telebot.init(allocator, "bottoken hogaa");
    defer bot.deinit();
    show("Bot initialized successfully! {s}\n", .{bot.tg_base_url});
    try bot.getMe();
}
