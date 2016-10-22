[![Build Status](https://travis-ci.org/up-n-down/DirectoryMonitor.svg?branch=travis)](https://travis-ci.org/up-n-down/DirectoryMonitor)
[![Swift](https://img.shields.io/badge/Swift-3.0-green.svg)](https://swift.org)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-blue.svg?style=flat)](https://swift.org/package-manager/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# DirectoryMonitor

DirectoryMonitor is used to monitor the contents of the provided directory by using a GCD dispatch source.

## Installation

DirectoryMonitor supports multiple methods for installing the library in a project. You can find the latest version in the [release tab](https://github.com/up-n-down/directorymonitor/releases/latest).

### Installation with Swift Package Manager

To integrate DirectoryMonitor into your Xcode project using [Swift Package Manager](https://swift.org/package-manager/), specify it in your `Package.swift` file:

``` Swift
import PackageDescription

let package = Package(
    [...]
    dependencies: [
        .Package(url: "https://github.com/up-n-down/DirectoryMonitor.git", majorVersion: XYZ)
    ]
)
```

### Installation with Carthage

To integrate DirectoryMonitor into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:

```
github "up-n-down/DirectoryMonitor" ~> X.Y.Z
```

Run `carthage update` to build the framework and drag the built DirectoryMonitor.framework into your Xcode project.

## Usage

1. Create a new `DirectoryMonitor` + specify the `URL` that should be monitored
2. Start monitoring and provide an `EventHandler`
3. Enjoy your directory changes 🎉

``` Swift
let url = URL(fileURLWithPath: "~/Documents")
let monitor = DirectoryMonitor(at: url)
monitor.startMonitoring {
  print("Directory did change.")
}
```

You can simply stop monitoring your directory with calling `monitor.stopMonitoring()`. That's it. It's that simple to use `DirectoryMonitor`.

## Copyright

All fame to Apple! This project is based on an [example code](https://developer.apple.com/library/content/samplecode/Lister/Listings/ListerKit_DirectoryMonitor_swift.html), ported to Swift 3 and slightly changed.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
