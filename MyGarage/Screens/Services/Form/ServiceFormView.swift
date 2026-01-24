//
//  ServiceFormView.swift
//  MyGarage
//
//  Created by David on 24.01.26.
//


import SwiftUI

struct ServiceFormView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: ServiceFormViewModel

    private let vehicles: [Vehicle]

    init(mode: ServiceFormViewModel.Mode, provider: ServicesDataProvider, vehicles: [Vehicle]) {
        _vm = StateObject(wrappedValue: ServiceFormViewModel(mode: mode, provider: provider))
        self.vehicles = vehicles
    }

    @State private var selectedVehicleIndex: Int = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    card("Vehicle") {

                        if vehicles.isEmpty {
                            TextField("Vehicle name", text: $vm.vehicleName)
                                .textInputAutocapitalization(.words)
                                .padding(12)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            Text("No vehicles found. Add a vehicle first.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)

                        } else {
                            Picker("Select vehicle", selection: $selectedVehicleIndex) {
                                ForEach(vehicles.indices, id: \.self) { index in
                                    Text("\(vehicles[index].make) \(vehicles[index].model)")
                                        .tag(index)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                    card("Service Type") {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                            ForEach(ServiceType.allCases) { type in
                                typeTile(type, selected: vm.selectedType == type)
                                    .onTapGesture {
                                        vm.selectedType = type
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    }
                            }
                        }
                    }

                    card("Details") {
                        VStack(spacing: 12) {
                            DatePicker("Date", selection: $vm.serviceDate, displayedComponents: .date)

                            TextField("Cost", text: $vm.costText)
                                .keyboardType(.decimalPad)
                                .padding(12)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            TextField("Mileage", text: $vm.mileageText)
                                .keyboardType(.numberPad)
                                .padding(12)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(vm.navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(vm.isSaving ? "Saving..." : "Save") {
                        if !vehicles.isEmpty {
                            let vehicle = vehicles[min(selectedVehicleIndex, vehicles.count - 1)]
                            vm.vehicleName = "\(vehicle.make) \(vehicle.model)"
                        }

                        Task {
                            let ok = await vm.save()
                            if ok { dismiss() }
                        }
                    }
                    .disabled(!vm.canSave)
                }
            }
            .alert("Error", isPresented: Binding(
                get: { vm.errorMessage != nil },
                set: { _ in vm.errorMessage = nil }
            )) {
                Button("OK", role: .cancel) { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }
            .onAppear {
                guard !vehicles.isEmpty else { return }
                if let matchIndex = vehicles.firstIndex(where: { "\($0.make) \($0.model)" == vm.vehicleName }) {
                    selectedVehicleIndex = matchIndex
                } else {
                    selectedVehicleIndex = 0
                    if vm.vehicleName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        vm.vehicleName = "\(vehicles[0].make) \(vehicles[0].model)"
                    }
                }
            }
        }
    }

    // MARK: UI

    private func card<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            content()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private func typeTile(_ type: ServiceType, selected: Bool) -> some View {
        VStack(spacing: 8) {
            Image(systemName: type.iconName)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 44, height: 44)
                .background(Color(.tertiarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            Text(type.title)
                .font(.caption.weight(.semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(selected ? Color.blue.opacity(0.12) : Color(.secondarySystemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(selected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
