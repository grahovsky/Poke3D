//
//  ViewController.swift
//  Poke3D
//
//  Created by Konstantin on 18/04/2019.
//  Copyright © 2019 Konstantin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //let configuration = ARWorldTrackingConfiguration()
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            
            print("Images Successfully Added")
            
        }


        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return node }
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
        
        let planeNode = SCNNode(geometry: plane)
        
        node.addChildNode(planeNode)
        
        planeNode.eulerAngles.x = -.pi / 2
        
        //terminal -> xcrun usdz_converter /Users/konstantin/Downloads/Eevee/eevee.obj /Users/konstantin/Downloads/eevee.usdz
        
        if let imageName = imageAnchor.referenceImage.name {
            
            let scnName = imageName.replacingOccurrences(of: "-card", with: "")
            
            if let pokeScene = SCNScene(named: "art.scnassets/\(scnName).scn") {
                if let pokeNode = pokeScene.rootNode.childNodes.first {
                    pokeNode.eulerAngles.x = .pi / 2
                    planeNode.addChildNode(pokeNode)
                }
            }
        }
        
        return node
        
    }
}
