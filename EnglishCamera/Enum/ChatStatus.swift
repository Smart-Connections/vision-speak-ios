//
//  CameraStatus.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/06.
//

enum ChatStatus {
    case ready
    case waitingVisionResults
    case waitingSelectVisionResults
    case gptSpeaking
    case inputtingReply
    case stoppingReply
    case waitingGptMessage
}
