import SwiftUI

struct HomeView: View {
    @State private var showSettingsView: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Text("RC Story")
                    .font(Fonts.hero)

                Button(
                    action: {},
                    label: {
                        Label("Start Game", systemImage: "gamecontroller")
                    }
                )
                .buttonStyle(PrimaryButtonStyle(fullWidth: true))

                Button(
                    action: { showSettingsView.toggle() },
                    label: {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                )
                .buttonStyle(TextButtonStyle())
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 32)
            .sheet(isPresented: $showSettingsView) {
                SettingsView(showSettingsView: $showSettingsView)
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    ContentView()
}
