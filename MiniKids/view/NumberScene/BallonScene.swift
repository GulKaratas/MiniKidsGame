//
//  BallonScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 18.11.2024.
//

import UIKit
import SpriteKit
import AVFoundation

class BallonScene: SKScene {
    
    var backButton: UIButton!
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupBalloons()
        createBackButton()
    }
    
    // Arka planı ayarlayan fonksiyon
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "gökkuşağı") // Arka plan resmi adı
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size // Arka planı tam sahne boyutunda ayarla
        background.zPosition = -1 // Arka planı en arkada tut
        addChild(background)
    }
    
    // Balonları yerleştiren fonksiyon
    private func setupBalloons() {
        let targetWidth: CGFloat = 120 // Balonların genişliğini küçültmek için düşük bir değer

        // Galaksilerin orantılarını koruyarak yeniden boyutlandırılmasını sağlamak
        func adjustedSize(for imageNamed: String, targetWidth: CGFloat) -> CGSize {
            // Resmin boyutlarını almak için SKTexture kullanın
            let texture = SKTexture(imageNamed: imageNamed)
            let aspectRatio = texture.size().width / texture.size().height
            return CGSize(width: targetWidth, height: targetWidth / aspectRatio)
        }

        // Balon pozisyonları
        let leftBackPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.75), // Sol üst köşe
            CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.50), // Sol ortada
            CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.25)  // Sol alt köşe
        ]
        let leftFrontPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.7),  // Sol üst ön
            CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.35)  // Sol ortada ön
        ]
        let rightBackPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.75), // Sağ üst köşe
            CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.50), // Sağ ortada
            CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.25)  // Sağ alt köşe
        ]
        let rightFrontPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.7),  // Sağ üst ön
            CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.35)  // Sağ ortada ön
        ]

        // Sol taraf için 3 arka balon
        for i in 0..<3 {
            let ballon = SKSpriteNode(imageNamed: "balloon\(i)")
            ballon.name = "balloon-\(i)"
            ballon.size = adjustedSize(for: "balloon\(i)", targetWidth: targetWidth) // Boyutları küçült
            ballon.position = leftBackPositions[i]
            ballon.zPosition = 0
            addChild(ballon)
        }

        // Sol taraf için 2 ön balon
        for i in 3..<5 {
            let ballon = SKSpriteNode(imageNamed: "balloon\(i)")
            ballon.name = "balloon-\(i)"
            ballon.size = adjustedSize(for: "balloon\(i)", targetWidth: targetWidth) // Boyutları küçült
            ballon.position = leftFrontPositions[i - 3]
            ballon.zPosition = 1
            addChild(ballon)
        }

        // Sağ taraf için 3 arka balon
        for i in 5..<8 {
            let ballon = SKSpriteNode(imageNamed: "balloon\(i)")
            ballon.name = "balloon-\(i)"
            ballon.size = adjustedSize(for: "balloon\(i)", targetWidth: targetWidth) // Boyutları küçült
            ballon.position = rightBackPositions[i - 5]
            ballon.zPosition = 0
            addChild(ballon)
        }

        // Sağ taraf için 2 ön balon
        for i in 8..<10 {
            let ballon = SKSpriteNode(imageNamed: "balloon\(i)")
            ballon.name = "balloon-\(i)"
            ballon.size = adjustedSize(for: "balloon\(i)", targetWidth: targetWidth) // Boyutları küçült
            ballon.position = rightFrontPositions[i - 8]
            ballon.zPosition = 1
            addChild(ballon)
        }
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
