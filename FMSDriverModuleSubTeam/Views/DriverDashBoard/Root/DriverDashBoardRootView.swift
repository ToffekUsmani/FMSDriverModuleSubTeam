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
                
                HomeView()
                
                
            }
            Tab("Trips", systemImage: "map.fill") {
                
                TripsView()
                
            }
            
            Tab("Issues", systemImage: "gearshape.2.fill") {
                IssuesView()
            }
        }
    }
}

#Preview {
    DriverDashBoardRootView()
}
