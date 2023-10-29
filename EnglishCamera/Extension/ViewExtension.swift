//
//  ViewExtension.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/17.
//

import Foundation
import SwiftUI

extension View {
    
    func showProgressView(show: Binding<Bool>) -> some View {
        ZStack {
            self
            if show.wrappedValue {
                AppProgressView()
            }
        }
    }
    
    func showCoachMark(show: Binding<Bool>, text: String, showOnWidget: Bool = false) -> some View {
        Group {
            if !show.wrappedValue {
                self
            } else {
                GeometryReader { geometry in
                    self.fullScreenCover(isPresented: show) {
                        ZStack(alignment: .topLeading) {
                            ZStack(alignment: .topLeading) {
                                Color("onSurface").opacity(0.7)
                                Rectangle()
                                    .cornerRadius(8)
                                    .frame(width: geometry.size.width + 16, height: geometry.size.height + 16)
                                    .offset(x:geometry.frame(in: .global).minX - 8, y:geometry.frame(in: .global).minY - 8)
                                    .blendMode(.destinationOut)
                            }
                            .compositingGroup()
                            .ignoresSafeArea()
                            .background(BackgroundBlurView())
                            Text(text).foregroundColor(.white).padding(.horizontal, 16).offset(y:CoachMarkHelper.textYPosition(geometry: geometry, showOnWidget: showOnWidget))
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

class CoachMarkHelper {
    static func textYPosition(geometry: GeometryProxy, showOnWidget: Bool = false) -> Double {
        if showOnWidget {
            return (geometry.frame(in: .global).minY - 108)
        } else {
            return (geometry.frame(in: .global).maxY - 32)
        }
    }
}
