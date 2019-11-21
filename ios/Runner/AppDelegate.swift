import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
	
//	var flutterChannelManager: FlutterChannelManager!
	
	override func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		GeneratedPluginRegistrant.register(with: self)
		//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
		
		print("in the app delegate")
		
//		guard let controller = window.rootViewController as? FlutterViewController else {
//			print("in this failure")
//			fatalError("Invalid root view controller")
//		}

		//	let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
		//
		//	let methodChannel = FlutterMethodChannel(name: "wsdCalculator", binaryMessenger: rootViewController.binaryMessenger)


		//	let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController

//		flutterChannelManager = FlutterChannelManager(flutterViewController: controller)
//		flutterChannelManager.setup()
		
		print("this is here")
		
		let channelName = "wsdCalculator"
		let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
		
		print("this is here 3")
		
		let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: rootViewController.binaryMessenger)
		
		print("this is here 3")
		
		methodChannel.setMethodCallHandler {(call: FlutterMethodCall, result: FlutterResult) -> Void in
			print("call method is: \(call.method)")
			if call.method == "calculateWSD" {
				print("this is here 4 \(call.arguments)")
//				print("this is here 5 \(call.arguments as! String)")
				if let fileNameArray = call.arguments as? [String] {
					print("this is here 5 \(fileNameArray)")
					self.calculateWSD(fileName: fileNameArray[0])
				}
				// try? speechController.startRecording()
			} else if call.method == "stopRecorder" {
				print("here it is stopping")
			}
		}
		
		return super.application(application, didFinishLaunchingWithOptions: launchOptions)
	}
		
	func calculateWSD(fileName: String) {
		print("in calculate WSD \(fileName)")
		
		////get gingerbread word array and rate
		
		let gingerbreadResponse = getGingerbreadArrayAndRate(fileName: fileName)
		let gingerbreadArray = gingerbreadResponse.0
		let gingerbreadRate = gingerbreadResponse.1
		
		print("ARRAY IS: \(gingerbreadArray)")
		print("RATE IS: \(gingerbreadRate)")
		
		////get absolute value of gingerbread word array
		
//		let gingerbreadArrayAbsValue = getAbsoluteValueArray(originalArray: gingerbreadArray)
//
//		//		print("response part 1: \(absArray)")
//
//		////get ambient array
//
//		let ambienceArray = getThresholdFileArray()
//
//		//		print("AMBIENCE ARRAY: \(ambienceArray)")
//		//		print("AMBIENCE ARRAY count: \(ambienceArray.count)")
//		//		print("gingerbread ARRAY count: \(gingerbreadArray.count)")
//
//		////get threshold from the ambience array
//
//		let threshold = getThreshold(array: getAbsoluteValueArray(originalArray: ambienceArray))
//		//		let threshold = getThreshold(array: ambienceArray)
//
//		//		print("ambience array: \(ambienceResponse.signal)")
//
//		print("THRESHOLD IS: \(threshold)")
//
//		////		get the count of items in gingerbread word array that are above the threshold - should be around 5280
//
//		let leveledOut = levelArrayOut(array: gingerbreadArrayAbsValue)
//
//		//		let countAboveThreshold = getCountAboveThreshold(array: gingerbreadArrayAbsValue, threshold: threshold)
//		let countAboveThreshold = getCountAboveThreshold(array: leveledOut, threshold: threshold)
//
//		//		print("MAX IN GINGERBREAD ARRAY: \(gingerbreadArrayAbsValue.max())")
//		//		print("MIN IN GINGERBREAD ARRAY: \(gingerbreadArrayAbsValue.min())")
//
//		print("COUNT ABOVE THRESHOLD IS: \(countAboveThreshold)")
//
//
//		//		areArraysEqual(arrayOne: gingerbreadArray, arrayTwo: ambienceArray)
//
//		//		speech samples / sample rate * 1000 = speech in ms and then divide by syllables
//
//		//response rate is 8000
//		//count above threshold should be 5280
//		//speech in ms should be around 660
//
//		//660 = x / 8000 * 1000
//		//660 = x / 8
//		//660 * 8 = 5280
//		//count above threshold should be 5280
//
//		let speechInMS = (Double(countAboveThreshold) / gingerbreadRate) * 1000
//		//
//		print("SPEECH IN MS: \(speechInMS)")
//		//
//		print("WSD: \(speechInMS / 3)")
	}
	
	func loadAudioSignal(audioURL: URL) -> (signal: [Float], rate: Double, frameCount: Int) {
		let file = try! AVAudioFile(forReading: audioURL)
		print("file is: \(file)")
		print("file format is: \(file.fileFormat)")
		print("file length is: \(file.length)")
		print("file process format is: \(file.processingFormat)")
		print("file frame position is: \(file.framePosition)")
//		let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false)!
		let format = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false)!
		print("format is: \(format)")
		let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: UInt32(file.length))
		print("buffer \(buf)")
//		try! file.read(into: buf) // You probably want better error handling
//		let floatArray = Array(UnsafeBufferPointer(start: buf?.floatChannelData![0], count:Int(buf!.frameLength)))
//		return (signal: floatArray, rate: file.fileFormat.sampleRate, frameCount: Int(file.length))
		return (signal: [], rate: 0.0, frameCount: 0)
	}
	
	func getGingerbreadArrayAndRate(fileName: String) -> ([Float], Double) {
		//		let gingerbreadUrl = Bundle.main.url(forResource: "gingerbread", withExtension: "wav")
//		let gingerbreadUrl = Bundle.main.url(forResource: "gingerbread_ct", withExtension: "wav")
//		let gingerbreadUrl = Bundle.main.url(forResource: fileName, withExtension: "wav")
		
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		
		let wavFile = String(fileName.split(separator: "/").last!)
		
		print("wav file is: \(wavFile)")
		
		print("urls are: \(urls)")
		
		let documentDirectory = urls as URL
		
//		let fileURLs = try? FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
		
//		let documentDirectory = URL(fileURLWithPath: "file:///var/mobile/Containers/Data/Application/9BA0257E-DEFC-46D2-9F95-1065EEAB3B7B/Documents/")
		
		print("doc direct are: \(documentDirectory)")
		
//		print("file urls are: \(fileURLs)")
		
		let soundURL = documentDirectory.appendingPathComponent(wavFile)

		print("sound url is: \(soundURL)")
		
		let gingerbreadResponse = loadAudioSignal(audioURL: soundURL)
		
//		return ([],0.0)
		return (gingerbreadResponse.signal, gingerbreadResponse.rate)
	}
	
	func getThresholdFileArray() -> [Float] {
		//		let ambienceUrl = Bundle.main.url(forResource: "ambience", withExtension: "wav")
		let ambienceUrl = Bundle.main.url(forResource: "ambience_ct", withExtension: "wav")
		
		let ambienceResponse = loadAudioSignal(audioURL: ambienceUrl!)
		
		return ambienceResponse.signal
	}
	
	func getAbsoluteValueArray(originalArray: [Float]) -> [Float] {
		return originalArray.map { abs($0) }
	}
	
	func levelArrayOut(array: [Float]) -> [Float] {
		
		//		var leveledOutArray = array.copy()
		var leveledOutArray = array.map { $0 }
		
		for i in 20..<(array.count - 20) {
			let subArray = array[(i - 20)...(i + 20)]
			let maxInSubArray = subArray.max()!
			leveledOutArray[i] = maxInSubArray
		}
		
		return leveledOutArray
	}
	
	func findMaxWithinRange() -> Float {
		return 0.0
	}
	
	func getThreshold(array: [Float]) -> Float {
		var arrayHere = array
		arrayHere.sort()
		//		print("MAX IS: \(arrayHere.max())")
		//		print("MIN IS: \(arrayHere.min())")
		//		print("threshold could be: \(arrayHere[arrayHere.count - 1100])")
		//		return array.max()!
		return arrayHere[Int(0.992 * Double(arrayHere.count))]
		//		return arrayHere[arrayHere.count - 10]
		//		return arrayHere.max()!
	}
	
	func getCountAboveThreshold(array: [Float], threshold: Float) -> Int {
		var count = 0
		for item in array {
			if item >= threshold {
				count += 1
			}
		}
		print("THRESHOLD IN THIS IS \(threshold)")
		return count
	}
}


