const Terminal = @This();

const std = @import("std");
const ColorScheme = @import("ColorScheme.zig");

const tty = std.io.tty;
const File = std.fs.File;

writer: File.Writer,
config: tty.Config,

pub fn init(file: File, buffer: []u8) Terminal {
    return .{
        .writer = file.writer(buffer),
        .config = tty.Config.detect(file),
    };
}

pub fn print(
    terminal: Terminal,
    style: ColorScheme.Style,
    comptime format: []const u8,
    args: anytype,
) void {
    var writer = terminal.writer.interface;
    for (style) |color| {
        terminal.config.setColor(&writer, color) catch {};
    }

    writer.print(format, args) catch {};

    if (style.len > 0) {
        terminal.config.setColor(&writer, .reset) catch {};
    }
}
