//
//  SettingRow.swift
//  FMSDriverModuleSubTeam
//
//  Created by Toffek Usmani on 21/05/26.
//

import SwiftUI

struct SettingRow: View {
    var icon: String
    var title: String
    var body: some View {
        HStack(spacing: 18) {
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(width: 28)
            
            Text(title)
                .font(.title3)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundStyle(.tertiary)
        }
        .padding(22)
    }
}

