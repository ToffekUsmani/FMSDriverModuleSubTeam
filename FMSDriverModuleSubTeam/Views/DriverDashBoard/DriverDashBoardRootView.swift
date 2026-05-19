//
//  DriverDashBoardRootView.swift
//  FMSDriverModuleSubTeam
//
//  Created by Toffek Usmani on 19/05/26.
//

import SwiftUI

struct DriverDashBoardRootView: View {
    var body: some View {
        TabView{
            Tab("Home", systemImage: "house.fill") {
                NavigationStack{
                    Text("Home")
                }
               
            }
            Tab("Trips", systemImage: "map.fill") {
                NavigationStack{
                    Text("trips")
                }
            }
        }
    }
}

#Preview {
    DriverDashBoardRootView()
}
