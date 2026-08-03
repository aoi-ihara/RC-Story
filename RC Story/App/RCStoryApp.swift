import SwiftUI
import Playgrounds

@main struct RCStoryApp: App {
    var body: some Scene {
        WindowGroup {
            IntroductionView()
                .accentColor(Colors.accent)
        }
    }
}

#Preview {
    IntroductionView()
}
