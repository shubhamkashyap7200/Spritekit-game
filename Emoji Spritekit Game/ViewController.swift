//
//  ViewController.swift
//  Emoji Spritekit Game
//
//  Created by Shubham on 1/2/23.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet weak var hudLabel: UILabel!
    @IBOutlet var sceneView: ARSKView!
    
    // MARK: - Lifecycle functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - Helper functions
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - ARSKViewDelegate

extension ViewController: ARSKViewDelegate {
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        // 1
        let spawnNode = SKNode()
        
        // 2
        let boxNode = SKLabelNode(text: "🔥")
        boxNode.verticalAlignmentMode = .center
        boxNode.horizontalAlignmentMode = .center
        boxNode.zPosition = 100
        boxNode.setScale(1.5)
        spawnNode.addChild(boxNode)
        return spawnNode
    }
    
    func view(_ view: ARSKView, didAdd node: SKNode, for anchor: ARAnchor) {
        //
    }
    
    func view(_ view: ARSKView, willUpdate node: SKNode, for anchor: ARAnchor) {
        //
    }
    
    func view(_ view: ARSKView, didUpdate node: SKNode, for anchor: ARAnchor) {
        //
    }
    
    func view(_ view: ARSKView, didRemove node: SKNode, for anchor: ARAnchor) {
        //
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            showAlert("Tracking Limited", "AR Experience not available")
            break
        case .limited(let reason):
            switch reason {
            case .initializing:
                break
            case .excessiveMotion:
                showAlert("Tracking Limited", "Excessive motion")
                break
            case .insufficientFeatures:
                showAlert("Tracking Limited", "Insufficient features")
            case .relocalizing:
                break
            @unknown default:
                break
            }
            break
        case .normal:
            break
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        showAlert("Session Failure", error.localizedDescription)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        showAlert("AR Session", "Session was interrupted!")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        let scene = sceneView.scene as! Scene
        scene.startGame()
    }

}
