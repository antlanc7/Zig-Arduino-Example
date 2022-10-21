const std = @import("std");
const deps = @import("deps.zig");

pub fn build(b: *std.build.Builder) !void {
    const uno = std.zig.CrossTarget{
        .cpu_arch = .avr,
        .cpu_model = .{ .explicit = &std.Target.avr.cpu.atmega328p },
        .os_tag = .freestanding,
        .abi = .none,
    };

    const exe = b.addExecutable("blink", "src/main.zig");
    deps.addAllTo(exe);
    exe.setTarget(uno);
    exe.setBuildMode(.ReleaseSmall);
    exe.bundle_compiler_rt = false;
    exe.setLinkerScriptPath(.{ .path = deps.dirs._ie76bs50j4tl ++ "/src/linker.ld" });
    exe.install();

    
    const tty = b.option(
        []const u8,
        "tty",
        "Specify the port to which the Arduino is connected (defaults to COM3)",
    ) orelse "COM3";

    const bin_path = b.getInstallPath(exe.install_step.?.dest_dir, exe.out_filename);

    const flash_command = blk: {
        var tmp = std.ArrayList(u8).init(b.allocator);
        try tmp.appendSlice("-Uflash:w:");
        try tmp.appendSlice(bin_path);
        try tmp.appendSlice(":e");
        break :blk tmp.toOwnedSlice();
    };

    const upload = b.step("upload", "Upload the code to an Arduino device using avrdude");
    const avrdude = b.addSystemCommand(&.{
        "avrdude",
        "-CC:\\Program Files (x86)\\Arduino\\hardware\\tools\\avr\\etc\\avrdude.conf",
        "-carduino",
        "-patmega328p",
        "-D",
        "-P",
        tty,
        flash_command,
    });
    upload.dependOn(&avrdude.step);
    avrdude.step.dependOn(&exe.install_step.?.step);

    const objdump = b.step("objdump", "Show dissassembly of the code using avr-objdump");
    const avr_objdump = b.addSystemCommand(&.{
        "avr-objdump",
        "-dhS",
        bin_path,
    });
    objdump.dependOn(&avr_objdump.step);
    avr_objdump.step.dependOn(&exe.install_step.?.step);

    const monitor = b.step("monitor", "Opens a monitor to the serial output");
    const screen = b.addSystemCommand(&.{
        "py",
        "-m",
        "serial.tools.miniterm",
        tty,
        "115200",
    });
    monitor.dependOn(&screen.step);

    b.default_step.dependOn(&exe.step);
}
