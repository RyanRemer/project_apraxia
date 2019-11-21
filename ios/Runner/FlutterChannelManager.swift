//
//  FlutterChannelManager.swift
//  Runner
//
//  Created by Kara Crowder on 11/20/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

class FlutterChannelManager: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	let channel: FlutterMethodChannel
	let flutterViewController: FlutterViewController
	
	init(flutterViewController: FlutterViewController) {
		
		print("in the flutter channel manager init")
		
		self.flutterViewController = flutterViewController
		let channelName = "wsdCalculator"
		// 1. create channel
		channel = FlutterMethodChannel(name: channelName, binaryMessenger: flutterViewController.binaryMessenger)
	}
	
	func setup() {
		print("in the flutter channel manager setup")
		// 2. set method call handler
		channel.setMethodCallHandler { (call, result) in
			// 3. check call method and arguments
			switch call.method {
				case "calculateWSD":
					let fileName = call.arguments as! String
					self.calculateWSD(fileName: fileName)
				// try? speechController.startRecording()
				//				case "pickImage":
				//					let sourceType: UIImagePickerControllerSourceType = "camera" == (call.arguments as? String) ? .camera : .photoLibrary
				//					// 4. do work and call completion handler (result)
				//					let imagePicker = self.buildImagePicker(sourceType: sourceType, completion: result)
				//					self.flutterViewController.present(imagePicker, animated: true, completion: nil)
				default:
					break
			}
		}
	}
	
	func calculateWSD(fileName: String) {
		print("file name is: \(fileName)")
	}
	
	//	func buildImagePicker(sourceType: UIImagePickerControllerSourceType, completion: @escaping (_ result: Any?) -> Void) -> UIViewController {
	//		if sourceType == .camera && !UIImagePickerController.isSourceTypeAvailable(.camera) {
	//			let alert = UIAlertController(title: "Error", message: "Camera not available", preferredStyle: .alert)
	//			alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
	//				completion(FlutterError(code: "camera_unavailable", message: "camera not available", details: nil))
	//			})
	//			return alert
	//		} else {
	//			return ImagePickerController(sourceType: sourceType) { image in
	//				self.flutterViewController.dismiss(animated: true, completion: nil)
	//				if let image = image {
	//					completion(self.saveToFile(image: image))
	//				} else {
	//					completion(FlutterError(code: "user_cancelled", message: "User did cancel", details: nil))
	//				}
	//			}
	//		}
	//	}
	//
	//	private func saveToFile(image: UIImage) -> Any {
	//		guard let data = UIImageJPEGRepresentation(image, 1.0) else {
	//			return FlutterError(code: "image_encoding_error", message: "Could not read image", details: nil)
	//		}
	//		let tempDir = NSTemporaryDirectory()
	//		let imageName = "image_picker_\(ProcessInfo().globallyUniqueString).jpg"
	//		let filePath = tempDir.appending(imageName)
	//		if FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil) {
	//			return filePath
	//		} else {
	//			return FlutterError(code: "image_save_failed", message: "Could not save image to disk", details: nil)
	//		}
	//	}
}
