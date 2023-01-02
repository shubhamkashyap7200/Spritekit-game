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
        configureStartGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        configuringSpawnManager(currentTime: currentTime)
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
    
    private func configureStartGame() {
        startGame()
    }
    
    private func configuringSpawnManager(currentTime: TimeInterval) {
        // 1
        if gameState != .Playing { return }
        
        // 2
        print("DEBUG:: Spawn Time :: \(spawnTime)")
        if spawnTime == 0 { spawnTime = currentTime + 3 }
        
        // 3
        if spawnTime < currentTime {
            spawnEmoji()
            spawnTime = currentTime + 0.5
        }
        
        // 4
        updateHUD("Score: " + String(score) + " | LIVES: " + String(lives))
        
    }
    
    private func updateHUD(_ message: String) {
        guard let sceneView = self.view as? ARSKView else { return }
        
        let viewController = sceneView.delegate as! ViewController
        viewController.hudLabel.text = message
    }
    
    public func startGame() {
        gameState = .TapToStart
        updateHUD("TAP TO START GAME")
        
        removeAnchor()
    }
    
    public func playGame() {
        gameState = .Playing
        score = 0
        lives = 10
        spawnTime = 0
        
        addAnchor()
    }
    
    public func stopGame() {
        gameState = .GameOver
        updateHUD("GAME OVER ! YOU SCORE IS: " + String(score))
    }
    
    private func addAnchor() {
        guard let sceneView = self.view as? ARSKView else { return }
        
        if let currentFrame = sceneView.session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.5
            
            let transform = simd_mul(currentFrame.camera.transform, translation)
            anchor = ARAnchor(transform: transform)
            if let anchor = anchor {
                sceneView.session.add(anchor: anchor)
            }
        }
    }
    
    private func removeAnchor() {
        guard let sceneView = self.view as? ARSKView else { return }
        
        if anchor != nil {
            guard let anchor = anchor else { return }
            sceneView.session.remove(anchor: anchor)
        }
    }
    
    private func spawnEmoji() {
        // 1
        let emojiNode = SKLabelNode(text: String(emojis.randomElement()!))
        emojiNode.name = "Emoji"
        emojiNode.horizontalAlignmentMode = .center
        emojiNode.verticalAlignmentMode = .center
        
        // 2
        guard let sceneView = self.view as? ARSKView else { return }
        let spawnNode = sceneView.scene?.childNode(withName: "SpawnPoint")
        spawnNode?.addChild(emojiNode)
        
        // 3
        emojiNode.physicsBody = SKPhysicsBody(circleOfRadius: 15.0)
        emojiNode.physicsBody?.mass = 0.01 // 10 grams
        
        // 4
        emojiNode.physicsBody?.applyImpulse(CGVector(dx: -5 + 10 * randomCGFloat(), dy: 10))
        
        // 5
        emojiNode.physicsBody?.applyTorque(-0.2 + 0.4 * randomCGFloat())
        
        // 6
        let spawnSoundAction = SKAction.playSoundFileNamed("Spawn.wav", waitForCompletion: false)
        let dieSoundAction = SKAction.playSoundFileNamed("Die.wav", waitForCompletion: false)
        let waitAction = SKAction.wait(forDuration: 3)
        let removeAction = SKAction.removeFromParent()
        
        // 7
        let runAction = SKAction.run {
            self.lives -= 1
            if self.lives <= 0 {
                self.stopGame()
            }
        }
        
        // 8
        let sequenceAction = SKAction.sequence([spawnSoundAction, waitAction, dieSoundAction, runAction, removeAction])
        emojiNode.run(sequenceAction)
    }
    
    private func randomCGFloat() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
}
