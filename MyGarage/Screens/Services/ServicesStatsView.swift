//
//  ServicesStatsView.swift
//  MyGarage
//
//  Created by David on 23.01.26.
//

import SwiftUI

struct ServicesStatsView: View {

    let totalServices: Int
    let totalSpent: Double

    var body: some View {
        HStack(spacing: 12) {
            statCard(
                icon: "doc.text",
                iconBg: Color.blue.opacity(0.12),
                iconColor: .blue,
                value: "\(totalServices)",
                subtitle: "Total Services"
            )

            statCard(
                icon: "dollarsign.circle.fill",
                iconBg: Color.green.opacity(0.12),
                iconColor: .green,
                value: "$\(Int(totalSpent.rounded()))",
                subtitle: "Total Spent"
            )
        }
    }

    private func statCard(
        icon: String,
        iconBg: Color,
        iconColor: Color,
        value: String,
        subtitle: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {

            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(iconBg)

                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(iconColor)
            }
            .frame(width: 34, height: 34)

            Text(value)
                .font(.system(size: 26, weight: .bold))

            Text(subtitle)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.secondary)

            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 102, alignment: .topLeading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 6)
    }
}

