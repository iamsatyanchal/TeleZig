const std = @import("std");
const show = std.debug.print;
const memory = std.mem;
const heap = std.heap;
const telegram = @import("telegram_bot/bot.zig");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    // stdin and stdout are used to read and write.. learnt this :)

    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    try stdout.print("Welcome to TeleZig! Please enter your bot token: \n", .{});
    // could have used show instead of this but for learning purpose used this one :)

    var token: [100]u8 = undefined;

    if (try stdin.readUntilDelimiterOrEof(&token, '\n')) |data_input| {
        //reading the token here and if found saving it as data_input for further processing

        const bot_token = memory.trimRight(u8, data_input, "\r");
        var bot = try telegram.Telebot.init(allocator, bot_token);
        defer bot.deinit();
        show("Bot initialized successfully :)\n {s}\n", .{bot.tg_base_url});
        try bot.getMe();

        // idk i had to shift all the code blocks inside this if block because yet idk how to use glock and local variable outside the block..
    }
}
