//
//  Scene.swift
//  BLSTRR
//
//  Created by Jesse Ruiz on 10/30/20.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
    // MARK: - Properties
    let remainingLabel = SKLabelNode()
    var timer: Timer?
    
    var targetsCreated = 0
    var targetCount = 0 {
        didSet {
            remainingLabel.text = "Remaining: \(targetCount)"
        }
    }
    
    override func didMove(to view: SKView) {
        remainingLabel.fontSize = 36
        remainingLabel.fontName = "AmericanTypewriter"
        remainingLabel.color = .white
        remainingLabel.position = CGPoint(x: 0, y: view.frame.midY - 50)
        addChild(remainingLabel)
        targetCount = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            self.createTarget()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    /// Manages how many targets have been created and ends the game if we've created 20
    func createTarget() {
        if targetsCreated == 20 {
            timer?.invalidate()
            timer = nil
            return
        }
        targetsCreated += 1
        targetCount += 1
        
        // Find the scene view we are drawing into
        guard let sceneView = self.view as? ARSKView else { return }
        
        // Create a random X rotation
        let xRotation = simd_float4x4(SCNMatrix4MakeRotation(Float.pi * 2 * Float.random(in: 0 ... 1), 1, 0, 0))
        
        // Create a random Y rotation
        let yRotation = simd_float4x4(SCNMatrix4MakeRotation(Float.pi * 2 * Float.random(in: 0 ... 1), 0, 1, 0))
        
        // Combine them together
        let rotation = simd_mul(xRotation, yRotation)
        
        // Move forward 1.5 meters into the screen
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.5
        
        // Combine that with our rotation
        let transform = simd_mul(rotation, translation)
        
        // Create an anchor at the finished position
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)
    }
}
