import SwiftUI

@main
struct LifeRouletteApp: App {
    @StateObject private var historyStore = ResultHistoryStore()
    @StateObject private var adService = GoogleAdService.shared

    var body: some Scene {
        WindowGroup {
            Group {
                if adService.didCompleteTrackingFlow {
                    ContentView(adService: adService)
                } else {
                    TrackingPermissionGateView {
                        Task {
                            await adService.requestTrackingAuthorizationFromGate()
                        }
                    }
                }
            }
            .environmentObject(historyStore)
            .task {
                adService.prepareForFirstLaunch()
            }
        }
    }
}
