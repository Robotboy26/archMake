const std = @import("std");
const print = std.debug.print;
const io = std.io;

pub fn main() !void {
    var buffer: [128]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    const stdin = std.io.getStdIn().reader();
    const maxSize = 16;

    // print("What's your first name? ", .{});
    // var fname = (try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', maxSize)).?;
    // defer allocator.free(fname);
    //
    // print("What's your last name? ", .{});
    // var lname = (try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', maxSize)).?;
    // defer allocator.free(lname);
    //
    // print("Your first name is {s} and your last name is {s}\n", .{ fname, lname });

    var selection: [128]u8 = undefined;
    selection = try option(stdin, allocator, maxSize);
    print("The user selection is {s}", .{selection});
}

pub fn option(stdin: io.Reader, allocator: std.mem.Allocator, maxSize: usize) ?[]u8 {
    print("Option 1 ", .{});
    print("Option 2 ", .{});
    print("Option 3 ", .{});

    var selection = (try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', maxSize)).?;
    defer allocator.free(selection);

    print("Your selection is {s}.", .{selection});
    return selection;
}
