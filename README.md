# Dawn builds

Installing dawn is currently quite a long process (especially with a slow computer). This repository provides a collection of scripts to help automatically build dawn and set it up for installation. After running the build script for your platform, the only thing you need to do is copy `build/lib` and `build/include` to the correct system locations.

If you don't want to build from source and you don't need the latest version, you can download the latest build from the releases tab on GitHub. Or you can use homebrew if you are on macOS.

## Homebrew

This repository has an [accompanying repository](https://github.com/stackotter/homebrew-dawn) which contains a homebrew formula for installing dawn.

```sh
brew tap stackotter/dawn
brew install dawn
```

## Supported platforms

Currently only macOS is supported. Feel free to open a PR adding support for other platforms.