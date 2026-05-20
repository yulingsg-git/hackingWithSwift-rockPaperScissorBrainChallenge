//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Chen Yuling on 2026/05/18.
//

import SwiftUI

struct Prominent: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
            .multilineTextAlignment(.center)
    }
}

struct Normal: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
    }
}

extension View {
    func prominentStyle() -> some View {
        modifier(Prominent())
    }
    func normalStyle() -> some View {
        modifier(Normal())
    }
}

enum GameMove: CaseIterable {
    case rock, paper, scissors
    var description: String {
        switch self {
        case .rock: return "Rock"
        case .paper: return "Paper"
        case .scissors: return "Scissors"
        }
    }
}

struct GameMoveImage: View {
    var gameMove: GameMove
    var imageEmoji : String {
        switch gameMove {
        case .rock: return "🪨"
        case .paper: return "📃"
        case .scissors: return "✂️"
        }
    }
    var body: some View {
        Text(imageEmoji)
            .font(.system(size: 100))
    }
}

struct ContentView: View {
    @State private var appGameMove: GameMove = (GameMove.allCases.randomElement() ?? .rock)
    @State private var shouldWin = Bool.random()
    @State private var previousGameResult: String?
    @State private var playerScore = 0
    @State private var numberOfGames = 1
    @State private var showFinalScore = false
    @State private var finalScore = ""
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.5, green: 0.2, blue: 0.45), location: 0.1),
                .init(color: Color(red: 0.15, green: 0.1, blue: 0.1), location: 0.5),
            ], center: .center, startRadius: 100, endRadius: 600)
            .ignoresSafeArea()
            VStack {
                Text("Rock Paper Scissors Challenge").prominentStyle()
                if let previousGameResult = previousGameResult {
                    Text(previousGameResult).normalStyle()
                }
                Text("Your score: \(playerScore)").foregroundStyle(Color.green)
                Text("The app's move: \(appGameMove.description)")
                    .normalStyle()
                Text("You should \(shouldWin ? "win" : "lose")")
                    .normalStyle()
                HStack{
                    ForEach(GameMove.allCases, id: \.self) { move in
                        Button(action: {
                            checkScore(move)
                        }) {
                            VStack {
                                GameMoveImage(gameMove: move)
                                Text(move.description).normalStyle()
                            }
                        }
                    }
                }.padding()
                
                
            }
            .padding()
        }.alert(finalScore, isPresented: $showFinalScore) {
            Button("Play again?") {
                playerScore = 0
                numberOfGames = 0
                previousGameResult = nil
                finalScore = ""
                proceedToNextRound()
            }
        }
    }
    
    func proceedToNextRound() {
        numberOfGames += 1
        appGameMove =  (GameMove.allCases.randomElement() ?? .rock)
        shouldWin.toggle()
    }
    
    func checkScore(_ move: GameMove) {
        var didWin = false
        switch (move, appGameMove) {
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
            if shouldWin {
                playerScore += 1
                didWin = true
            }
        case (.rock, .rock), (.paper, .paper), (.scissors, .scissors):
            break
        case (.scissors, .rock), (.rock, .paper), (.paper, .scissors):
            if !shouldWin {
                playerScore += 1
                didWin = true
            }
        }
        previousGameResult = "The player tapped \(move.description), the player was trying to \(shouldWin ? "win" : "lose"), and the app chose \(appGameMove.description), so \(didWin ? "add 1 point" : "add no points")."
        if numberOfGames == 10 {
            showFinalScore = true
            finalScore = "Your final score is \(playerScore)"
        } else {
proceedToNextRound()
        }
    }
}

#Preview {
    ContentView()
}
