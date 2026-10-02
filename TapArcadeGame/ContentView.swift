//
//  ContentView.swift
//  TapArcadeGame
//
//  Created by macbook on 02/10/26.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var isGameActive = false
    @State private var isGameOver = false
    
    @State private var timer: Timer? = nil
    
    var scene: GameScene {
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .resizeFill
        scene.scoreHandler = { newScore in
            self.score = newScore
        }
        return scene
    }
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            if isGameActive {
                // Game Viewport
                SpriteView(scene: scene, options: [.allowsTransparency])
                    .ignoresSafeArea()
                
                // Top HUD Overlay
                VStack {
                    HStack {
                        Text("Score: \(score)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Time: \(timeRemaining)s")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(timeRemaining <= 5 ? .red : .white)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.top, 50)
                    
                    Spacer()
                }
            } else {
                // Start / Game Over Screen
                VStack(spacing: 25) {
                    Text(isGameOver ? "Game Over!" : "Speed Tapper")
                        .font(.system(size: 38, weight: .heavy))
                        .foregroundColor(.white)
                    
                    if isGameOver {
                        Text("Final Score: \(score)")
                            .font(.title)
                            .foregroundColor(.yellow)
                    }
                    
                    Button(action: startGame) {
                        Text(isGameOver ? "Play Again" : "Start Game")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 5)
                    }
                }
            }
        }
    }
    
    func startGame() {
        score = 0
        timeRemaining = 30
        isGameOver = false
        isGameActive = true
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                endGame()
            }
        }
    }
    
    func endGame() {
        timer?.invalidate()
        isGameActive = false
        isGameOver = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
