//
//  MenuView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/12.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject private var purchaseViewModel: PurchaseViewModel = PurchaseViewModel()
    
    @Binding var showMenu: Bool
    
    init(showMenu: Binding<Bool>) {
        self._showMenu = showMenu
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: PurchaseView().environmentObject(purchaseViewModel)) {
                    ZStack {
                        HStack {
                            Text("ステータス").font(.caption).foregroundColor(.black)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text(purchaseViewModel.getCurrentStatus().name)
                                .font(.title)
                                .foregroundColor(.black)
                            Spacer()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(8)
                }
                .padding()
                Spacer()
            }
            .background(Color(red: 247/255, green: 247/255, blue: 247/255))
            .navigationBarTitle(Text("Menu"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showMenu = false
            }) {
                Text("Done").bold()
            })
        }
    }
}
