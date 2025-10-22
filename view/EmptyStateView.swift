//
//  EmptyStateView.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

import SwiftUI

struct EmptyStateView: View {
    var imageName: String = "emptybook"
    var title: String = "Begin Your Journal"
    var message: String = "Craft your personal diary, tap the plus icon to begin."

    var body: some View {
        VStack(spacing: 14) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .accessibilityHidden(true)

            Text(title)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.lavender)

            Text(message)
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.horizontal, 28)
                .accessibilityLabel(message.replacingOccurrences(of: "\n", with: " "))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.top, 60)
        .background(Color(.systemBackground).ignoresSafeArea())
    }
}

#Preview {
    EmptyStateView()
        .preferredColorScheme(.dark)
}
