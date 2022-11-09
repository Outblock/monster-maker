//
//  MainTabPage.swift
//  MonsterMaker
//
//  Created by Hao Fu on 1/11/2022.
//

import SwiftUI

struct MainTabPage: View {
    
    @State
    var selectedIndex: Int = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedIndex) {
                MakerPage()
                    .tag(0)
                NFTListPage()
                    .tag(1)
            }
        
            TabBarView(items:[
                .init(image: "create-button-off",
                      selectedImage: "create-button-on"),
                .init(image: "view-button-off" ,
                      selectedImage: "view-button-on")
            ],
                       selectedIndex: $selectedIndex)
        }
    }
}

struct MainTabPage_Previews: PreviewProvider {
    static var previews: some View {
        MainTabPage()
    }
}
