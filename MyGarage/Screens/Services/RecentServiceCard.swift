//
//  RecentServiceCard.swift
//  MyGarage
//
//  Created by David on 21.01.26.
//

import SwiftUI

struct RecentServiceCard: View {
    let item: Service

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(alignment: .top, spacing: 12) {
                iconBox

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 14, weight: .semibold))

                    Text(item.vehicleName)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(price(item.cost))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(.systemGreen))
            }

            Divider().opacity(0.4)

            HStack(spacing: 16) {
                infoChip(icon: "calendar", text: date(item.serviceDate))
                infoChip(icon: "speedometer", text: "\(item.mileage) mi")
            }
            .font(.system(size: 13))
            .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var iconBox: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBlue).opacity(0.12))
                .frame(width: 20, height: 20)

            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 16, weight: .semibold))
        }
    }

    private func infoChip(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
    }

    private func date(_ d: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        return dateFormat.string(from: d)
    }

    private func price(_ value: Double) -> String {
        let numFormat = NumberFormatter()
        numFormat.numberStyle = .currency
        numFormat.currencyCode = "Gel"
        return numFormat.string(from: NSNumber(value: value)) ?? ""
    }
}
