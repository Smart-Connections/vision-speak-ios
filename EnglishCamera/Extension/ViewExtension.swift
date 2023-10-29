//
//  ViewExtension.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/17.
//

import AVFoundation
import Foundation
import SwiftUI

extension View {
    
    func showMicPermissionDialogIfNeeded(tryShow: Binding<Bool>) -> some View {
        Group {
            if !tryShow.wrappedValue {
                self
            } else if AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) == .authorized {
                self
            } else {
                self.alert("アプリを使用するにはマイクを使用する必要があります。", isPresented: tryShow) {
                    Button("キャンセル") {}
                    Button("設定を開く") {
                        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { granted in
                            if (granted == false) {
                                DispatchQueue.main.sync {
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    func showCameraPermissionDialogIfNeeded(tryShow: Binding<Bool>) -> some View {
        Group {
            if !tryShow.wrappedValue {
                self
            } else if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized {
                self
            } else {
                self.alert("アプリを使用するにはカメラを使用する必要があります。", isPresented: tryShow) {
                    Button("キャンセル") {}
                    Button("設定を開く") {
                        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                            if (granted == false) {
                                DispatchQueue.main.sync {
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
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
