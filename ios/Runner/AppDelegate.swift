import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
	
	override func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		GeneratedPluginRegistrant.register(with: self)
		
		let channelName = "wsdCalculator"
		let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
		
		let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: rootViewController.binaryMessenger)
		
		methodChannel.setMethodCallHandler {(call: FlutterMethodCall, result: FlutterResult) -> Void in
			if call.method == "calculateWSD" {
				if let fileNameArray = call.arguments as? [Any] {
					let fileName = fileNameArray[0] as! String
					let syllableCount = fileNameArray[1] as! Int
//					print("file name is: \(fileName)")
//					print("syllable count is: \(syllableCount)")
					let wsdCalculator = WSDCalculator.sharedInstance
					if wsdCalculator.ambianceThreshold == -1.0 {
						result(FlutterError(code: "NO THRESHOLD",
											message: "No ambiance threshold is set",
											details: nil))
					} else {
						let calculatedWSD = wsdCalculator.calculateWSD(for: fileName, with: syllableCount)
						result(calculatedWSD)
					}
				}
			} else if call.method == "stopRecord" {
				let fileName = RecordManager.sharedInstance.stopRecord()
				result(fileName)

			} else if call.method == "startRecorder" {
				RecordManager.sharedInstance.beginRecord(recordType: RecordType.Wav)
			} else if call.method == "calculateAmbiance" {
				// the file name is coming in and storing ambiance in swift
				if let fileNameArray = call.arguments as? [String] {
					let wsdCalculator = WSDCalculator.sharedInstance
					let _ = wsdCalculator.getAmbianceFileThreshold(fileName: fileNameArray[0])
					result("")
				}
			} else if call.method == "getAmplitude" {
				if let fileNameArray = call.arguments as? [String] {
					let wsdCalculator = WSDCalculator.sharedInstance
					result(wsdCalculator.getAmplitudes(fileName: fileNameArray[0]))
				}
			}
		}
		
		return super.application(application, didFinishLaunchingWithOptions: launchOptions)
	}
}


