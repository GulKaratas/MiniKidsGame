//
//  ShapesScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 30.10.2024.
//

import UIKit
import SpriteKit

class ShapesScene: SKScene {

    var backButton: UIButton!

    override func didMove(to view: SKView) {
        // Create back button
        createBackButton()
        
        // Add shapes to the scene
        addShapes()
    }

    func createBackButton() {
        guard let view = self.view else { return }
        
        let background = SKSpriteNode(imageNamed: "bulutluBackground")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
        
        // Add a transparent overlay to dim the background
        let overlay = SKSpriteNode(color: UIColor.white.withAlphaComponent(0.9), size: self.size)
        overlay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        overlay.zPosition = 0
        addChild(overlay)
        
        // Initialize back button
        backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
        backButton.layer.cornerRadius = 25
        backButton.clipsToBounds = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
    }

    @objc func backButtonTapped() {
        let nextScene = NextScene(size: self.size)
        nextScene.scaleMode = .aspectFill
        self.view?.presentScene(nextScene, transition: SKTransition.fade(withDuration: 1.0))
        backButton.removeFromSuperview()
    }
    
    func addShapes() {
        // Load shape images and place them in positions along the top and bottom edges
        let shapes = ["kare", "daire", "yildiz", "ucgen"]

        // Define Y positions for the top and bottom rows
        let topY = self.size.height * 0.75    // Top row position (3/4 from the bottom)
        let bottomY = self.size.height * 0.25 // Bottom row position (1/4 from the bottom)
        
        // X offsets for left and right positions
        let leftX = self.size.width * 0.25   // Left position (1/4 from the left)
        let rightX = self.size.width * 0.75  // Right position (3/4 from the left)
        
        // Create and position each shape
        let topLeftShape = SKSpriteNode(imageNamed: shapes[0])
        topLeftShape.position = CGPoint(x: leftX, y: topY)
        topLeftShape.zPosition = 1
        addChild(topLeftShape)
        
        let topRightShape = SKSpriteNode(imageNamed: shapes[1])
        topRightShape.position = CGPoint(x: rightX, y: topY)
        topRightShape.zPosition = 1
        addChild(topRightShape)
        
        let bottomLeftShape = SKSpriteNode(imageNamed: shapes[2])
        bottomLeftShape.position = CGPoint(x: leftX, y: bottomY)
        bottomLeftShape.zPosition = 1
        addChild(bottomLeftShape)
        
        let bottomRightShape = SKSpriteNode(imageNamed: shapes[3])
        bottomRightShape.position = CGPoint(x: rightX, y: bottomY)
        bottomRightShape.zPosition = 1
        addChild(bottomRightShape)
    }


    override func willMove(from view: SKView) {
        backButton.removeFromSuperview()
    }
}
