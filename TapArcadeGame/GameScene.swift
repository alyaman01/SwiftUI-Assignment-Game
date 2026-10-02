//
//  GameScene.swift
//  TapArcadeGame
//
//  Created by macbook on 02/10/26.
//

import SpriteKit
import Combine

class GameScene: SKScene {
    // Game State Variables
    var score = 0
    var scoreHandler: ((Int) -> Void)? // SwiftUI UI update ke liye closure
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear // Transparent background so SwiftUI view styling works
        physicsWorld.gravity = .zero
        
        // Spawn first bubble
        spawnBubble()
    }
    
    func spawnBubble() {
        // Safe screen bounds me random position choose karna
        let safeMargin: CGFloat = 60
        let randomX = CGFloat.random(in: safeMargin...(frame.width - safeMargin))
        let randomY = CGFloat.random(in: safeMargin...(frame.height - safeMargin))
        
        // Circle Bubble Node create karna
        let bubble = SKShapeNode(circleOfRadius: 35)
        bubble.fillColor = UIColor.systemBlue
        bubble.strokeColor = UIColor.white
        bubble.lineWidth = 3
        bubble.position = CGPoint(x: randomX, y: randomY)
        bubble.name = "bubble"
        
        // Pop-in Animation (Juicy UI effect)
        bubble.setScale(0)
        let scaleAction = SKAction.scale(to: 1.0, duration: 0.2)
        bubble.run(scaleAction)
        
        addChild(bubble)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            if node.name == "bubble" {
                // Sound effect or Pop Animation
                let fadeOut = SKAction.fadeOut(withDuration: 0.1)
                let remove = SKAction.removeFromParent()
                node.run(SKAction.sequence([fadeOut, remove]))
                
                // Score Update
                score += 10
                scoreHandler?(score)
                
                // Next Bubble Spawn karo
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    self?.spawnBubble()
                }
            }
        }
    }
}
