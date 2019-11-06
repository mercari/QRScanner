# QRScanner.podspec

Pod::Spec.new do |s|
  s.name         = "QRScanner"
  s.version      = "1.0"
  s.summary      = "A QR Code scanner framework for iOS. Written in Swift."
  s.homepage     = "https://github.com/mercari/QRScanner"
  s.license      = "MIT"
  s.author       = { "hitsubunnu" => "idhitsu@gmail.com" }
  s.swift_version = "5.0"
  s.ios.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/mercari/QRScanner.git", :tag => s.version }
  s.source_files  = "QRScanner/*.swift", "QRScanner/**/*.swift"
end
