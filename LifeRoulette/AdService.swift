import GoogleMobileAds
import SwiftUI
import UIKit

protocol AdService {
    associatedtype Banner: View
    func banner() -> Banner
}

final class GoogleAdService: AdService {
    static let shared = GoogleAdService()

    private var didStart = false

    private init() {}

    @MainActor
    func startIfNeeded() {
        guard !didStart else { return }
        didStart = true
        MobileAds.shared.start()
    }

    func banner() -> some View {
        BannerAdView()
    }
}

struct BannerAdView: View {
    var body: some View {
        BannerViewContainer(
            adSize: AdSizeBanner,
            adUnitID: AdMobConfig.bannerAdUnitID
        )
        .frame(width: AdSizeBanner.size.width, height: AdSizeBanner.size.height)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .accessibilityLabel("広告")
    }
}

private enum AdMobConfig {
    static let sampleBannerAdUnitID = "ca-app-pub-3940256099942544/2435281174"

    static var bannerAdUnitID: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "GADBannerAdUnitID") as? String,
              !value.isEmpty,
              !value.hasPrefix("$(") else {
            return sampleBannerAdUnitID
        }
        return value
    }
}

private struct BannerViewContainer: UIViewRepresentable {
    let adSize: AdSize
    let adUnitID: String

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: adSize)
        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared.adRootViewController
        banner.load(Request())
        return banner
    }

    func updateUIView(_ banner: BannerView, context: Context) {
        if banner.adUnitID != adUnitID {
            banner.adUnitID = adUnitID
            banner.load(Request())
        }
    }
}

private extension UIApplication {
    var adRootViewController: UIViewController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }?
            .rootViewController?
            .topPresentedViewController
    }
}

private extension UIViewController {
    var topPresentedViewController: UIViewController {
        presentedViewController?.topPresentedViewController ?? self
    }
}
