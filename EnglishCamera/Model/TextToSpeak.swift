//
//  TextToSpeak.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/05.
//

import Foundation
import AVFAudio

protocol TextToSpeakDelegate: AnyObject {
    func finishSpeak()
}

class TextToSpeak: NSObject {
    
    weak var delegate: TextToSpeakDelegate?
    
    private let synthesizer = AVSpeechSynthesizer()
    
    func textToSpeak(text: String) {
        synthesizer.delegate = self
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
        synthesizer.speak(utterance)
    }
}

extension TextToSpeak: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.finishSpeak()
    }
    
}
