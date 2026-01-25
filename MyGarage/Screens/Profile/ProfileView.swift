//
//  ProfileView.swift
//  MyGarage
//
//  Created by David on 14.01.26.
//


import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @AppStorage("appTheme") private var appTheme: String = "light"

    private var colorScheme: ColorScheme {
        appTheme == "dark" ? .dark : .light
    }

    private var isLightModeOn: Bool {
        appTheme != "dark"
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    headerCard
                    themeRow
                    logoutRow
                }
                .padding(16)
            }
            .navigationTitle("Profile")
        }
        .preferredColorScheme(colorScheme)
        
        .onChange(of: appTheme) {
            NotificationCenter.default.post(name: .appThemeDidChange, object: nil)
        }

    }

    // MARK: Header

    private var headerCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 56, height: 56)
                Text(initials(from: displayName))
                    .font(.headline)
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(displayName)
                    .font(.headline)
                Text(emailText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    // MARK: - Theme Row (Light/Dark)

    private var themeRow: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemBackground))
                    .frame(width: 40, height: 40)

                Image(systemName: isLightModeOn ? "sun.max.fill" : "moon.stars.fill")
                    .foregroundStyle(.blue)
            }

            Text(isLightModeOn ? "Light Mode" : "Dark Mode")

            Spacer()

            Toggle("", isOn: Binding(
                get: { isLightModeOn },
                set: { appTheme = $0 ? "light" : "dark" }
            ))
            .labelsHidden()
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    // MARK: - Logout

    private var logoutRow: some View {
        Button {
            do { try Auth.auth().signOut() } catch { }
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.systemBackground))
                        .frame(width: 40, height: 40)
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(.red)
                }

                Text("Logout")
                    .foregroundStyle(.red)

                Spacer()
            }
            .padding(14)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
    }

    // MARK: - User data

    private var displayName: String {
        Auth.auth().currentUser?.displayName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        ? (Auth.auth().currentUser?.displayName ?? "User")
        : "User"
    }

    private var emailText: String {
        Auth.auth().currentUser?.email ?? "—"
    }

    private func initials(from name: String) -> String {
        let parts = name.split(separator: " ")
        let first = parts.first?.first.map(String.init) ?? "U"
        let second = parts.dropFirst().first?.first.map(String.init) ?? ""
        return (first + second).uppercased()
    }
}
extension Notification.Name {
    static let appThemeDidChange = Notification.Name("appThemeDidChange")
}
