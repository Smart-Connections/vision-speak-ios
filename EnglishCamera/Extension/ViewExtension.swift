//
//  ViewExtension.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/17.
//

import Foundation
import SwiftUI

extension View {
    
    func showCoachMark(show: Binding<Bool>, text: String) -> some View {
        Group {
            if !show.wrappedValue {
                self
            } else {
                GeometryReader { geometry in
                    self.fullScreenCover(isPresented: show) {
                        ZStack(alignment: .topLeading) {
                            ZStack(alignment: .topLeading) {
                                Color.black.opacity(0.5)
                                Rectangle()
                                    .cornerRadius(8)
                                    .frame(width: geometry.size.width + 16, height: geometry.size.height + 16)
                                    .offset(x:geometry.frame(in: .global).minX - 8, y:geometry.frame(in: .global).minY - 8)
                                    .blendMode(.destinationOut)
                            }
                            .compositingGroup()
                            .ignoresSafeArea()
                            .background(BackgroundBlurView())
                            Text(text).foregroundColor(.white).padding(.trailing, geometry.frame(in: .global).minX - 8).offset(x:geometry.frame(in: .global).minX - 8, y:geometry.frame(in: .global).maxY - 32)
                        }.onTapGesture {
                            show.wrappedValue = false
                        }
                    }.transaction({ transaction in
                        transaction.disablesAnimations = true
                    })
                }
            }
        }
    }
}

struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
