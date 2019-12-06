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
	case Caf = "caf"
	case Wav = "wav"
}

class RecordManager {
	
	var recorder: AVAudioRecorder?
	var player: AVAudioPlayer?
	var recordName:String?
	var fileName: String?
	
	static let sharedInstance = RecordManager()

	private init() {

	}
	
	func beginRecord(recordType:RecordType){
		let session = AVAudioSession.sharedInstance()
		
		do {
			try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
//			try session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
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
			let timeInterval:TimeInterval = now.timeIntervalSince1970
			let timeStamp = Int(timeInterval)
			recordName = "\(timeStamp)"
//			let fileType = (recordType == RecordType.Caf) ? "caf" : "wav"
			let fileType = "wav"
			let filePath = NSHomeDirectory() + "/Documents/\(recordName!).\(fileType)"
			let url = URL(fileURLWithPath: filePath)
			recorder = try AVAudioRecorder(url: url, settings: recordSetting)
			recorder!.prepareToRecord()
			recorder!.record()
			self.fileName = url.absoluteString
//			print("recording has started \(url) \(recorder)")
		} catch let err {
			print("error is :\(err.localizedDescription)")
		}
	}
	
	
	func stopRecord() -> String {
//		self.recorder?.stop()
		if let recorder = self.recorder {
//			print("recorder is recording??? \(recorder.isRecording)")
			if recorder.isRecording {
				recorder.stop()
			}
//			print("recorder is recording after??? \(recorder.isRecording)")
//			print("stopping the recording \(recorder)")
//			self.recorder = nil
		}else {
			print("something went wrong")
		}
		return self.fileName ?? "no file"
	}
	
	
	func play(recordType:RecordType) {
		do {
			let fileType = (recordType == RecordType.Caf) ? "caf" : "wav"
			let filePath = NSHomeDirectory() + "/Documents/\(recordName!).\(fileType)"
			player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
			print("player duration is：\(player!.duration)")
			player!.play()
		} catch let err {
			print("error is :\(err.localizedDescription)")
		}
	}
}
