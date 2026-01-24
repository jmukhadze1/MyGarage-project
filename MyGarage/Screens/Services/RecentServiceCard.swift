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

                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBlue).opacity(0.12))
                        .frame(width: 44, height: 44)

                    Image(systemName: item.iconName ?? "wrench.and.screwdriver")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.blue)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 14, weight: .semibold))

                    Text(item.vehicleName)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(
                    NumberFormatter.currencyGEL.string(from: NSNumber(value: item.cost)) ?? ""
                )
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color(.systemGreen))
            }

            Divider().opacity(0.4)

            HStack(spacing: 16) {

                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                    Text(
                        DateFormatter.mediumDate.string(from: item.serviceDate)
                    )
                }

                HStack(spacing: 6) {
                    Image(systemName: "speedometer")
                    Text("\(item.mileage) mi")
                }
            }
            .font(.system(size: 13))
            .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private extension NumberFormatter {
    static let currencyGEL: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "GEL"
        return formatter
    }()
}

private extension DateFormatter {
    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
