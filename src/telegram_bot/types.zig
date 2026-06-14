// will use this file in future.. right now im learning other things :/

const std = @import("std");
const memory = std.mem;

pub const User = struct {
    id: i64,
    first_name: []const u8,
    last_name: ?[]const u8, // ? mark means it can be null also..
    username: ?[]const u8, // ? this can be also null.. cuz its optional in tg
};

pub const Chat = struct {
    id: i64,
    type: []const u8, // chat type means private db or group or channel..
    title: ?[]const u8, // name of the group or channel but not for private chat
    username: ?[]const u8,
};

pub const Message = struct {
    message_id: i64,
    from: ?User,
    chat: Chat,
    text: ?[]const u8,
    date: i64, // unix timestamp
};

pub const Update = struct {
    update_id: i64,
    message: ?Message, //updated msg will also be a msg so Message struct :)
};
