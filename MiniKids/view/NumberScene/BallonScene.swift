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
    var sunButton: UIButton!
    var isShowingSun = true
    var isAnimationPlaying = false
    var sunInitialYPosition: CGFloat = 0

    
    override func didMove(to view: SKView) {
        setupBackground()
        setupBalloons()
        createBackButton()
        createSunButton()
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
    private func showGameOverAnimation() {
        let celebrationSound = SKAction.playSoundFileNamed("musicGecis.mp3", waitForCompletion: false)
        self.run(celebrationSound)
        // Adım 1: "Tebrikler" yazısını ekle
        let congratulationsLabel = SKLabelNode(text: "Tebrikler!")
        congratulationsLabel.fontName = "AvenirNext-Bold"
        congratulationsLabel.fontSize = 50
        congratulationsLabel.fontColor = .red
        congratulationsLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        congratulationsLabel.zPosition = 10
        congratulationsLabel.setScale(0) // Başlangıç boyutu 0 (görünmez)
        addChild(congratulationsLabel)
        
        // Büyüme animasyonu
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.3)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        congratulationsLabel.run(scaleSequence)

        // Adım 2: Konfeti efektini başlat
        startConfettiEffect()

        // Adım 3: 3 saniye sonra sahneyi temizleyip ana menüye dön
        run(SKAction.wait(forDuration: 3.0)) {
            self.clearGameOverScene()
        }
    }

    private func startConfettiEffect() {
        let confettiColors: [UIColor] = [.red, .green, .blue, .yellow, .purple, .orange]
        let numberOfConfetti = 50
        
        for _ in 0..<numberOfConfetti {
            let confetti = SKShapeNode(circleOfRadius: 5)
            confetti.fillColor = confettiColors.randomElement() ?? .white
            confetti.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: size.height
            )
            confetti.zPosition = 5
            addChild(confetti)

            // Düşme animasyonu
            let moveDown = SKAction.moveBy(x: CGFloat.random(in: -50...50), y: -size.height, duration: 3.0)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveDown, fadeOut, remove])
            confetti.run(sequence)
        }
    }

    private func clearGameOverScene() {
        // Sahneyi temizle
        removeAllActions()
        removeAllChildren()

        // Ana menüye veya başka bir sahneye geçiş
        let ballonScene = AnimalScene(size: self.size)
        ballonScene.scaleMode = .aspectFill
        let transition = SKTransition.crossFade(withDuration: 1.0)
        self.view?.presentScene(ballonScene, transition: transition)
    }
    override func update(_ currentTime: TimeInterval) {
        if currentBalloonIndex == 10 { // Tüm balonlar patlatıldıysa
            showGameOverAnimation()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            
            // Check if mouse is hovering over any button
        GlowEffectManager.createGlowEffect(at: location, in: self)
        }
   

    private func moveSunOffScreen() {
        guard let sunButton = sunButton else { return }
        
        // Animate the sun/rain button to move off the screen after the last balloon is popped
        UIView.animate(withDuration: 1.0, animations: {
            sunButton.frame.origin.y = -sunButton.frame.height
        }) { _ in
            // Optionally, reset the sun/rain button to the initial position for the next round
            sunButton.frame.origin.y = self.sunInitialYPosition
        }
    }

    private func createSunButton() {
        guard let view = self.view else { return }
        
        sunButton = UIButton(type: .custom)
        sunButton.setImage(UIImage(named: "gunes"), for: .normal) // Başlangıç olarak güneş resmi
        
        // Düğmenin ekranın alt ortasında konumlanmasını sağla
        sunButton.frame = CGRect(
            x: (view.frame.width - 100) / 2, // X ekseninde ortala
            y: view.frame.height - 90,     // Y ekseninde alt ortada (120 kadar yukarıda)
            width: 100,
            height: 100
        )
        
        sunButton.addTarget(self, action: #selector(sunButtonTapped), for: .touchUpInside)
        view.addSubview(sunButton)
        view.bringSubviewToFront(sunButton) // Görünürlüğü garanti altına al
    }


    @objc private func sunButtonTapped() {
        if isAnimationPlaying {
            return // Don't trigger the animation if it's already playing
        }
        
        isAnimationPlaying = true // Set the flag to true when starting the animation
        
        if isShowingSun {
            triggerSunAnimation()
        } else {
            triggerRainAnimation()
        }
    }


    private func triggerSunAnimation() {
          guard let skView = self.view else { return }
          
          let sunAnimation = LottieAnimationView(name: "gunesAnimation")
          sunAnimation.frame = CGRect(
              x: skView.frame.width / 2 - 100, // Ortada
              y: skView.frame.height * 0.1,   // Yukarıda bir miktar yerleştirilmiş
              width: 200,
              height: 200
          )
          sunAnimation.contentMode = .scaleAspectFit
          sunAnimation.loopMode = .playOnce
          skView.addSubview(sunAnimation)

          // Animasyonu oynat
          sunAnimation.play()

          // 5 saniye bekledikten sonra animasyonu kaydır ve kaldır
          UIView.animate(withDuration: 3.0, delay: 5.0, options: .curveEaseInOut, animations: {
              sunAnimation.center = CGPoint(x: -100, y: skView.frame.height * 0.1)
          }, completion: { _ in
              sunAnimation.removeFromSuperview()
              self.sunButton.setImage(UIImage(named: "yagmur"), for: .normal)
              self.isShowingSun = false
              self.isAnimationPlaying = false // Reset the flag after the animation is complete
          })
      }



    private func triggerRainAnimation() {
        guard let skView = self.view else { return }
        
        let leftRainAnimation = LottieAnimationView(name: "yagmurAnimation")
        let rightRainAnimation = LottieAnimationView(name: "yagmurAnimation")

        let animationSize: CGFloat = 150
        leftRainAnimation.frame = CGRect(
            x: skView.frame.width * 0.3 - animationSize / 2, // Sol pozisyon
            y: skView.frame.height * 0.1,
            width: animationSize,
            height: animationSize
        )
        rightRainAnimation.frame = CGRect(
            x: skView.frame.width * 0.7 - animationSize / 2, // Sağ pozisyon
            y: skView.frame.height * 0.1,
            width: animationSize,
            height: animationSize
        )
        
        leftRainAnimation.contentMode = .scaleAspectFit
        rightRainAnimation.contentMode = .scaleAspectFit
        leftRainAnimation.loopMode = .playOnce
        rightRainAnimation.loopMode = .playOnce
        
        skView.addSubview(leftRainAnimation)
        skView.addSubview(rightRainAnimation)

        // Animasyonları oynat
        leftRainAnimation.play()
        rightRainAnimation.play()
        
        // 5 saniye bekledikten sonra animasyonları kaydır ve kaldır
        UIView.animate(withDuration: 3.0, delay: 5.0, options: .curveEaseInOut, animations: {
            leftRainAnimation.center = CGPoint(x: skView.frame.width * 0.3, y: -animationSize)
            rightRainAnimation.center = CGPoint(x: skView.frame.width * 0.7, y: -animationSize)
        }, completion: { _ in
            leftRainAnimation.removeFromSuperview()
            rightRainAnimation.removeFromSuperview()
            self.sunButton.setImage(UIImage(named: "gunes"), for: .normal)
            self.isShowingSun = true
            self.isAnimationPlaying = false // Reset the flag after the animation is complete
        })
    }


    private func addGentleMovementAnimation(to balloon: SKSpriteNode) {
        let moveX = CGFloat.random(in: -50...50)
        let moveY = CGFloat.random(in: -30...30)
        let moveDuration = 6.0

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

        // Move the sun/rain button upwards after each balloon pop
        if let sunButton = sunButton {
            // Move the sun/rain button by a certain distance after each pop
            let moveUpAction = SKAction.moveBy(x: 0, y: 30, duration: 0.3) // Move up by 30 points
            sunButton.frame.origin.y -= 30 // Move it manually in the frame
            if sunButton.frame.origin.y <= 0 { // If it's moved out of the screen
                sunButton.frame.origin.y = -sunButton.frame.height // Move it off the screen completely
            }
        }
        balloon.removeAllActions()
        balloon.removeFromParent()

        // Check if all balloons have been popped and move the sun/rain button off-screen
        if currentBalloonIndex == 10 { // If the last balloon is popped (assuming 10 balloons)
            moveSunOffScreen()
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
        // Don't allow the back button action if an animation is still playing
        if isAnimationPlaying {
            return // Exit the method and do nothing
        }
        
        // First, remove the sun button and animations before transitioning
        sunButton.removeFromSuperview()
        animationView?.stop() // Stop any active animation
        animationView?.removeFromSuperview()
        backButton.removeFromSuperview()

        // Now perform the scene transition after UI cleanup
        let nextScene = NextScene(size: self.size)
        nextScene.scaleMode = .aspectFill

        // Transition with a fade effect after the cleanup is done
        self.view?.presentScene(nextScene, transition: SKTransition.fade(withDuration: 1.0))
    }


    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        if let gestures = view.gestureRecognizers {
            for gesture in gestures {
                view.removeGestureRecognizer(gesture)
            }
        }
        
        // Diğer temizlik işlemleri
        sunButton?.removeFromSuperview()
        backButton?.removeFromSuperview()
        removeAllActions()
        removeAllChildren()
           physicsWorld.speed = 0
    }

}
