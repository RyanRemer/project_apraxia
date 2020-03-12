//
//  RecorderManager.swift
//  Runner
//
//  Created by Kara Crowder on 11/21/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import UIKit
import AVFoundation

enum RecordType :String {
	case Wav = "wav"
}

class RecordManager {
	
	var recorder: AVAudioRecorder?
	var player: AVAudioPlayer?
	var recordName:String?
	var fileName: String?
	
	static let sharedInstance = RecordManager()

	private init() {}
	
	func startRecord(recordType: RecordType){
		let session = AVAudioSession.sharedInstance()
		
		do {
			try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
		} catch let err{
			print("error is :\(err.localizedDescription)")
		}
		do {
			try session.setActive(true)
		} catch let err {
			print("error is :\(err.localizedDescription)")
		}
		
		let recordSetting: [String: Any] = [
			AVSampleRateKey: NSNumber(value: 16000),
			AVEncoderBitRateKey:NSNumber(value: 16000),
			AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),
			AVNumberOfChannelsKey: NSNumber(value: 1),
			AVLinearPCMBitDepthKey:NSNumber(value: 16),
			AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.max.rawValue)
		];
		
		do {
			let now = Date()
			let timeInterval: TimeInterval = now.timeIntervalSince1970
			let timeStamp = Int(timeInterval)
			recordName = "\(timeStamp)"
			let fileType = RecordType.Wav
			let filePath = NSHomeDirectory() + "/Documents/\(recordName!).\(fileType)"
			let url = URL(fileURLWithPath: filePath)
			recorder = try AVAudioRecorder(url: url, settings: recordSetting)
			recorder!.prepareToRecord()
			recorder!.record()
			self.fileName = url.absoluteString
		} catch let err {
			print("error is :\(err.localizedDescription)")
		}
	}
	
	
	func stopRecord() -> String {
		if let recorder = self.recorder {
			if recorder.isRecording {
				recorder.stop()
			}
		} else {
			print("Something went wrong with stop record")
		}
		return self.fileName ?? "no file"
	}
}
