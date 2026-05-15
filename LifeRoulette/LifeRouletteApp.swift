import AppTrackingTransparency
import SwiftUI

@main
struct LifeRouletteApp: App {
    @StateObject private var historyStore = ResultHistoryStore()
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("didRequestTrackingPermission") private var didRequestTrackingPermission = false

    private let adService = GoogleAdService.shared

    var body: some Scene {
        WindowGroup {
            ContentView(adService: adService)
                .environmentObject(historyStore)
                .onAppear {
                    requestTrackingPermissionIfNeeded()
                }
                .onChange(of: scenePhase) { _, phase in
                    if phase == .active {
                        requestTrackingPermissionIfNeeded()
                    }
                }
        }
    }

    private func requestTrackingPermissionIfNeeded() {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else {
            Task { @MainActor in
                adService.startIfNeeded()
            }
            return
        }

        guard !didRequestTrackingPermission else { return }
        didRequestTrackingPermission = true

        ATTrackingManager.requestTrackingAuthorization { _ in
            Task { @MainActor in
                adService.startIfNeeded()
            }
        }
    }
}
