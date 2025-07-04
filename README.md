# QRScanner
A modern QR Code scanner framework for iOS with comprehensive SwiftUI and UIKit support. Delivers a native iOS scanning experience with advanced customization options. Written in Swift.

* [日本語のブログ](https://tech.mercari.com/entry/2019/12/12/094129)

|iPhone native camera|QRScanner implementation|
|-|-|
|<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/ios13qr.gif" width="350">|<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/qr.gif" width="350">|

"QR Code" is a registered trademark of DENSO WAVE INCORPORATED

## Features

- 🎯 **Native iOS Design** - Matches iPhone's built-in camera scanning experience
- 🚀 **SwiftUI & UIKit Support** - Full compatibility with both modern and traditional iOS development
- 📱 **iOS 14.0+** - Built for modern iOS with latest Swift features
- ⚡ **Easy Integration** - Simple setup with comprehensive examples
- 🎨 **Highly Customizable** - Extensive configuration options for focus frame, animations, and effects
- 💡 **Production Ready** - Battle-tested in Mercari's production apps

**Quick Start:** [SwiftUI Example](https://github.com/mercari/QRScanner/tree/master/QRScannerSwiftUISample) | [UIKit Example](https://github.com/mercari/QRScanner/tree/master/QRScannerSample)

## Requirements

- **iOS:** 14.0+
- **Swift:** 5.9+
- **Xcode:** 16.0+

## Installation

### Swift Package Manager (Recommended)

#### Via Xcode (Easiest)
1. **File** → **Add Package Dependencies**
2. Enter: `https://github.com/mercari/QRScanner.git`
3. Select version and add to your target

#### Via Package.swift
```swift
dependencies: [
    .package(url: "https://github.com/mercari/QRScanner.git", .upToNextMajor(from: "2.0.0"))
]
```

#### Import
```swift
import QRScanner
```

## Quick Setup

### 1. Camera Permission
Add camera usage description to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for QR code scanning</string>
```

<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/privacy_camera.png" width="500">

### 2. Choose Your Framework
- **SwiftUI**: Modern declarative UI (recommended for new projects)
- **UIKit**: Traditional imperative UI (for existing projects)

Complete examples: [SwiftUI Sample](https://github.com/mercari/QRScanner/tree/master/QRScannerSwiftUISample) | [UIKit Sample](https://github.com/mercari/QRScanner/tree/master/QRScannerSample)

## SwiftUI Usage

> 💡 **Recommended for new projects** - SwiftUI provides a more modern and concise API

### Basic Implementation

```swift
import SwiftUI
import QRScanner
import AVFoundation

struct ContentView: View {
    @State private var scannedCode = ""
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Button("Start Scanning") {
                isPresented = true
            }
            
            if !scannedCode.isEmpty {
                Text("Scanned: \(scannedCode)")
            }
        }
        .sheet(isPresented: $isPresented) {
            QRScannerSwiftUIView(
                onSuccess: { code in
                    scannedCode = code
                    isPresented = false
                },
                onFailure: { error in
                    print("Scan error: \(error)")
                    isPresented = false
                }
            )
        }
    }
}
```

### Advanced Implementation

```swift
struct AdvancedQRScannerView: View {
    @State private var scannedCode = ""
    @State private var isScanning = true
    @State private var torchActive = false
    
    var body: some View {
        VStack {
            QRScannerSwiftUIView(
                configuration: .init(
                    focusImagePadding: 12.0,
                    animationDuration: 0.3,
                    isBlurEffectEnabled: true
                ),
                isScanning: $isScanning,
                torchActive: $torchActive,
                onSuccess: { code in
                    scannedCode = code
                    isScanning = false
                },
                onFailure: { error in
                    print("Error: \(error.localizedDescription)")
                }
            )
            
            HStack {
                Button(isScanning ? "Pause" : "Resume") {
                    isScanning.toggle()
                }
                
                Button("Torch") {
                    torchActive.toggle()
                }
            }
            .padding()
        }
    }
}
```

### Configuration Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `focusImage` | `UIImage?` | `nil` | Custom focus frame image |
| `focusImagePadding` | `CGFloat` | `8.0` | Focus frame padding |
| `animationDuration` | `Double` | `0.5` | Animation duration |
| `isBlurEffectEnabled` | `Bool` | `false` | Enable blur effect |

| Binding | Type | Description |
|---------|------|-------------|
| `isScanning` | `Bool` | Control scanning state |
| `torchActive` | `Bool` | Control torch state |

| Callback | Description |
|----------|-------------|
| `onSuccess` | Called when QR code is successfully scanned |
| `onFailure` | Called when scanning fails |
| `onTorchActiveChange` | Called when torch state changes |

📘 **Complete Example:** [QRScannerSwiftUISample](https://github.com/mercari/QRScanner/tree/master/QRScannerSwiftUISample)

## UIKit Usage

> 🔧 **For existing projects** - UIKit integration with full customization support

### Basic Implementation

```swift
import QRScanner
import AVFoundation

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQRScanner()
    }

    private func setupQRScanner() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupQRScannerView()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async { [weak self] in
                        self?.setupQRScannerView()
                    }
                }
            }
        default:
            showAlert()
        }
    }

    private func setupQRScannerView() {
        let qrScannerView = QRScannerView(frame: view.bounds)
        view.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
    }

    private func showAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let alert = UIAlertController(title: "Error", message: "Camera is required to use in this application", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

extension ViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
    }
}
```

### Customization

```swift
override func viewDidLoad() {
        super.viewDidLoad()

        let qrScannerView = QRScannerView(frame: view.bounds)

        // Customize focusImage, focusImagePadding, animationDuration
        qrScannerView.focusImage = UIImage(named: "scan_qr_focus")
        qrScannerView.focusImagePadding = 8.0
        qrScannerView.animationDuration = 0.5

        qrScannerView.configure(delegate: self)
        view.addSubview(qrScannerView)
        qrScannerView.startRunning()
}
```

#### Interface Builder Way

|Setup Custom Class|Customize|
|-|-|
|<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/ib2.png" width="350">|<img src="https://raw.githubusercontent.com/mercari/QRScanner/master/images/ib1.png" width="350">|

### Adding Flash Control

Example: [FlashButton.swift](https://github.com/mercari/QRScanner/blob/master/QRScannerSample/QRScannerSample/FlashButton.swift)

```swift
final class ViewController: UIViewController {

    ...

    @IBOutlet var flashButton: FlashButton!

    @IBAction func tapFlashButton(_ sender: UIButton) {
        qrScannerView.setTorchActive(isOn: !sender.isSelected)
    }
}

extension ViewController: QRScannerViewDelegate {

    ...

    func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
        flashButton.isSelected = isOn
    }
}
```

### Adding Blur Effect

```swift
qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
```

📘 **Complete Example:** [QRScannerSample](https://github.com/mercari/QRScanner/tree/master/QRScannerSample)

## Committers

* Hitsu ([@hitsubunnu](https://github.com/hitsubunnu))
* Sonny ([@tedbrosby](https://github.com/tedbrosby))
* Daichiro ([@daichiro](https://github.com/daichiro))

## Contribution

Please read the CLA carefully before submitting your contribution to Mercari.
Under any circumstances, by submitting your contribution, you are deemed to accept and agree to be bound by the terms and conditions of the CLA.

https://www.mercari.com/cla/

## License

Copyright 2019 Mercari, Inc.

Licensed under the MIT License.
