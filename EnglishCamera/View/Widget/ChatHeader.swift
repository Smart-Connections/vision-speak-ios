//
//  ChatHeader.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/29.
//

import SwiftUI

struct ChatHeader: View {
    @EnvironmentObject private var viewModel: RealTimeImageClassificationViewModel
    @EnvironmentObject private var studyHistoryState: StudyHistoryState
    @Binding var ShowNextView: Bool
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    ShowNextView = false
                    StudyHistoryDataSource().saveStudyHistory(passedTime: viewModel.passedTime, wordsCount: viewModel.wordsCount)
                    studyHistoryState.refresh()
                }) {
                    Image(systemName: "chevron.left")
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(25)
                }
                Spacer()
            }
            HStack {
                Spacer()
                if (viewModel.remainSeconds == TimeInterval(AppValue.initSecondsSymbol)) {
                    Text("--:--")
                } else {
                    Text("\(viewModel.remainSeconds.ms)")
                }
                Spacer()
            }
        }
    }
}
