//
//  PrimaryButton.swift
//  MyGarage
//
//  Created by David on 13.01.26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(isDisabled ? Color.blue.opacity(0.35) : Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .disabled(isDisabled)
    }
}
