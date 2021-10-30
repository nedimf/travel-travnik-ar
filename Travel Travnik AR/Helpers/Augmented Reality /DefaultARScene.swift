//
//	DefaultARScene
//  Travel Travnik AR
//	Created by: @nedimf on 29/10/2021

// DefaultARScene acts as SKScene object with custom methods to set default AR scene
// This class handles setup of AR world with given parameters

import Foundation
import SpriteKit
import ARKit
import UIKit
import SwiftUI

class DefaultARScene: SKScene{
    
    var isARWorldSetup = false
    var defaultSKNodes = [SKSceneDefaultNode]()
    private var clickNodeCounter = 0

    
    var sceneView: ARSKView{
        return view as! ARSKView //forced cast to ARSKView here is used to declare sceneView as ARSKView type
    }
    
    // Setting initial Camera frame to anchor provided view correctly in 3D space
    private func setupARWorld(){
        guard let currentFrame = sceneView.session.currentFrame else {return}
        let translation = matrix_identity_float4x4 // revisit documentation for matrix in 3D, translation is 4th type
        let transform  = currentFrame.camera.transform * translation
        
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)
        
        self.isARWorldSetup = true
    }
    
    // Check if setup of AR world is finished
    // Do necessary calibration with light and ambient intensity for each custom node
    override func update(_ currentTime: TimeInterval) {
        if !self.isARWorldSetup{
            setupARWorld()
            
            guard let currentFrame = sceneView.session.currentFrame,
              let lightEstimate = currentFrame.lightEstimate else {
                return
            }
                
            let neutralIntensity: CGFloat = 1000
            let ambientIntensity = min(lightEstimate.ambientIntensity,
                                       neutralIntensity)
            let blendFactor = 1 - ambientIntensity / neutralIntensity

            for node in children{
                if let defaultSKNode = node as? SKSpriteNode {
                    defaultSKNode.color = .black
                    defaultSKNode.colorBlendFactor = blendFactor
                }
            }
        }
    }
    
    // Handle first touch on SKNode object
    // Change showing information accordingly
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let location = touch.location(in: self)
            let tappedNodes = nodes(at: location)
            
            debugThis {
                print(defaultSKNodes)
            }
            
            clickNodeCounter += 1
            
            for node in tappedNodes {
                if let tappedCustomNode = node as? SKSpriteNode {
                    debugThis {
                        print("click node counter \(clickNodeCounter) customSkNodes count \(defaultSKNodes)")
                    }

                    if ( clickNodeCounter <= self.defaultSKNodes.count-1){
                        
                        if tappedCustomNode.name == self.defaultSKNodes[clickNodeCounter-1].nodeName {
                            // Set tapped custom node texture
                            tappedCustomNode.texture = SKTexture(image: self.defaultSKNodes[clickNodeCounter].scaledImageForShowing)
                            tappedCustomNode.name = self.defaultSKNodes[clickNodeCounter].nodeName
                        }
                    }
                }
            }
        }
    }
}
