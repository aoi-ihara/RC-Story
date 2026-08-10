import Observation
import SwiftUI

enum NavigationPages: CaseIterable, Identifiable {
    case home
    case game

    var id: Self { self }
}

@Observable
class NavigationState {
    var viewState: NavigationPages = .home
}

struct ContentView: View {
    @State private var navigation = NavigationState()
    @AppStorage("showIntroductionView") private var showIntroductionView = false

    var body: some View {
        GeometryReader { proxy in
            let screenWidth = proxy.size.width

            ZStack {
                ForEach(NavigationPages.allCases) { page in
                    viewFactory(for: page)
                        .frame(width: screenWidth)
                        .offset(
                            x: Offset(for: page, width: screenWidth)
                                - Offset(for: navigation.viewState, width: screenWidth))
                }
            }
            .animation(.easeOut, value: navigation.viewState)
        }
        .sheet(isPresented: $showIntroductionView) {
            IntroductionView(showIntroductionView: $showIntroductionView)
        }
        .environment(navigation)
    }

    private func Offset(for page: NavigationPages, width: CGFloat) -> CGFloat {
        let pageNumber: CGFloat

        switch page {
        case (.home):
            pageNumber = 0
        case (.game):
            pageNumber = 1
        }

        return pageNumber * width
    }

    @ViewBuilder
    private func viewFactory(for page: NavigationPages) -> some View {
        switch page {
        case .home:
            HomeView()
        case .game:
            GameView()
        }
    }
}

#Preview {
    ContentView()
}
