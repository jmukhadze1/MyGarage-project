//
//  VehicleDetailsView.swift
//  MyGarage
//
//  Created by David on 21.01.26.
//

import SwiftUI

struct VehicleDetailsView: View {
    @StateObject private var viewModel: VehicleDetailsViewModel

    init(vehicle: Vehicle, servicesProvider: ServicesDataProvider) {
        _viewModel = StateObject(
            wrappedValue: VehicleDetailsViewModel(
                vehicle: vehicle,
                servicesProvider: servicesProvider
            )
        )
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 18) {

                VehicleImage(imageURL: viewModel.imageURLString)
                    .frame(height: 240)

                VehicleInfoCard(
                    title: viewModel.title,
                    year: viewModel.yearText,
                    mileage: viewModel.mileageText,
                    lastService: viewModel.lastServiceText
                )

                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent Services")
                        .font(.system(size: 18, weight: .semibold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 4)
                VStack(spacing: 12) {

                    if viewModel.recentServices.isEmpty {
                        Text("No services for this vehicle yet.")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 16)
                    } else {
                        ForEach(viewModel.recentServices) { service in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(service.title)
                                        .font(.system(size: 16, weight: .semibold))

                                    Text(
                                        DateFormatter.localizedString(
                                            from: service.serviceDate,
                                            dateStyle: .medium,
                                            timeStyle: .none
                                        )
                                    )
                                    .font(.system(size: 13))
                                    .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Text(
                                    NumberFormatter.localizedString(
                                        from: NSNumber(value: service.cost),
                                        number: .currency
                                    )
                                )
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.green)
                            }
                            .padding(14)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal, 16)
                        }
                    }
                }


                Spacer(minLength: 16)
            }
            .padding(.bottom, 24)
        }
        .navigationTitle("Vehicle Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }

    }
    
}


// MARK: Components

private struct VehicleImage: View {
    let imageURL: String?

    var body: some View {
        ZStack {
            Rectangle().fill(Color(.systemGray6))

            if let urlString = imageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable().scaledToFill().clipped()
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .clipped()
    }

    private var placeholder: some View {
        VStack(spacing: 10) {
            Image(systemName: "car.fill")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(Color(.systemGray2))
            Text("No Image")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color(.systemGray2))
        }
    }
}

private struct VehicleInfoCard: View {
    let title: String
    let year: String
    let mileage: String
    let lastService: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 24, weight: .bold))

            VehicleInfoRow(title: "Year", value: year)
            VehicleInfoRow(title: "Mileage", value: mileage)
            VehicleInfoRow(title: "Last Service", value: lastService)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal, 16)
    }
}

private struct VehicleInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 15))
                .foregroundStyle(Color(.systemGray))
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .semibold))
        }
    }
}
