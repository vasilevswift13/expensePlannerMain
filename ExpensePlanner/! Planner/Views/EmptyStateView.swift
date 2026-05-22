//
//  EmptyStateView.swift
//  ExpensePlanner
//
//  Created by Igor Lebedev on 28.04.2026.
//

import SwiftUI

struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let message: String
    let buttonTitle: String?
    let buttonAction: (() -> Void)?
    
    init(
        systemImage: String,
        title: String,
        message: String,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: systemImage)
                .font(.system(size: 52))
                .foregroundStyle(.secondary)
            
            Text(title)
                .font(.title3.bold())
            
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            if let buttonTitle, let buttonAction {
                Button(buttonTitle, action: buttonAction)
                    .buttonStyle(PrimaryButtonStyle(isFullWidth: false))
            }
            Spacer()
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
