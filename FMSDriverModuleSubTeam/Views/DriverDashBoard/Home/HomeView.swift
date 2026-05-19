//
//  HomeView.swift
//  FMSDriverModuleSubTeam
//
//  Created by Toffek Usmani on 19/05/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 24) {
                //name + profile
                HStack{
                    VStack(alignment: .leading, spacing: 4){
                        Text("Hello, Toffek")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.primary)
                        
                        Text("Tuesday, 19 May")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Circle()
                            .fill(.gray)
                            .frame(width: 48, height: 48)
                            .overlay(
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 44))
                                    .foregroundStyle(.black)
                            )
                    }
                } //name+profile
                
                //current or next trips(active trip panel)
                VStack(alignment: .leading, spacing: 12) {
                    //section header
                    Text("Current Assignment")
                        .font(.system(size: 18, weight: .bold))
                    
                   
                    
                    
                } //active trip panel
                
                
                // Upcoming Schedule Segment
                VStack(alignment: .leading, spacing: 12) {
                    //section header
                    Text("Upcoming Trips")
                        .font(.system(size: 18, weight: .bold))
                    
                    
                    //                    Text("No further trips assigned today")
                    //                        .font(.system(size: 14))
                    //                        .foregroundStyle(.secondary)
                    //                        .padding(.vertical, 8)
                } //upcoming trip
            } //main vstack
            
            
        } //main scrollView
        .padding()
        .scrollIndicators(.hidden)
    }
}

#Preview {
    HomeView()
}
