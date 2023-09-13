//
//  Vocabulary.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/10.
//

import RealmSwift
import Foundation

class Vocabulary: Object, Identifiable {
    @Persisted var id = UUID()
    @Persisted var vocabulary: String
    @Persisted var part: Part
    @Persisted var situcation: Situation
    @Persisted var scene: ConversationStyle
    @Persisted var difficulty: Difficulty
    @Persisted var learned: Bool
    @Persisted var updatedAt: String // yyyy/MM/dd
    @Persisted var createdAt: String // yyyy/MM/dd
    
    convenience init(
        vocabulary: String,
        part: Part,
        situcation: Situation,
        scene: ConversationStyle,
        difficulty: Difficulty,
        learned: Bool = false,
        updatedAt: String = Date().ymd,
        createdAt: String = Date().ymd
    ) {
        self.init()
        self.vocabulary = vocabulary
        self.part = part
        self.situcation = situcation
        self.scene = scene
        self.difficulty = difficulty
        self.learned = learned
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

enum Part: String, PersistableEnum {
    case noun = "名詞"
    case verb = "動詞"
    case adjective = "形容詞"
    case adverb = "副詞"
    case preposition = "前置詞"
    case conjunction = "接続詞"
    case interjection = "感動詞"
    case pronoun = "代名詞"
}

enum Situation: String, PersistableEnum {
    case daily = "日常会話"
    case business = "ビジネス会話"
}

enum ConversationStyle: String, PersistableEnum {
    case casual = "カジュアル"
    case formal = "フォーマル"
}

enum Difficulty: String, PersistableEnum {
    case easy = "簡単"
    case normal = "普通"
    case hard = "難しい"
}

enum VocabularyType: String, PersistableEnum {
    case word = "単語"
    case sentence = "短文"
    case idiom = "イディオム"
}
