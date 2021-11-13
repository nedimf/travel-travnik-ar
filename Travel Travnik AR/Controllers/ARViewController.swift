//
//	ARViewController
//  Travel Travnik AR
//	Created by: @nedimf on 06/11/2021


import Foundation
import UIKit
import SwiftUI
import ARKit

class ARViewController: UIViewController, ARSKViewDelegate {
    
    var landmark: LandmarkElement? = nil
    var landmarkCustomSkNodes = [CustomSKNode]()
    let sceneView: ARSKView = {
       
        let scene = ARSKView()
        scene.translatesAutoresizingMaskIntoConstraints = false
        
        return scene
    }()

    var arScene:DefaultARScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupAR()
    }
    
    func setupLayout(){
        
        self.view.addSubview(sceneView)
        
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: self.view.topAnchor), sceneView.leftAnchor.constraint(equalTo: self.view.leftAnchor), sceneView.rightAnchor.constraint(equalTo: self.view.rightAnchor), sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    func setupAR(){

        sceneView.delegate = self
        arScene = DefaultARScene(size: view.bounds.size)
        arScene.scaleMode = .resizeFill
        arScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sceneView.presentScene(arScene)
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("ARController panicking with memory warning")
    }
    
    //-MARK: Delegate on ARSceneViewDelegate
    func view(_ view: ARSKView,
               nodeFor anchor: ARAnchor) -> SKNode? {
        
        //Logic to show data from LandmarkElement as AR View
        let defaultSize = CGSize(width: 300, height: 500)
        if let landmark = landmark {
            //Header AR card/view
            let header = generateCustomSKNodeView(swiftUI: LandmarkView(landmark: landmark), landmark: landmark, targetSize: defaultSize)
            if let header = header {landmarkCustomSkNodes.append(header)}

            //Body AR cards/views
            var i = 0
            for _ in landmark.moreInformation {
                let info = generateCustomSKNodeView(swiftUI: LandmarkMoreInfoView(landmark: landmark, landmarkPosition: i, moreInformationType: .basic), landmark: landmark, targetSize: defaultSize)
                
                if let info = info {
                    landmarkCustomSkNodes.append(info)
                }
                i += 1
            }
            
            // Image gallery AR card/views
            let doubleGallery = generateCustomSKNodeView(swiftUI: LandmarkMoreInfoView(landmark: landmark, landmarkPosition: 0, moreInformationType: .photoDouble), landmark: landmark, targetSize: defaultSize)
            if let doubleGallery = doubleGallery {landmarkCustomSkNodes.append(doubleGallery)}
            
            let photoGrid = generateCustomSKNodeView(swiftUI: LandmarkMoreInfoView(landmark: landmark, landmarkPosition: 0, moreInformationType: .photoGrid), landmark: landmark, targetSize: defaultSize)
            if let photoGrid = photoGrid {
                landmarkCustomSkNodes.append(photoGrid)
            }
            
            arScene.defaultSKNodes = landmarkCustomSkNodes
            
            if let header = header {
                let card = SKSpriteNode(texture: SKTexture(image: header.scaledImageToShow))
                card.name = header.nodeName
                return card
            }
        }
        
        return nil
    }
   
    func generateCustomSKNodeView<T: View>(swiftUI: T, landmark: LandmarkElement,  targetSize: CGSize?=nil) -> CustomSKNode?{
        let swiftUIView = UIHostingController(rootView: swiftUI)
        if let targetSize = targetSize {
            let generatedOriginalImage = swiftUIView.rootView.snapshot(targetSize: targetSize)
            if let generatedOriginalCGImage = generatedOriginalImage.cgImage{
                let scaledImageToFitARView = UIImage(cgImage: generatedOriginalCGImage, scale: 6, orientation: .up)
                
                let nodeName = "\(landmark.title)-\(UUID().uuidString)"
                return CustomSKNode(nodeName: nodeName, scaledImageToShow: scaledImageToFitARView, landmark: landmark)
            }
        }
        return nil
    }
    
    func session(_ session: ARSession,
                  didFailWithError error: Error) {
     print("Session Failed - probably due to lack of camera access")
   }
     
   func sessionWasInterrupted(_ session: ARSession) {
     print("Session interrupted")
   }
     
   func sessionInterruptionEnded(_ session: ARSession) {
     print("Session resumed")
     sceneView.session.run(session.configuration!,
                           options: [.resetTracking,
                                     .removeExistingAnchors])
   }
}
