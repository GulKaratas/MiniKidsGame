//
//  NumberScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 30.10.2024.
//

import UIKit
import SpriteKit

class NumberScene: SKScene {
    var backButton: UIButton!
    var usedNumbers = Set<Int>() // Kullanılan sayıları tutmak için bir küme, sınıfın içinde tanımlanmalı

    override func didMove(to view: SKView) {
        // Arka planı ayarla
        let background = SKSpriteNode(imageNamed: "bathroom1")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
        
        // Geri butonunu oluştur
        createBackButton()
        
        // Baloncukları ekrana yerleştir
        createBubbles()
    }

    func createBubbles() {
        let bubbleSize = CGSize(width: 150, height: 150) // Baloncuk boyutunu daha da büyüttük

        // Sol tarafa 5 baloncuk
        for i in 0..<5 {
            let bubble = SKSpriteNode(imageNamed: "baloncuk \(i)")
            bubble.size = bubbleSize
            bubble.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * (CGFloat(i) + 1) / 6)
            bubble.zPosition = 1
            addChild(bubble)
            
            // Rastgele sayı görselini ekleyin
            addUniqueRandomNumber(to: bubble)
        }

        // Sağ tarafa 5 baloncuk
        for i in 5..<10 {
            let bubble = SKSpriteNode(imageNamed: "baloncuk \(i)")
            bubble.size = bubbleSize
            bubble.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * (CGFloat(i - 5) + 1) / 6)
            bubble.zPosition = 1
            addChild(bubble)
            
            // Rastgele sayı görselini ekleyin
            addUniqueRandomNumber(to: bubble)
        }
    }

    func addUniqueRandomNumber(to bubble: SKSpriteNode) {
        // Rastgele ve benzersiz bir sayı seç
        var randomNumber: Int
        repeat {
            randomNumber = Int.random(in: 0...9)
        } while usedNumbers.contains(randomNumber) // Aynı sayıdan iki tane olmamasını sağlar
        
        // Seçilen sayıyı kullanılan sayılar dizisine ekle
        usedNumbers.insert(randomNumber)
        
        // Sayı görselini oluştur
        let numberNames = ["sıfır", "bir", "iki", "üç", "dört", "beş", "altı", "yedi", "sekiz", "dokuz"]
        let numberNode = SKSpriteNode(imageNamed: numberNames[randomNumber])
        numberNode.size = CGSize(width: 70, height: 70) // Sayı boyutu
        numberNode.zPosition = 2
        bubble.addChild(numberNode)
        
        // 3D yer çekimsiz hareket efekti
        let randomX = CGFloat.random(in: -20...20)
        let randomY = CGFloat.random(in: -20...20)
        let randomDuration = Double.random(in: 1.0...2.0)
        
        let move1 = SKAction.moveBy(x: randomX, y: randomY, duration: randomDuration)
        let move2 = SKAction.moveBy(x: -randomX, y: -randomY, duration: randomDuration)
        let rotate1 = SKAction.rotate(byAngle: .pi / 8, duration: randomDuration)
        let rotate2 = SKAction.rotate(byAngle: -.pi / 8, duration: randomDuration)
        
        let moveSequence = SKAction.sequence([move1, rotate1, move2, rotate2])
        let repeatAction = SKAction.repeatForever(moveSequence)
        
        numberNode.run(repeatAction)
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
        // NextScene'e geri dön
        let nextScene = NextScene(size: self.size)
        nextScene.scaleMode = .aspectFill
        self.view?.presentScene(nextScene, transition: SKTransition.fade(withDuration: 1.0))
        
        // Geçiş yapıldığında butonu görünümden kaldır
        backButton.removeFromSuperview()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Bir parlama efekti oluştur (Opsiyonel)
        GlowEffectManager.createGlowEffect(at: location, in: self)
    }

    override func willMove(from view: SKView) {
        // Scene'den çıkarken butonun kaldırıldığından emin olun
        backButton.removeFromSuperview()
    }
}
