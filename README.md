<p align="center">
	<img src="TeleZig_icon.png" alt="TeleZig" />
</p>

<h1 align="center">TeleZig</h1>

TeleZig is a terminal based Telegram bot tool written in Zig. It currently supports only bot information lookup and sending messages from the command line.

## What it does

TeleZig lets you:

- check basic bot information with Telegram's `getMe` API
- send messages to a chat from the terminal

This project is still small and focused on the core flow first.
In the future, I plan to add photo updates and more Telegram features...

## Motivation

I built this project while learning Zig. The idea was simple for me think, search, learn and then implement step by step. That approach helped me understand the language and build something practical at the same time :) Btw this is my fav way to learn :)

## Tech Stack

- Zig
- Telegram API

## How To Start

If you already have the executable, run `main.exe` from the project folder.

## Development

After cloning the project and opening it in Zig, you can start development by running `zig run src/main.zig`.
This will build and run the terminal app directly.

## How It Works

1. The program starts in the terminal.
2. You enter your Telegram bot token.
3. The app calls Telegram's `getMe` endpoint to fetch bot information.
4. You enter a chat ID and a message in the format `chat_id ~ message`.
5. The app sends the message using Telegram's `sendMessage` endpoint.

## Screenshots
![](https://user-cdn.hackclub-assets.com/019ec68c-08f2-7748-b300-923f404831c5/screenshot-1781447526488-1.png)
![](https://cdn.hackclub.com/019ec67f-d7aa-782b-8e72-fa2f0d6b8ec3/screenshot-1781446726767-1.png)
![](https://cdn.hackclub.com/019ec67f-dae2-72ef-903d-2c5e863ee50b/screenshot-1781446727819-2.png)