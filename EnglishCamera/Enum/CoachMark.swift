//
//  CoachMark.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/18.
//

import Foundation

enum CoachMark: String, CaseIterable {
    case todayStudy = "coachMarkTodayStudy"
    case vocabularySetting = "coachMarkVocabularySetting"
    case searchVocabulary = "coachMarkSearchVocabulary"
    case realTimeAnalyzeImage = "coachMarkRealTimeAnalyzeImage"
    case sendVoice = "coachMarkSendVoice"
    case finishConversation = "coachMarkFinishConversation"
    case feedbackView = "coachMarkFeedbackView"
    
    static func turnOnCoachMark() {
        CoachMark.allCases.forEach { value in
            UserDefaults.standard.set(true, forKey: value.rawValue)
        }
    }
}
