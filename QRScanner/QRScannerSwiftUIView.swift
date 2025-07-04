import SwiftUI

// MARK: - QRScannerSwiftUIView
public struct QRScannerSwiftUIView: UIViewRepresentable {
    
    // MARK: - Configuration
    public struct Configuration {
        public let focusImage: UIImage?
        public let focusImagePadding: CGFloat
        public let animationDuration: Double
        public let isBlurEffectEnabled: Bool
        
        public init(
            focusImage: UIImage? = nil,
            focusImagePadding: CGFloat = 8.0,
            animationDuration: Double = 0.5,
            isBlurEffectEnabled: Bool = false
        ) {
            self.focusImage = focusImage
            self.focusImagePadding = focusImagePadding
            self.animationDuration = animationDuration
            self.isBlurEffectEnabled = isBlurEffectEnabled
        }
    }
    
    // MARK: - Properties
    private let configuration: Configuration
    private let onSuccess: (String) -> Void
    private let onFailure: (QRScannerError) -> Void
    private let onTorchActiveChange: ((Bool) -> Void)?
    @Binding private var isScanning: Bool
    @Binding private var torchActive: Bool
    
    // MARK: - Initializers
    public init(
        configuration: Configuration = Configuration(),
        isScanning: Binding<Bool> = .constant(true),
        torchActive: Binding<Bool> = .constant(false),
        onSuccess: @escaping (String) -> Void,
        onFailure: @escaping (QRScannerError) -> Void,
        onTorchActiveChange: ((Bool) -> Void)? = nil
    ) {
        self.configuration = configuration
        self._isScanning = isScanning
        self._torchActive = torchActive
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        self.onTorchActiveChange = onTorchActiveChange
    }
    
    // MARK: - UIViewRepresentable
    public func makeUIView(context: Context) -> QRScannerView {
        let qrScannerView = QRScannerView()
        let input = QRScannerView.Input(
            focusImage: configuration.focusImage,
            focusImagePadding: configuration.focusImagePadding,
            animationDuration: configuration.animationDuration,
            isBlurEffectEnabled: configuration.isBlurEffectEnabled
        )
        qrScannerView.configure(delegate: context.coordinator, input: input)
        context.coordinator.qrScannerView = qrScannerView

        if isScanning {
            qrScannerView.startRunning()
        }

        return qrScannerView
    }
    
    public func updateUIView(_ uiView: QRScannerView, context: Context) {
        if isScanning {
            uiView.startRunning()
        } else {
            uiView.stopRunning()
        }
        
        uiView.setTorchActive(isOn: torchActive)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(
            isScanning: $isScanning,
            torchActive: $torchActive,
            onSuccess: onSuccess,
            onFailure: onFailure,
            onTorchActiveChange: onTorchActiveChange
        )
    }
    
    // MARK: - Coordinator
    public class Coordinator: NSObject, QRScannerViewDelegate {
        @Binding private var isScanning: Bool
        @Binding private var torchActive: Bool
        private let onSuccess: (String) -> Void
        private let onFailure: (QRScannerError) -> Void
        private let onTorchActiveChange: ((Bool) -> Void)?
        
        weak var qrScannerView: QRScannerView?
        
        init(
            isScanning: Binding<Bool>,
            torchActive: Binding<Bool>,
            onSuccess: @escaping (String) -> Void,
            onFailure: @escaping (QRScannerError) -> Void,
            onTorchActiveChange: ((Bool) -> Void)?
        ) {
            self._isScanning = isScanning
            self._torchActive = torchActive
            self.onSuccess = onSuccess
            self.onFailure = onFailure
            self.onTorchActiveChange = onTorchActiveChange
        }
        
        public func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
            Task { @MainActor in
                self.isScanning = false
            }
            onSuccess(code)
        }
        
        public func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
            onFailure(error)
        }
        
        public func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
            Task { @MainActor in
                self.torchActive = isOn
            }
            onTorchActiveChange?(isOn)
        }
    }
}

