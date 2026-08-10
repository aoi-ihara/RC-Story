import SwiftUI

// MARK: - Models

struct Position: Hashable, Equatable {
    let row: Int
    let col: Int
}

struct CellData: Identifiable {
    let id = UUID()
    var character: Character
    var rotation: Double
    var scaleX: CGFloat
}

enum GameState {
    case playing
    case correct
    case incorrect
}

// MARK: - Game Engine

@Observable
class GameEngine {
    var grid: [[CellData]] = []
    var targetWord: String = "CAT"
    var currentSelection: [Position] = []
    var confirmedSelection: [Position] = []
    var state: GameState = .playing

    // サンプルの単語リスト
    private let wordPool = ["CAT", "SWIFT", "APPLE", "CODE", "MAC", "XCODE", "IOS"]

    init() {
        generateGame()
    }

    func generateGame() {
        targetWord = wordPool.randomElement() ?? "CAT"

        grid = Array(
            repeating: Array(repeating: CellData(character: " ", rotation: 0, scaleX: 1), count: 8),
            count: 8)

        let chars = Array(targetWord)
        var placed = false

        let directions = [
            (1, 0),
            (1, 1),
            (0, 1),
            (-1, 1),
            (-1, 0),
            (-1, -1),
            (0, -1),
            (1, -1),
        ]

        // ターゲット単語が収まるまでランダム配置を試行
        while !placed {
            let startRow = Int.random(in: 0..<8)
            let startCol = Int.random(in: 0..<8)
            let dir = directions.randomElement()!

            let endRow = startRow + dir.1 * (chars.count - 1)
            let endCol = startCol + dir.0 * (chars.count - 1)

            if endRow >= 0 && endRow < 8 && endCol >= 0 && endCol < 8 {
                for i in 0..<chars.count {
                    let r = startRow + dir.1 * i
                    let c = startCol + dir.0 * i
                    grid[r][c].character = chars[i]
                }
                placed = true
            }
        }

        // 残りのマスをランダムなアルファベットで埋め、変形をランダム適用
        let alphabets = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let rotations: [Double] = [0, 90, 180, 270]

        for r in 0..<8 {
            for c in 0..<8 {
                if grid[r][c].character == " " {
                    grid[r][c].character = alphabets.randomElement()!
                }
                grid[r][c].rotation = rotations.randomElement()!
                grid[r][c].scaleX = Bool.random() ? -1.0 : 1.0
            }
        }
    }

    func processDragChange(startLoc: CGPoint, currentLoc: CGPoint, gridSize: CGFloat) {
        guard state == .playing else { return }

        let cellSize = gridSize / 8

        let startCol = Int(max(0, min(gridSize - 0.1, startLoc.x)) / cellSize)
        let startRow = Int(max(0, min(gridSize - 0.1, startLoc.y)) / cellSize)
        let currentCol = Int(max(0, min(gridSize - 0.1, currentLoc.x)) / cellSize)
        let currentRow = Int(max(0, min(gridSize - 0.1, currentLoc.y)) / cellSize)

        let dCol = currentCol - startCol
        let dRow = currentRow - startRow

        // 同一セルの場合
        if dCol == 0 && dRow == 0 {
            currentSelection = [Position(row: startRow, col: startCol)]
            return
        }

        // 角度を計算し、8方向のいずれかにスナップさせる
        let angle = atan2(Double(dRow), Double(dCol))
        let octant = Int(round(8 * angle / (2 * .pi)) + 8) % 8

        let dirs = [
            (1, 0), (1, 1), (0, 1), (-1, 1),
            (-1, 0), (-1, -1), (0, -1), (1, -1),
        ]
        let dir = dirs[octant]

        // 主軸に沿った移動量から、選択すべきマス数を決定
        let steps = max(abs(dCol), abs(dRow))

        var newSelection = [Position]()
        for i in 0...steps {
            let r = startRow + i * dir.1
            let c = startCol + i * dir.0

            // 盤外に出ないようチェック
            if r >= 0 && r < 8 && c >= 0 && c < 8 {
                newSelection.append(Position(row: r, col: c))
            }
        }
        currentSelection = newSelection
    }

    func processDragEnd() {
        guard state == .playing, !currentSelection.isEmpty else { return }

        let selectedWord = currentSelection.map { String(grid[$0.row][$0.col].character) }.joined()

        if selectedWord == targetWord {
            state = .correct
            confirmedSelection = currentSelection
            currentSelection = []

            // 正解時は2秒後に次のゲームを生成
            Task {
                try? await Task.sleep(for: .seconds(2))
                await MainActor.run {
                    self.resetGame()
                }
            }
        } else {
            state = .incorrect
            confirmedSelection = currentSelection
            currentSelection = []

            // 不正解時は1秒後に通常状態へ戻す
            Task {
                try? await Task.sleep(for: .seconds(1))
                await MainActor.run {
                    if self.state == .incorrect {
                        self.state = .playing
                        self.confirmedSelection = []
                    }
                }
            }
        }
    }

    private func resetGame() {
        state = .playing
        currentSelection = []
        confirmedSelection = []
        generateGame()
    }
}

// MARK: - Game View

struct GameView: View {
    @Environment(NavigationState.self) private var navigation
    @State private var engine = GameEngine()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    BackButton(action: {
                        navigation.viewState = .home
                    })

                    Spacer()
                }
                .padding(32)

                Spacer()

                HStack {
                    Text("Find")
                        .font(Fonts.heading)
                    Text(engine.targetWord)
                        .font(Fonts.hero)
                }

                GeometryReader { geo in
                    let gridSize = geo.size.width
                    let cellSize = gridSize / 8

                    VStack(spacing: 0) {
                        ForEach(0..<8, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<8, id: \.self) { col in
                                    let pos = Position(row: row, col: col)
                                    let cell = engine.grid[row][col]

                                    ZStack {
                                        // Highlight Background
                                        Rectangle()
                                            .fill(backgroundColor(for: pos))
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .padding(2)

                                        Text(String(cell.character))
                                            .font(
                                                .system(
                                                    size: cellSize * 0.45, weight: .bold,
                                                    design: .rounded)
                                            )
                                            .foregroundStyle(textColor(for: pos))
                                            .scaleEffect(x: cell.scaleX, y: 1)
                                            .rotationEffect(.degrees(cell.rotation))
                                    }
                                    .frame(width: cellSize, height: cellSize)
                                }
                            }
                        }
                    }
                    .frame(width: gridSize, height: gridSize)
                    .padding(2)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(uiColor: .tertiarySystemFill))
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                engine.processDragChange(
                                    startLoc: value.startLocation, currentLoc: value.location,
                                    gridSize: gridSize)
                            }
                            .onEnded { _ in
                                engine.processDragEnd()
                            }
                    )
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal, 16)

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding(.vertical, 16)
        }
    }

    // MARK: - UI Helpers

    private func backgroundColor(for position: Position) -> Color {
        if engine.currentSelection.contains(position) {
            // 仮選択状態
            return Color.accentColor.opacity(0.3)
        } else if engine.confirmedSelection.contains(position) {
            // 確定状態
            if engine.state == .correct {
                return Color.green
            } else if engine.state == .incorrect {
                return Color.red
            }
        }
        return Color.clear
    }

    private func textColor(for position: Position) -> Color {
        if engine.confirmedSelection.contains(position)
            && (engine.state == .correct || engine.state == .incorrect)
        {
            return .white
        }
        return .primary
    }
}

#Preview {
    ContentView()
}
