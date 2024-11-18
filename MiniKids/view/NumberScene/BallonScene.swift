//
//  BallonScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 18.11.2024.
//

import UIKit
import SpriteKit

class BallonScene: SKScene {
    override func didMove(to view: SKView) {
          // Set up your BalloonScene here
          let label = SKLabelNode(text: "Welcome to Balloon Scene!")
          label.fontSize = 40
          label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
          self.addChild(label)
      }
}
