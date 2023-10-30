//
//  MenuView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/12.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var purchaseState: PurchaseState
    @ObservedObject private var purchaseViewModel: PurchaseViewModel = PurchaseViewModel()
    
    @Binding var showMenu: Bool
    @Binding var showPurchaseView: Bool
    
    @State private var showAccountView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                MenuStatusButton(showPurchaseView: $showPurchaseView).environmentObject(purchaseViewModel).environmentObject(purchaseState)
                Spacer().frame(height: 16)
                List {
//                    NavigationLink(destination: AccountView(showAccountView: $showAccountView), isActive: $showAccountView) {
//                        Text("アカウント")
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .contentShape(Rectangle())
//                            .onTapGesture {
//                                showAccountView = true
//                            }
//                    }
                    Text("使い方を見る")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showMenu = false
                            CoachMark.turnOnCoachMark()
                        }
                }
                .listStyle(.plain)
                Spacer()
            }
            .background(Color("back"))
            .navigationBarTitle(Text("Menu"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showMenu = false
            }) {
                Text("Done").bold()
            })
        }
    }
}
