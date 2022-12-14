# Example Zig Arduino Project on Windows

Thanks to @dannypsnl for the original [avr-arduino-zig](https://github.com/dannypsnl/avr-arduino-zig) repo and the [guide](https://dannypsnl.me/blog/2022-01-04-arduino-zig-blink) on how to use it.\
Working with Zig version 0.9.1 stable on Windows.\
It uses [Zigmod](https://github.com/nektro/zigmod) to download the [avr-arduino-zig fork](https://github.com/antlanc7/avr-arduino-zig) as dependency.\
Avrdude is needed to be available in the PATH to flash the binary to the Arduino. If you have installed Arduino IDE you can find it in the `C:\Program Files (x86)\Arduino\hardware\tools\avr\bin` folder.

- `zigmod fetch` to get the dependencies
- `zig build` to build the binary
- `zig build upload` to flash the binary to the Arduino

If you get an error like this:
```
.\deps.zig:70:40: error: no member named 'source' in struct 'std.build.Pkg'
        .pkg = Pkg{ .name = "arduino", .source = .{ .path = dirs._ie76bs50j4tl ++ "/src/arduino.zig" }, .dependencies = null },
```
you have to manually modify the generated `deps.zig` file and change the `source` field to `path`:
```
    .pkg = Pkg{ .name = "arduino", .path = .{ .path = dirs._ie76bs50j4tl ++ "/src/arduino.zig" }, .dependencies = null },
```