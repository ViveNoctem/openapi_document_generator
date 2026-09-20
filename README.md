Code generation library using `build_runer` to generate an OpenAPI JSON document through annotation and the code itself.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Usage

see `dart_frog` example

## Building
The JsonSerializer and this projects own Builders do not run in the correct order.
To run `dart run build_runner build` you have to comment out the builders section in the generator `build.yaml` file.

## Debug
To debug the builder use this command in an example root folder.
```bash
dart run build_runner clean & dart run build_runner build --dart-jit-vm-arg=--observe --dart-jit-vm-arg=--pause-isolates-on-start --force-jit
```

This will print a DevTools link and wait for you to attach a debugger.
Click the link to open the DevTools or use Android Studio/IntelliJ/Vscode Dart Remote debug to debug in the IDE directly.
