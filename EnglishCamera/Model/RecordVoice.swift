//
//  RecordVoice.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/10.
//


import SwiftUI
import AVFoundation

class RecordVoice {
    
    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?
    
    func startRecording() {
        do {
            self.recordingSession = AVAudioSession.sharedInstance()
            try recordingSession?.setCategory(.playAndRecord, mode: .measurement)
            try recordingSession?.setActive(true)
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFileURL = documentsPath.appendingPathComponent("recording.wav")
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.record()
        }
        
        // エラーの場合
        catch {
            print("Error setting up audio recorder: \(error)")
        }
    }
    
    func cancelRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        do {
            try recordingSession?.setCategory(.playback, mode: .measurement)
            try recordingSession?.setActive(false)
        } catch {
            print("Error setting up audio recorder: \(error)")
        }
        recordingSession = nil
    }
    
    func stopRecording() -> URL? {
        audioRecorder?.stop()
        return audioRecorder?.url
    }
}
