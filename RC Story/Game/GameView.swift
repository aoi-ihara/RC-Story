import SwiftUI

struct GameView: View {
    @Environment(NavigationState.self) private var navigation
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Find")
                        .font(Fonts.heading)
                    Text("Cat")
                        .font(Fonts.hero)
                }
                
                Button("Hello") {}
                    .buttonStyle(PrimaryButtonStyle())
                Button("Return to Home") {
                    navigation.viewState = .home
                }
                .buttonStyle(TextButtonStyle())
                .onAppear {
                    print("Hello World")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
