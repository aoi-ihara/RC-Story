import SwiftUI

struct ContentView: View {
    @AppStorage("show_introduction_view") private var showIntroductionView: Bool = true
    
    var body: some View {
        NavigationStack {
            Text("Hello Wolrd!!")
                .foregroundStyle(Colors.textPrimary)
                .font(Fonts.hero)
            Button("Hide") {
                showIntroductionView = false
            }
            Button("Shwo") {
                showIntroductionView = true
            }
        }
        .sheet(isPresented: $showIntroductionView, content: {
            IntroductionView(showIntroductionView: $showIntroductionView)
        })
    }
}

#Preview {
    ContentView()
}
