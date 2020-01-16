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
//				[fileName, syllableCount, evaluationId]
				if let fileNameArray = call.arguments as? [String] {
					let calculateWSD = CalculateWSD.sharedInstance
					calculateWSD.calculateWSD(fileName: fileNameArray[0])
				}
			} else if call.method == "stopRecord" {
				let fileName = RecordManager.sharedInstance.stopRecord()
				result(fileName)

			} else if call.method == "startRecorder" {
				RecordManager.sharedInstance.beginRecord(recordType: RecordType.Wav)
			} else if call.method == "calculateAmbiance" {
				// the file name is coming in and storing ambiance in swift
				if let fileNameArray = call.arguments as? [String] {
					let calculateWSD = CalculateWSD.sharedInstance
					result(calculateWSD.getAmbianceFileThreshold(fileName: fileNameArray[0]))
				}
			} else if call.method == "getAmplitude" {
				if let fileNameArray = call.arguments as? [String] {
					let calculateWSD = CalculateWSD.sharedInstance
					result(calculateWSD.getAmplitudes(fileName: fileNameArray[0]))
				}
			}
		}
		
		return super.application(application, didFinishLaunchingWithOptions: launchOptions)
	}
}


