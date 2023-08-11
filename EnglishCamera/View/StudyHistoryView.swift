//
//  StudyHistoryView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/05.
//

import SwiftUI
import Charts

struct StudyHistoryView: View {
    @EnvironmentObject private var studyHistoryState: StudyHistoryState

    @State private var selectedIndex = 0
    
    private let segmentPickerTitles = ["学習時間", "使用単語数"]
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: 16)
                Picker("", selection: self.$selectedIndex) {
                    ForEach(0..<self.segmentPickerTitles.count) { index in
                        Text(self.segmentPickerTitles[index])
                            .tag(index)
                    }
                }
                .padding()
                .pickerStyle(SegmentedPickerStyle())
                Spacer().frame(height: 16)
                Chart {
                    ForEach(studyHistoryState.studyHistory) { entry in
                        BarMark(
                            x: .value("日時", String(entry.createdAt.split(separator: "/", maxSplits: 1).last ?? "")),
                            y: .value(self.segmentPickerTitles[selectedIndex], [entry.studyTimeSeconds, entry.userCredits][selectedIndex]),
                            width: .fixed(20)
                        )
                    }
                }
                .padding()
            }.navigationTitle("学習記録")
        }.background(Color(red: 247/255, green: 247/255, blue: 247/255))
    }
}
