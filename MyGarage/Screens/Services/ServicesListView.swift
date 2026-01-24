//
//  ServicesListView.swift
//  MyGarage
//
//  Created by David on 21.01.26.
//

import SwiftUI
import FirebaseAuth

struct ServicesListView: View {

    @StateObject var viewModel: ServicesViewModel

    @State private var showAddService = false
    @State private var editingService: Service? = nil
    @State private var showDeleteAlert = false
    @State private var serviceToDelete: Service? = nil

    private let provider: ServicesDataProvider
    private let vehicles: [Vehicle]

    init(viewModel: ServicesViewModel, provider: ServicesDataProvider, vehicles: [Vehicle]) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.provider = provider
        self.vehicles = vehicles
    }

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Services")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showAddService = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                }
                .onAppear { viewModel.start() }
                .onDisappear { viewModel.stop() }

                .sheet(isPresented: $showAddService) {
                    ServiceFormView(
                        mode: .add,
                        provider: provider,
                        vehicles: vehicles
                    )
                }

                .sheet(item: $editingService) { service in
                    ServiceFormView(
                        mode: .edit(service),
                        provider: provider,
                        vehicles: vehicles
                    )
                }

                .alert("Delete service?", isPresented: $showDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        Task {
                            await deleteService()
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        serviceToDelete = nil
                    }
                } message: {
                    Text("This action cannot be undone.")
                }
        }
    }

    // MARK: Content

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

                Button("Add Service") {
                    showAddService = true
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .error(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 40))
                Text(message)
                Button("Retry") { viewModel.start() }
            }
            .padding()

        case .loaded:
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(viewModel.services) { service in
                        serviceCard(service)
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 16)
            }
        }
    }

    // MARK: Card

    private func serviceCard(_ service: Service) -> some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(spacing: 12) {

                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.blue.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Image(systemName: service.iconName ?? "wrench.and.screwdriver")
                        .foregroundStyle(.blue)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(service.title).font(.headline)
                    Text(service.vehicleName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(
                    NumberFormatter.localizedString(
                        from: NSNumber(value: service.cost),
                        number: .currency
                    )
                )
                .foregroundStyle(.green)

                HStack(spacing: 10) {
                    Button {
                        editingService = service
                    } label: {
                        Image(systemName: "pencil")
                    }

                    Button {
                        serviceToDelete = service
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
                .buttonStyle(.plain)
            }

            Divider().opacity(0.4)

            HStack {
                Label(
                    DateFormatter.localizedString(
                        from: service.serviceDate,
                        dateStyle: .medium,
                        timeStyle: .none
                    ),
                    systemImage: "calendar"
                )

                Spacer()

                Text("\(service.mileage) mi")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK:  Delete

    private func deleteService() async {
        guard let service = serviceToDelete else {
            return
        }

        guard let userId = Auth.auth().currentUser?.uid else {
            serviceToDelete = nil
            return
        }
        
        do {
            try await provider.deleteService(userId: userId, serviceId: service.id)
            serviceToDelete = nil
            showDeleteAlert = false
        } catch {
            serviceToDelete = nil
            showDeleteAlert = false
        }
    }


}
