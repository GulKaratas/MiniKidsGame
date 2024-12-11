//
//  RunScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 29.11.2024.
//

import UIKit
import SpriteKit

class RunScene: SKScene {
    var bunny: SKSpriteNode!
    var backButton: UIButton!
    
    override func didMove(to view: SKView) {
        // Arkaplan kaydırma efektini başlat
        setupScrollingBackground()
        
        // Bunny'nin başlangıç duruşunu ayarla
        bunny = SKSpriteNode(imageNamed: "bunny") // İlk poz (normal duruş)
        
        // Bunny boyutunu büyüt
        bunny.size = CGSize(width: 150, height: 150) // Daha büyük bir boyut
        
        // Bunny'nin pozisyonunu ekranda sola, aşağıya doğru ayarla
        bunny.position = CGPoint(x: size.width * 0.10, y: size.height * 0.25)
        bunny.zPosition = 1 // Önde olacak
        addChild(bunny)
        
        // Koşma animasyonunu başlat
        startRunningAnimation()
        createBackButton()
    }
    
    func setupScrollingBackground() {
        // İki arkaplan oluştur
        for i in 0...1 {
            let background = SKSpriteNode(imageNamed: "run1")
            background.anchorPoint = CGPoint(x: 0, y: 0.5) // Sol kenardan başlayacak
            background.position = CGPoint(x: CGFloat(i) * self.size.width, y: self.size.height / 2)
            background.zPosition = -2
            background.size = CGSize(width: self.size.width, height: self.size.height) // Ekranı tamamen dolduracak
            background.name = "run2"
            addChild(background)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Her karede arkaplanı kaydır
        enumerateChildNodes(withName: "run2") { (node, _) in
            if let background = node as? SKSpriteNode {
                // Arkaplanı sola kaydır
                background.position.x -= 2 // Kaydırma hızı
                
                // Arkaplan tamamen görünümden çıkarsa pozisyonunu sıfırla
                if background.position.x <= -self.size.width {
                    background.position.x += self.size.width * 2
                }
            }
        }
    }
    
    func startRunningAnimation() {
        // Animasyon karelerini yükle
        let runFrames = [
            SKTexture(imageNamed: "bunny1"),
            SKTexture(imageNamed: "bunny2"),
            SKTexture(imageNamed: "bunny3"),
            SKTexture(imageNamed: "bunny4"),
            SKTexture(imageNamed: "bunny5")
        ]
        
        // Çerçeveleri animasyon döngüsü olarak ayarla
        let runAction = SKAction.animate(with: runFrames, timePerFrame: 0.1) // Her kare 0.1 saniye
        let repeatRunAction = SKAction.repeatForever(runAction) // Sonsuz döngü
        
        // Bunny'nin koşma animasyonunu başlat
        bunny.run(repeatRunAction)
    }


    func createBackButton() {
        guard let view = self.view else { return }
        
        // Butonu başlat
        backButton = UIButton(type: .custom)
        
        // Buton görselini ayarla
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        
        // Buton boyutunu ayarla ve yuvarlak yap
        backButton.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
        backButton.layer.cornerRadius = 25
        backButton.clipsToBounds = true
        
        // Butona tıklama işlevi ekle
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Butonu görünüme ekle
        view.addSubview(backButton)
    }
    @objc func backButtonTapped() {
        let nextScene = NextScene(size: self.size)
        nextScene.scaleMode = .aspectFill
        self.view?.presentScene(nextScene, transition: SKTransition.fade(withDuration: 1.0))
        
        // Geçiş yapıldığında butonu görünümden kaldır
        backButton.removeFromSuperview()
    }

    override func willMove(from view: SKView) {
        // Scene'den çıkarken butonun kaldırıldığından emin olun
        backButton.removeFromSuperview()
    }
}
