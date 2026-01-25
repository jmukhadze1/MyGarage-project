//
//  VehiclesListView.swift
//  MyGarage
//
//  Created by David on 14.01.26.
//

import SwiftUI

struct VehiclesListView: View {
    
    @StateObject var viewModel: VehiclesViewModel
    
    let onAddTapped: () -> Void
    let onEditTapped: (Vehicle) -> Void
    
    @State private var showDeleteConfirmation = false
    @State private var vehicleIdPendingDeletion: String?
    
    @State private var path = NavigationPath()
    
    
    var body: some View {
        NavigationStack(path: $path) {
            contentView
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
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
                .alert("Delete vehicle?", isPresented: $showDeleteConfirmation) {
                    Button("Delete", role: .destructive) {
                        guard let vehicleId = vehicleIdPendingDeletion else { return }
                        Task {
                            await viewModel.delete(vehicleId: vehicleId)
                        }
                        vehicleIdPendingDeletion = nil
                    }
                    Button("Cancel", role: .cancel) {
                        vehicleIdPendingDeletion = nil
                    }
                } message: {
                    Text("This action cannot be undone.")
                }
                .navigationDestination(for: String.self) { vehicleId in
                    if let vehicle = viewModel.vehicles.first(where: { $0.id == vehicleId }) {
                        VehicleDetailsView(
                            vehicle: vehicle,
                            servicesProvider: FirestoreServicesManager()
                        )
                    } else {
                        Text("Vehicle not found")
                    }
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
                Image(systemName: "car")
                    .font(.system(size: 44))
                    .opacity(0.6)
                
                Text("No vehicles yet")
                    .font(.headline)
                
                Button("Add Vehicle", action: onAddTapped)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .error(let errorMessage):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 40))
                
                Text(errorMessage)
                    .multilineTextAlignment(.center)
                
                Button("Retry") {
                    viewModel.start()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded:
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {

                    Text("My Garage")
                        .font(.largeTitle.bold())
                        .padding(.horizontal, 16)
                        .padding(.top, 8)

                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.vehicles) { vehicle in
                            vehicleCard(vehicle)
                                .contentShape(Rectangle())
                                .onTapGesture { path.append(vehicle.id) }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }

            
        }
    }
    
    // MARK: Vehicle Card
    
    private func vehicleCard(_ vehicle: Vehicle) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.06))
                
                if let imageUrlString = vehicle.imageURL,
                   let imageUrl = URL(string: imageUrlString) {
                    
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                            
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                            
                        case .failure:
                            Image(systemName: "car.fill")
                                .font(.system(size: 44))
                                .opacity(0.35)
                            
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                } else {
                    Image(systemName: "car.fill")
                        .font(.system(size: 44))
                        .opacity(0.35)
                }
            }
            .frame(height: 190)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(vehicle.make) \(vehicle.model)")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button {
                        onEditTapped(vehicle)
                    } label: {
                        Image(systemName: "pencil")
                    }
                    
                    .buttonStyle(.borderless)
                    
                    Button(role: .destructive) {
                        vehicleIdPendingDeletion = vehicle.id
                        showDeleteConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    
                    .buttonStyle(.borderless)
                }
                
                HStack(spacing: 8) {
                    Text("\(vehicle.year)")
                    Text("/")
                    Text("\(vehicle.mileage) miles")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(radius: 10, y: 5)
    }
    
}
