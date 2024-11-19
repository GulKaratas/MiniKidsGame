//
//  BallonScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 18.11.2024.
//

import UIKit
import SpriteKit
import AVFoundation
import Lottie

class BallonScene: SKScene {

    var backButton: UIButton!
    var currentBalloonIndex = 0  // Tracks the current balloon to pop
    var poppedBalloons = Set<Int>()  // Set to keep track of popped balloons
    var animationView: LottieAnimationView!
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupBalloons()
        createBackButton()
    }

    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "gökkuşağı")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
    }

    private func setupBalloons() {
        let targetWidth: CGFloat = 120 // Balloon size

        func adjustedSize(for imageNamed: String, targetWidth: CGFloat) -> CGSize {
            let texture = SKTexture(imageNamed: imageNamed)
            let aspectRatio = texture.size().width / texture.size().height
            return CGSize(width: targetWidth, height: targetWidth / aspectRatio)
        }

        let leftBackPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.75),
            CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.50),
            CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.25)
        ]
        let leftFrontPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.7),
            CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.35)
        ]
        let rightBackPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.75),
            CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.50),
            CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.25)
        ]
        let rightFrontPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.7),
            CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.35)
        ]

        for i in 0..<10 {
            let ballon = SKSpriteNode(imageNamed: "balloon\(i)")
            ballon.name = "balloon-\(i)"
            ballon.size = adjustedSize(for: "balloon\(i)", targetWidth: targetWidth)
            
            if i < 3 {
                ballon.position = leftBackPositions[i]
            } else if i < 5 {
                ballon.position = leftFrontPositions[i - 3]
            } else if i < 8 {
                ballon.position = rightBackPositions[i - 5]
            } else {
                ballon.position = rightFrontPositions[i - 8]
            }
            
            ballon.zPosition = (i < 5) ? 1 : 0
            addChild(ballon)
            
            addGentleMovementAnimation(to: ballon)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(balloonTapped(_:)))
            self.view?.addGestureRecognizer(tapGesture)
        }
    }

    private func addGentleMovementAnimation(to balloon: SKSpriteNode) {
        let moveX = CGFloat.random(in: -50...50)
        let moveY = CGFloat.random(in: -30...30)
        let moveDuration = 4.0

        let moveActionX = SKAction.sequence([
            SKAction.moveBy(x: moveX, y: 0, duration: moveDuration),
            SKAction.moveBy(x: -moveX, y: 0, duration: moveDuration)
        ])
        
        let moveActionY = SKAction.sequence([
            SKAction.moveBy(x: 0, y: moveY, duration: moveDuration),
            SKAction.moveBy(x: 0, y: -moveY, duration: moveDuration)
        ])

        let moveGroup = SKAction.group([moveActionX, moveActionY])
        let repeatForeverAction = SKAction.repeatForever(moveGroup)

        balloon.run(repeatForeverAction)
    }

    @objc func balloonTapped(_ recognizer: UITapGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.view)
        let sceneLocation = convertPoint(fromView: touchLocation)
        
        let nodesAtPoint = nodes(at: sceneLocation)
        
        for node in nodesAtPoint {
            if let balloon = node as? SKSpriteNode, balloon.name?.starts(with: "balloon") == true {
                let balloonIndex = Int(balloon.name!.split(separator: "-")[1]) ?? -1
                if balloonIndex == currentBalloonIndex {
                    popBalloon(balloon)
                    currentBalloonIndex += 1
                    break
                } else {
                    // If the balloon is clicked out of order, trigger the shake animation
                    shakeBalloon(balloon)
                }
            }
        }
    }
    
    private func popBalloon(_ balloon: SKSpriteNode) {
        // Spawn the Lottie animation at the balloon's position
        spawnBalls(at: balloon.position)
        
        // Balloon pop animation (scaling down)
        balloon.run(SKAction.scale(to: 0, duration: 0.5)) {
            balloon.removeFromParent() // Remove the balloon after it disappears
        }
    }


    
    private func spawnBalls(at position: CGPoint) {
        guard let skView = self.view as? SKView else { return }

        // SKScene pozisyonunu UIView pozisyonuna dönüştür
        let viewPosition = skView.convert(position, from: self)

        // Lottie animasyonunu oluştur ve doğru yerde konumlandır
        let animationView = LottieAnimationView(name: "balonRenkli") // Lottie dosya adı
        let animationSize: CGFloat = 200 // Animasyon boyutu
        animationView.frame = CGRect(
            x: viewPosition.x - animationSize / 2,
            y: viewPosition.y - animationSize / 2, // Y ekseni dönüşümü düzeltildi
            width: animationSize,
            height: animationSize
        )
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.0

        // Animasyonu SKView'e ekle
        skView.addSubview(animationView)

        // Animasyonu oynat ve tamamlandıktan sonra kaldır
        animationView.play { finished in
            if finished {
                animationView.removeFromSuperview()
            }
        }
    }






    // Helper function to get a random color
    private func getRandomColor() -> UIColor {
        let colors: [UIColor] = [
            .red, .green, .blue, .yellow, .purple, .orange, .cyan, .magenta
        ]
        return colors.randomElement() ?? .white
    }
 // Shake animation for incorrect balloon
    private func shakeBalloon(_ balloon: SKSpriteNode) {
        let shakeAction = SKAction.sequence([
            SKAction.moveBy(x: -10, y: 0, duration: 0.1),
            SKAction.moveBy(x: 20, y: 0, duration: 0.1),
            SKAction.moveBy(x: -20, y: 0, duration: 0.1),
            SKAction.moveBy(x: 10, y: 0, duration: 0.1)
        ])
        balloon.run(shakeAction)
    }

    func createBackButton() {
        guard let view = self.view else { return }
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

    override func willMove(from view: SKView) {
        backButton.removeFromSuperview()
    }
}
