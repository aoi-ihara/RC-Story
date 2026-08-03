import SwiftUI

struct BottomButton: View {
    let title: String
    let action: () -> Void

    init(
        _ title: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action, label: {
            Text(title)
                .font(Fonts.button)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        })
        .foregroundStyle(.white)
        .buttonStyle(.glassProminent)
        .padding(.horizontal, 32)
    }
}

#Preview {
    IntroductionView()
}
