import SwiftUI

struct TrackingPermissionGateView: View {
    let onContinue: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.93, blue: 0.84),
                    Color(red: 0.84, green: 0.92, blue: 0.89),
                    Color(red: 0.94, green: 0.86, blue: 0.89)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer(minLength: 20)

                VStack(spacing: 12) {
                    Text("その数字のお話")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(Color(red: 0.12, green: 0.14, blue: 0.18))
                        .multilineTextAlignment(.center)

                    Text("広告の表示と効果測定について確認します")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color(red: 0.32, green: 0.35, blue: 0.39))
                        .multilineTextAlignment(.center)
                }

                VStack(alignment: .leading, spacing: 14) {
                    PermissionPoint(icon: "sparkles", text: "許可しなくても、アプリの機能はそのまま使えます。")
                    PermissionPoint(icon: "rectangle.3.group", text: "確認後に広告SDKを開始し、画面下の広告枠を読み込みます。")
                    PermissionPoint(icon: "hand.raised.fill", text: "次の画面でiOS標準の確認ダイアログが表示されます。")
                }
                .padding(18)
                .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .frame(maxWidth: 520)

                Button(action: onContinue) {
                    Label("続ける", systemImage: "arrow.right.circle.fill")
                        .font(.headline.weight(.black))
                        .foregroundStyle(.white)
                        .frame(maxWidth: 520)
                        .frame(height: 56)
                        .background(Color(red: 0.12, green: 0.14, blue: 0.18), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                .buttonStyle(.plain)

                Spacer(minLength: 20)
            }
            .padding(24)
        }
    }
}

private struct PermissionPoint: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.headline.weight(.bold))
                .foregroundStyle(Color(red: 0.85, green: 0.54, blue: 0.16))
                .frame(width: 26)

            Text(text)
                .font(.body.weight(.semibold))
                .foregroundStyle(Color(red: 0.22, green: 0.25, blue: 0.30))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    TrackingPermissionGateView {}
}
