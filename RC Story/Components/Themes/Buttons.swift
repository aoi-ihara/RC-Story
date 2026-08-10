import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let fullWidth: Bool

    init(fullWidth: Bool = false) {
        self.fullWidth = fullWidth
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .background(Colors.accent)
            .clipShape(Capsule())
            .foregroundStyle(Color.white)
            .offset(y: configuration.isPressed ? 0 : -4)
            .shadow(color: Colors.shadow, radius: 0, y: configuration.isPressed ? 0 : 4)
            .transaction { transaction in
                transaction.animation = .easeOut(duration: 0.04)
            }
            .font(Fonts.button)
            .sensoryFeedback(trigger: configuration.isPressed) { _, newValue in
                if newValue {
                    return .selection
                } else {
                    return nil
                }
            }
    }
}

struct TextButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Colors.accent)
            .font(Fonts.button)
            .sensoryFeedback(trigger: configuration.isPressed) { _, newValue in
                if newValue {
                    return .impact
                } else {
                    return nil
                }
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .transaction { transaction in
                transaction.animation = nil
            }
    }
}

struct BackButton: View {
    let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button(
            action: action,
            label: {
                Image(systemName: "chevron.left")
                    .frame(width: 24, height: 24)
            }
        )
        .buttonStyle(PrimaryButtonStyle())
    }
}

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
        VStack {
            Button(
                action: action,
                label: {
                    Text(title)
                        .font(Fonts.button)
                        .foregroundStyle(Color.white)
                }
            )
            .buttonStyle(PrimaryButtonStyle(fullWidth: true))
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    Spacer()
    Button("Title") { print("HELLO") }
        .buttonStyle(PrimaryButtonStyle(fullWidth: true))
    Spacer()

    BackButton(action: {})

    Spacer()

    BottomButton("タイトル", action: {})
}
