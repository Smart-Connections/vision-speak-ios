//
//  RecordVoice.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/10.
//


import SwiftUI
import AVFoundation

class RecordVoice {
    
    var audioRecorder: AVAudioRecorder?
    
    init() {
        // 録音の設定
        
        let recordingSession = AVAudioSession.sharedInstance()
        
        // エラーを確認
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            // 辞書型で設定値を変更
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            // wavファイルのパスを設定する（.wavはリアルタイムに書き込まれる）
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFileURL = documentsPath.appendingPathComponent("recording.wav")
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            
            // audioRecorderがnilでない場合のみバッファ割当てや初期化、設定をする
            audioRecorder?.prepareToRecord()
        }
        
        // エラーの場合
        catch {
            print("Error setting up audio recorder: \(error)")
        }
    }
    
    func startRecording() {
        audioRecorder?.record()
    }
    
    func cancelRecording() {
        audioRecorder?.stop()
    }
    
    func stopRecording() -> URL? {
        audioRecorder?.stop()
        return audioRecorder?.url
    }
}
