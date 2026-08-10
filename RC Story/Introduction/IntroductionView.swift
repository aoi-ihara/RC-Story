import SwiftUI

struct IntroductionPage {
    let heading: String
    let body: String
}

struct IntroductionView: View {
    @State private var pageIndex = 0
    @Binding var showIntroductionView: Bool

    private let contents = [
        IntroductionPage(
            heading: "ゲームを楽しむことが第一です",
            body: "このアプリは、遊びながら本の世界を冒険するゲームです。お子さまには『テスト』や『診断』ではなく、楽しい冒険として体験してもらうことを大切にしています。"
        ),
        IntroductionPage(
            heading: "一人ひとりに合う学び方を見つけます",
            body: "プレイ中の反応時間や操作の傾向などをもとに、お子さまに合いそうな表示方法や学習の工夫を提案します。医療的な診断を行うものではありません。"
        ),
        IntroductionPage(
            heading: "強みも大切にします",
            body: "結果では苦手なことだけでなく、得意なことや力を発揮しやすい方法もお伝えします。一人ひとりに合った学び方を、一緒に見つけていきましょう。"
        ),
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                Text("Welcome to ****")
                    .font(Fonts.hero)
                    .foregroundStyle(Colors.accent)

                TabView(selection: $pageIndex) {
                    ForEach(contents.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 32) {
                            Text(contents[index].heading)
                                .font(Fonts.heading)
                                .foregroundStyle(Colors.accent)
                                .tag(index)
                            Text(contents[index].body)
                                .foregroundStyle(Colors.textSecondary)
                                .tag(index)
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 256)
                .tabViewStyle(.page(indexDisplayMode: .never))

                Spacer()

                BottomButton(pageIndex == 2 ? "Done" : "Continue") {
                    if pageIndex < 2 {
                        withAnimation {
                            pageIndex += 1
                        }
                    } else {
                        showIntroductionView = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
