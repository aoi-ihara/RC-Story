import SwiftUI

struct ContentView: View {
    @AppStorage("showIntroductionView") private var showIntroductionView: Bool = false

    var body: some View {
        HomeView()
            .sheet(
                isPresented: $showIntroductionView,
                content: {
                    IntroductionView(showIntroductionView: $showIntroductionView)
                })
    }
}

#Preview {
    ContentView()
}
