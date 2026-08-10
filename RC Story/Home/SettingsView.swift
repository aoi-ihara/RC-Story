import SwiftUI

struct SettingsView: View {
    @AppStorage("isBackgroundMusicOn") var isBackgroundMusicOn: Bool = true
    @Binding var showSettingsView: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $isBackgroundMusicOn, label: {
                        Label("Background Music", systemImage: "music.note")
                    })
                } header: {
                    Text("Music")
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        showSettingsView.toggle()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
