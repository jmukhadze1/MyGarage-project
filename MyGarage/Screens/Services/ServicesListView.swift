//
//  ServicesListView.swift
//  MyGarage
//
//  Created by David on 21.01.26.
//

import SwiftUI

struct ServicesListView: View {

    @StateObject var viewModel: ServicesViewModel
    let onAddTapped: () -> Void

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            contentView
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: onAddTapped) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                }
                .onAppear { viewModel.start() }
                .onDisappear { viewModel.stop() }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {

        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty:
            VStack(spacing: 12) {
                Image(systemName: "wrench.and.screwdriver")
                    .font(.system(size: 44))
                    .opacity(0.6)

                Text("No services")
                    .font(.headline)

                Button("Add Service", action: onAddTapped)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .error(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 40))

                Text(message)
                    .multilineTextAlignment(.center)

                Button("Retry") { viewModel.start() }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded:
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ServicesStatsView(
                                 totalServices: viewModel.totalServices,
                                 totalSpent: viewModel.totalSpent
                             )
                             .padding(.horizontal, 16)
                             .padding(.top, 8)

                    
                    Text("Recent Services")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)

                    LazyVStack(spacing: 14) {
                        ForEach(viewModel.services) { service in
                            serviceCard(service)
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
        }
    }

    private func serviceCard(_ service: Service) -> some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(alignment: .top, spacing: 12) {

                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.blue.opacity(0.12))

                    Image(systemName: service.iconName ?? "wrench.and.screwdriver")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.blue)
                }
                .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Text(service.title)
                        .font(.headline)

                    Text(service.vehicleName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(service.cost.asCurrencyUSD())
                    .font(.headline)
                    .foregroundStyle(.green)
            }

            Divider().opacity(0.4)

            HStack(spacing: 14) {
                Label(service.serviceDate.asShortDate(), systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Label(service.mileage.asMilesString(), systemImage: "speedometer")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 10, y: 5)
    }
}

// MARK: - Helpers

private extension Double {
    func asCurrencyUSD() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "Gel"
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

private extension Int {
    func asMilesString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(formatted) mi"
    }
}

private extension Date {
    func asShortDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
