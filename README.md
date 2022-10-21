# Example Zig Arduino Project

Working with Zig version 0.9.1 stable on Windows.\
It uses the avr-arduino-zig fork as dependency.\
Avrdude is needed to be available in the PATH to flash the binary to the Arduino.

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