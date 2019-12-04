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
//			print("call method is: \(call.method)")
			if call.method == "calculateWSD" {
//				print("this is here 4 \(call.arguments)")
//				guard let args = call.arguments else { return }
//				if let myArgs = args as? [String: Any] {
//					print("args are good: \(myArgs)")
//					if let fileName = myArgs["fileName"] as? String {
//						print("file name is good: \(fileName)")
////					let someInfo1 : String = args["filename"]
//						if let ambienceThreshold = myArgs["ambienceThreshold"] as? Float {
//
//							print("fileName: \(fileName)")
//							print("ambienceThreshold: \(ambienceThreshold)")
//		//					if let fileName = myArgs["filename"] as? String,
//		//					let ambienceThreshold = myArgs["ambienceThreshold"] as? Double {
//							let calculateWSD = CalculateWSD()
//							//					calculateWSD.calculate()
//							calculateWSD.calculateWSD(fileName: fileName, threshold: ambienceThreshold)
//						}
//					}
//	//					result("Params received on iOS = \(someInfo1), \(someInfo2)")
//				}
//				print("this is here 5 \(call.arguments as! String)")
				if let fileNameArray = call.arguments as? [String] {
					let calculateWSD = CalculateWSD()
					calculateWSD.calculateWSD(fileName: fileNameArray[0])
				}
//			}
			} else if call.method == "stopRecord" {
//				print("here it is stopping")
				let fileName = RecordManager.sharedInstance.stopRecord()
//				print("after stopped recording in swift \(fileName)")
				result(fileName)

			} else if call.method == "startRecorder" {
//				print("in start recorder")
				RecordManager.sharedInstance.beginRecord(recordType: RecordType.Wav)
			} else if call.method == "calculateAmbience" {
//				print("IN THE AMBIENCE CALCULATING")
				if let fileNameArray = call.arguments as? [String] {
//					print("this is here 10 \(fileNameArray)")
					let calculateWSD = CalculateWSD()
//					result(calculateWSD.getAmbienceFileThreshold(fileName: fileNameArray[0]))
				}
			}
		}
		
		return super.application(application, didFinishLaunchingWithOptions: launchOptions)
	}
}


