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
        show("\nBot initialized successfully!\n \nCalling URL: {s}\n\n", .{bot.tg_base_url});
        try bot.getMe();

        while (true) {
            show("\nEnter Chat ID and Message to send (format: chat_id ~ message): \n", .{});
            var message_block: [1024]u8 = undefined;
            if (try stdin.readUntilDelimiterOrEof(&message_block, '\n')) |message_input| {
                const input = memory.trimRight(u8, message_input, "\r");
                var input_token = memory.tokenizeScalar(u8, input, '~');
                const chat_id = input_token.next();
                const message = input_token.next();
                if (chat_id) |id| {
                    if (message) |msg| {
                        try bot.sendMessage(id, msg);
                    }
                }
            }
        }
        // idk i had to shift all the code blocks inside this if block because yet idk how to use global and local variable outside the block..
    }
}
