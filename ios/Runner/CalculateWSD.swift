//
//  CalculateWSD.swift
//  Runner
//
//  Created by Kara Crowder on 11/21/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import AVFoundation

class CalculateWSD {
	
//	func calculateWSD(fileName: String, threshold: Float) {
	func calculateWSD(fileName: String) {
		print("in calculate WSD \(fileName)")
		
		////get multisyllabic word array and rate
		
		let currentWordResponse = getCurrentWordArrayAndRate(for: fileName)
		let currentWordArray = currentWordResponse.0
		let currentWordRate = currentWordResponse.1
		
//		print("ARRAY IS: \(currentMultisyllabicWordArray)")
//		print("RATE IS: \(currentMultisyllabicWordRate)")
		
		////get absolute value of multisyllabic word array
		
		let currentWordArrayAbsValue = getAbsoluteValueArray(for: currentWordArray)

		//		print("response part 1: \(absArray)")
		
		let threshold = getAmbienceFileThreshold()
		
		////		get the count of items in gingerbread word array that are above the threshold - should be around 5280

		let leveledOutCurrentWordArray = levelArrayOut(array: currentWordArrayAbsValue)

		//		let countAboveThreshold = getCountAboveThreshold(array: gingerbreadArrayAbsValue, threshold: threshold)
		let countAboveThreshold = getCountAboveThreshold(for: leveledOutCurrentWordArray, with: threshold)

//		print("COUNT ABOVE THRESHOLD IS: \(countAboveThreshold)")

		let speechInMS = (Double(countAboveThreshold) / currentWordRate) * 1000
		//
		print("SPEECH IN MS: \(speechInMS)")
		//
		print("WSD: \(speechInMS / 3)")
	}
	
	func loadAudioSignal(audioURL: URL) -> (signal: [Float], rate: Double, frameCount: Int) {
		let file = try! AVAudioFile(forReading: audioURL)
		let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false)!
		let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: UInt32(file.length))
		
		try? file.read(into: buf!)
//		print("buffer \(buf)")
		
		let floatArray = Array(UnsafeBufferPointer(start: buf?.floatChannelData![0], count:Int(buf!.frameLength)))
		return (signal: floatArray, rate: file.fileFormat.sampleRate, frameCount: Int(file.length))
	}
	
	func getCurrentWordArrayAndRate(for fileName: String) -> ([Float], Double) {
		
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		
		let wavFile = String(fileName.split(separator: "/").last!)
		
		let documentDirectory = urls as URL
		
		let soundURL = documentDirectory.appendingPathComponent(wavFile)
		
		print("sound url is: \(soundURL)")
		
		let currentMultisyllabicWordResponse = loadAudioSignal(audioURL: soundURL)
		
//		return ([],0.0)
		return (currentMultisyllabicWordResponse.signal, currentMultisyllabicWordResponse.rate)
	}
	
	func getAmbienceFileThreshold() -> Float {
//		for ambienceThreshold file
//	func getAmbienceFileThreshold(fileName: String) -> Float {
		////get ambient array
		
		let ambienceFileArray = getAmbienceFileArray()
//		for ambienceThreshold file
//		let ambienceArray = getThresholdFileArray(fileName: fileName)
		
		////get threshold from the ambience array
		
		let threshold = getThreshold(for: getAbsoluteValueArray(for: ambienceFileArray))
		//		let threshold = getThreshold(array: ambienceArray)
		//		for ambienceThreshold file
		
		print("THRESHOLD IS: \(threshold)")
		return threshold
	}
	
//		for ambienceThreshold file
//	func getThresholdFileArray(fileName: String) -> [Float] {
	func getAmbienceFileArray() -> [Float] {
		let ambienceUrl = Bundle.main.url(forResource: "ambience", withExtension: "wav")
//		let response = getGingerbreadArrayAndRate(fileName: fileName)
//		for ambienceThreshold file
		
		let ambienceResponse = loadAudioSignal(audioURL: ambienceUrl!)
		
		return ambienceResponse.signal
//		return response.0
//		for ambienceThreshold file
	}
	
	func getAbsoluteValueArray(for originalArray: [Float]) -> [Float] {
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
	
	func getThreshold(for array: [Float]) -> Float {
		var arrayHere = array
		arrayHere.sort()
		//		return array.max()!
		return arrayHere[Int(0.992 * Double(arrayHere.count))]
		//		return arrayHere[arrayHere.count - 10]
		//		return arrayHere.max()!
	}
	
	func getCountAboveThreshold(for array: [Float], with threshold: Float) -> Int {
		var count = 0
		for item in array {
			if item >= threshold {
				count += 1
			}
		}
//		print("THRESHOLD IN THIS IS \(threshold)")
		return count
	}
	
}
