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
    var usedNumbers = Set<Int>() // Kullanılan sayıları tutmak için bir küme
    var currentNumber = 0 // Kullanıcının doğru sırayla tıklaması gereken sayı
    var bottomBubble: SKSpriteNode? // Alt baloncuk referansı
    var isSoundPlaying = false

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
        
        // Alt baloncuk oluştur
        createBottomBubble()
    }

    func createBubbles() {
        let bubbleSize = CGSize(width: 180, height: 180)

        // Sol taraftaki arka baloncukların pozisyonları
        let leftBackPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.75), // Arka 1
            CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.55), // Arka 2
            CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.35)  // Arka 3
        ]

        // Sol taraftaki ön baloncukların pozisyonları
        let leftFrontPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.65), // Ön 1
            CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.45)  // Ön 2
        ]

        // Sağ taraftaki arka baloncukların pozisyonları
        let rightBackPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.75), // Arka 1
            CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.55), // Arka 2
            CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.35)  // Arka 3
        ]

        // Sağ taraftaki ön baloncukların pozisyonları
        let rightFrontPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.65), // Ön 1
            CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.45)  // Ön 2
        ]

        // Sol taraf için 3 arka baloncuk
        for i in 0..<3 {
            let bubble = SKSpriteNode(imageNamed: "baloncuk \(i)")
            bubble.name = "bubble-\(i)"
            bubble.size = bubbleSize
            bubble.position = leftBackPositions[i] // Keeping the positions as they are
            bubble.zPosition = 0 // Arka planda
            addChild(bubble)

            // Rastgele sayı görselini ekle
            addUniqueRandomNumber(to: bubble)
        }

        // Sol taraf için 2 ön baloncuk
        for i in 3..<5 {
            let bubble = SKSpriteNode(imageNamed: "baloncuk \(i)")
            bubble.name = "bubble-\(i)"
            bubble.size = bubbleSize
            bubble.position = leftFrontPositions[i - 3] // Keep the front bubbles aligned below
            bubble.zPosition = 1 // Ön planda
            addChild(bubble)

            // Rastgele sayı görselini ekle
            addUniqueRandomNumber(to: bubble)
        }

        // Sağ taraf için 3 arka baloncuk
        for i in 5..<8 {
            let bubble = SKSpriteNode(imageNamed: "baloncuk \(i)")
            bubble.name = "bubble-\(i)"
            bubble.size = bubbleSize
            bubble.position = rightBackPositions[i - 5] // Keeping the positions as they are
            bubble.zPosition = 0 // Arka planda
            addChild(bubble)

            // Rastgele sayı görselini ekle
            addUniqueRandomNumber(to: bubble)
        }

        // Sağ taraf için 2 ön baloncuk
        for i in 8..<10 {
            let bubble = SKSpriteNode(imageNamed: "baloncuk \(i)")
            bubble.name = "bubble-\(i)"
            bubble.size = bubbleSize
            bubble.position = rightFrontPositions[i - 8] // Keep the front bubbles aligned below
            bubble.zPosition = 1 // Ön planda
            addChild(bubble)

            // Rastgele sayı görselini ekle
            addUniqueRandomNumber(to: bubble)
        }
    }



    func createBottomBubble() {
        // Baloncuk resmi
        let bubbleImage = SKSpriteNode(imageNamed: "baloncuk")
        bubbleImage.size = CGSize(width: 180, height: 180)
        bubbleImage.position = CGPoint(x: self.size.width / 2, y: bubbleImage.size.height / 2 + 40)
        bubbleImage.zPosition = 1
        bubbleImage.name = "bottomBubble"
        addChild(bubbleImage)
        bottomBubble = bubbleImage
        
        // Sabun resmi
        let soapImage = SKSpriteNode(imageNamed: "sabun")
        soapImage.size = CGSize(width: 100, height: 100)
        soapImage.position = CGPoint(x: 0, y: 0)
        soapImage.zPosition = 1
        soapImage.name = "soap"
        bubbleImage.addChild(soapImage)
    }

    func addUniqueRandomNumber(to bubble: SKSpriteNode) {
        var randomNumber: Int
        repeat {
            randomNumber = Int.random(in: 0...9)
        } while usedNumbers.contains(randomNumber)
        
        usedNumbers.insert(randomNumber)
        
        // Sayı görseli
        let numberNames = ["sıfır", "bir", "iki", "üç", "dört", "beş", "altı", "yedi", "sekiz", "dokuz"]
        let numberNode = SKSpriteNode(imageNamed: numberNames[randomNumber])
        numberNode.name = "number-\(randomNumber)"
        numberNode.size = CGSize(width: 70, height: 70)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if node.name == "soap" {
                // Sabuna tıklandı ve ses daha önce çalmadıysa çal
                if !isSoundPlaying {
                    isSoundPlaying = true
                    // Sabun tıklama sesini çal
                    let duckSound = SKAction.playSoundFileNamed("duck.mp3", waitForCompletion: true)
                    
                    if let soapNode = node as? SKSpriteNode {
                        // Sabun hareket animasyonu
                        let moveUp = SKAction.moveBy(x: 0, y: 10, duration: 0.3)
                        let moveDown = SKAction.moveBy(x: 0, y: -10, duration: 0.3)
                        let moveSequence = SKAction.sequence([moveUp, moveDown])
                        let repeatAction = SKAction.repeatForever(moveSequence)
                        
                        // Animasyonu başlat
                        soapNode.run(repeatAction, withKey: "moveSoap")
                        
                        // Ses çalma işlemi tamamlandığında animasyonu durdur
                        run(duckSound) {
                            soapNode.removeAction(forKey: "moveSoap") // Hareketi durdur
                            soapNode.position = CGPoint(x: 0, y: 0) // Orijinal konuma getir
                            self.isSoundPlaying = false // Ses çalma tamamlandığında flag'i sıfırla
                        }
                    }
                }
                return
            }

            if let bubble = node.parent as? SKSpriteNode, let numberNode = node as? SKSpriteNode, let numberName = numberNode.name, numberName.contains("number-") {
                let tappedNumber = Int(numberName.split(separator: "-")[1])!
                
                if tappedNumber == currentNumber {
                    // Doğru sayıya tıklandı
                    bubble.removeAllChildren()
                    bubble.run(SKAction.sequence([
                        SKAction.scale(to: 0, duration: 0.3),
                        SKAction.removeFromParent()
                    ]))
                    createSmallBubbles(at: bubble.position)
                    currentNumber += 1
                    moveBottomBubbleUp()
                    
                    if currentNumber > 9 {
                        print("Tüm baloncuklar patlatıldı! Oyun tamamlandı.")
                        createWaterBubbles()  // Küçük su balonlarını başlat
                        return
                    }
                } else {
                    // Yanlış sayıya tıklandı
                    bubble.run(SKAction.sequence([
                        SKAction.moveBy(x: -10, y: 0, duration: 0.1),
                        SKAction.moveBy(x: 20, y: 0, duration: 0.1),
                        SKAction.moveBy(x: -10, y: 0, duration: 0.1)
                    ]))
                }
                return
            }
        }
    }

    // Küçük baloncukların büyüyerek ekranı kaplamasını sağlayan fonksiyon
    func createWaterBubbles() {
        // Animasyon başlamadan önce müziği çal
        let celebrationSound = SKAction.playSoundFileNamed("musicGecis.mp3", waitForCompletion: false)
        self.run(celebrationSound)

        let totalBubbleStages = 20 // Baloncukların artış aşamalarının sayısı
        let bubblesPerStage = 120 // Her aşamada eklenen baloncuk sayısı
        
        if let soapNode = childNode(withName: "soap") as? SKSpriteNode {
                soapNode.isHidden = true
            }
        
        for stage in 0..<totalBubbleStages {
            // Her aşamada baloncukların oluşturulması
            let delay = Double(stage) * 0.1 // Her aşama arasında 0.1 saniye bekle
            run(SKAction.wait(forDuration: delay)) {
                for _ in 0..<bubblesPerStage {
                    let smallBubble = SKSpriteNode(imageNamed: "baloncuk")
                    smallBubble.size = CGSize(width: 40, height: 40) // Küçük boyutlu başlar
                    smallBubble.position = CGPoint(x: CGFloat.random(in: 0...self.size.width),
                                                   y: CGFloat.random(in: 0...self.size.height))
                    smallBubble.zPosition = 3
                    self.addChild(smallBubble)
                    
                    // Rastgele yayılma ve büyüme animasyonu
                    let randomX = CGFloat.random(in: -self.size.width...self.size.width)
                    let randomY = CGFloat.random(in: -self.size.height...self.size.height)
                    let randomDuration = Double.random(in: 1.5...2.5)
                    
                    let growAction = SKAction.scale(to: 5, duration: randomDuration)
                    let moveAction = SKAction.moveBy(x: randomX, y: randomY, duration: randomDuration)
                    let fadeOutAction = SKAction.fadeOut(withDuration: randomDuration)
                    
                    // Baloncuk animasyonunu çalıştır
                    smallBubble.run(SKAction.sequence([
                        SKAction.group([growAction, moveAction, fadeOutAction]),
                        SKAction.removeFromParent()
                    ]))
                }
            }
        }
        
        // Son aşama tamamlandığında sahne geçişi ekleyin
        let finalDelay = Double(totalBubbleStages) * 0.1 // Son aşamadan sonra bekleme süresi
        run(SKAction.wait(forDuration: finalDelay)) {
            self.transitionToGalaxyScene()
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            
            // Check if mouse is hovering over any button
        GlowEffectManager.createGlowEffect(at: location, in: self)
        }
    func transitionToGalaxyScene() {
        let galaxyScene = GalaxyScene(size: self.size)
        galaxyScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 1.0) // Geçiş animasyonu
        self.view?.presentScene(galaxyScene, transition: transition)
    }


    func createSmallBubbles(at position: CGPoint) {
        let bubbleCount = 20 // Daha fazla baloncuk eklemek için sayıyı artırdık

        for _ in 0..<bubbleCount {
            let smallBubble = SKSpriteNode(imageNamed: "baloncuk")
            smallBubble.size = CGSize(width: 35, height: 35) // Orta boy bir baloncuk
            smallBubble.position = position
            smallBubble.zPosition = 3
            addChild(smallBubble)
            
            // Ekran boyutlarına göre rastgele yön ve mesafe hesaplama
            let randomX = CGFloat.random(in: -self.size.width...self.size.width)
            let randomY = CGFloat.random(in: -self.size.height...self.size.height)
            let randomDuration = Double.random(in: 1.0...2.0) // Daha uzun süre
            
            // Animasyon: Etrafa sıçrama ve kaybolma
            smallBubble.run(SKAction.sequence([
                SKAction.group([
                    SKAction.moveBy(x: randomX, y: randomY, duration: randomDuration),
                    SKAction.fadeOut(withDuration: randomDuration) // Kaybolma süresi
                ]),
                SKAction.removeFromParent()
            ]))
            
            // Rastgele dönme efekti ekleyerek görselliği artırabiliriz
            let rotateAction = SKAction.rotate(byAngle: CGFloat.random(in: -4 * .pi...4 * .pi), duration: randomDuration)
            smallBubble.run(rotateAction)
        }
        playRandomSound()
    }
    
    func playRandomSound() {
        let soundNames = ["sayilar1", "sayilar2", "sayilar3", "sayilar4"]
        let randomSoundName = soundNames.randomElement()! // Rastgele bir ses seç
        let playSoundAction = SKAction.playSoundFileNamed(randomSoundName, waitForCompletion: false)
        run(playSoundAction) // Sesi çal
    }



    func moveBottomBubbleUp() {
        bottomBubble?.run(SKAction.moveBy(x: 0, y: 50, duration: 0.3))
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
