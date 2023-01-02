//
//  Scene.swift
//  Emoji Spritekit Game
//
//  Created by Shubham on 1/2/23.
//

import SpriteKit
import ARKit

public enum GameState {
    case Init
    case TapToStart
    case Playing
    case GameOver
}

class Scene: SKScene {
    // MARK: - Properties
    private var gameState = GameState.Init
    fileprivate var anchor: ARAnchor?
    fileprivate var emojis = "💝😍💚💟💘💗💙🧡❣️💓"
    fileprivate var spawnTime: TimeInterval = 0
    fileprivate var score: Int = 0
    fileprivate var lives: Int = 10

    
    // MARK: - Lifecycle functions

    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    // MARK: - Helper functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        switch gameState {
        case .Init:
            break
        case .TapToStart:
            playGame()
            break
        case .Playing:
            // checkTouches(touches)
            break
        case .GameOver:
            startGame()
            break
        }
    }
    
    private func updateHUD(_ message: String) {
        guard let sceneView = self.view as? ARSKView else { return }
        
        let viewController = sceneView.delegate as! ViewController
        viewController.hudLabel.text = message
    }
    
    public func startGame() {
        gameState = .TapToStart
        updateHUD("TAP TO START GAME")
    }
    
    public func playGame() {
        gameState = .Playing
        score = 0
        lives = 10
        spawnTime = 0
    }
    
    public func stopGame() {
        gameState = .GameOver
        updateHUD("GAME OVER ! YOU SCORE IS: " + String(score))
    }
}

