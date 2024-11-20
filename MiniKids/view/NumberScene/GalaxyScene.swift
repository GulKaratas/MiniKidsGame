//
//  GalaxyScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 17.11.2024.
//

import UIKit
import SpriteKit
import AVFoundation

class GalaxyScene: SKScene {
    var backButton: UIButton!
    var usedNumbers = Set<Int>()
    var currentNumber = 0
    var bottomGalaxy: SKSpriteNode?
    var isSoundPlaying = false
    var audioPlayer: AVAudioPlayer?
    var audioPlayerBackground: AVAudioPlayer?
    var currentRocketSoundIndex = 0
    var totalGalaxies = 10 // Total number of galaxies
    var galaxiesDestroyed = 0
    
    override func didMove(to view: SKView) {
        // Arka planı ayarla
        let background = SKSpriteNode(imageNamed: "galaxyBackground")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
        
        // Geri butonunu oluştur
        createBackButton()
        
        // Galaxy'leri ekrana yerleştir
        createGalaxies()
        
        // Alt uzay mekiği oluştur
        createBottomGalaxy()
        
        loadSounds()
    }

    func createGalaxies() {
        let galaxySize = CGSize(width: 180, height: 180)  // Başlangıç boyutu

        // Galaksilerin orantılarını koruyarak yeniden boyutlandırılmasını sağlamak
        func adjustedSize(for imageNamed: String, targetWidth: CGFloat) -> CGSize {
            // Resmin boyutlarını almak için SKTexture kullanın
            let texture = SKTexture(imageNamed: imageNamed)
            let aspectRatio = texture.size().width / texture.size().height
            return CGSize(width: targetWidth, height: targetWidth / aspectRatio)
        }


        // Sol ve sağ galaksi konumları
        let leftBackPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.75),
            CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.55),
            CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.35)
        ]

        let leftFrontPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.7),
            CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.45)
        ]

        let rightBackPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.75),
            CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.55),
            CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.35)
        ]

        let rightFrontPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.7),
            CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.45)
        ]
        
        // Sol taraf için 3 arka galaxy
        for i in 0..<3 {
            let galaxy = SKSpriteNode(imageNamed: "galaxy\(i)")
            galaxy.name = "galaxy-\(i)"
            galaxy.size = adjustedSize(for: "galaxy\(i)", targetWidth: 180)  // Boyutları orantılı ayarlayın
            galaxy.position = leftBackPositions[i]
            galaxy.zPosition = 0
            addChild(galaxy)
            addGalaxyMotion(to: galaxy)
            addUniqueRandomNumber(to: galaxy)
        }

        // Sol taraf için 2 ön galaxy
        for i in 3..<5 {
            let galaxy = SKSpriteNode(imageNamed: "galaxy\(i)")
            galaxy.name = "galaxy-\(i)"
            galaxy.size = adjustedSize(for: "galaxy\(i)", targetWidth: 180)  // Boyutları orantılı ayarlayın
            galaxy.position = leftFrontPositions[i - 3]
            galaxy.zPosition = 1
            addChild(galaxy)
            addGalaxyMotion(to: galaxy)
            addUniqueRandomNumber(to: galaxy)
        }

        // Sağ taraf için 3 arka galaxy
        for i in 5..<8 {
            let galaxy = SKSpriteNode(imageNamed: "galaxy\(i)")
            galaxy.name = "galaxy-\(i)"
            galaxy.size = adjustedSize(for: "galaxy\(i)", targetWidth: 180)  // Boyutları orantılı ayarlayın
            galaxy.position = rightBackPositions[i - 5]
            galaxy.zPosition = 0
            addChild(galaxy)
            addGalaxyMotion(to: galaxy)
            addUniqueRandomNumber(to: galaxy)
        }

        // Sağ taraf için 2 ön galaxy
        for i in 8..<10 {
            let galaxy = SKSpriteNode(imageNamed: "galaxy\(i)")
            galaxy.name = "galaxy-\(i)"
            galaxy.size = adjustedSize(for: "galaxy\(i)", targetWidth: 180)  // Boyutları orantılı ayarlayın
            galaxy.position = rightFrontPositions[i - 8]
            galaxy.zPosition = 1
            addChild(galaxy)
            addGalaxyMotion(to: galaxy)
            addUniqueRandomNumber(to: galaxy)
        }
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtLocation = nodes(at: location)
        
        for node in nodesAtLocation {
            if let spaceship = node as? SKSpriteNode, spaceship.name == "roket" {
                playSequentialRocketSound() // Play the next sound
                rotateRocket(spaceship)
            }
        }
        
        for node in nodesAtLocation {
            if let galaxy = node as? SKSpriteNode, let name = galaxy.name, name.starts(with: "galaxy") {
                // Galaxy'nin doğru sayıya basıldığını kontrol et
                if let numberNode = galaxy.children.first as? SKSpriteNode,
                   let numberName = numberNode.name,
                   let number = Int(numberName.replacingOccurrences(of: "number-", with: "")) {
                    if number == currentNumber {
                        // Doğru sayı, galaxy patlat
                        explodeGalaxy(at: galaxy.position)
                        galaxy.removeFromParent()
                        galaxiesDestroyed += 1 // Increment the destroyed galaxy count
                        currentNumber += 1  // Artık doğru galaxy patlatıldı, bir sonraki sayıya geç
                        moveRocketUp()
                        
                        // Check if all galaxies have been destroyed
                        if galaxiesDestroyed == totalGalaxies {
                            // Trigger the victory animation (explosion of galaxies)
                            animateGalaxiesExplosion()  // Start the explosion effect
                        }
                    } else {
                        // Yanlış sayı, galaxy'yi sallama animasyonu
                        shakeGalaxy(galaxy)
                    }
                }
            }
        }
    }

    func animateGalaxiesExplosion() {
        let celebrationSound = SKAction.playSoundFileNamed("musicGecis.mp3", waitForCompletion: false)
        self.run(celebrationSound)
        
        let galaxyTextures: [SKTexture] = [
            SKTexture(imageNamed: "galaxy0"),
            SKTexture(imageNamed: "galaxy1"),
            SKTexture(imageNamed: "galaxy2"),
            SKTexture(imageNamed: "galaxy3"),
            SKTexture(imageNamed: "galaxy4"),
            SKTexture(imageNamed: "galaxy5"),
            SKTexture(imageNamed: "galaxy6"),
            SKTexture(imageNamed: "galaxy7"),
            SKTexture(imageNamed: "galaxy8"),
            SKTexture(imageNamed: "galaxy9")
        ]
        
        // Galaxy'leri hızlı bir şekilde oluşturmak için sürekli olarak spawn yapalım
        let spawnNewGalaxy = SKAction.run {
            let randomTexture = galaxyTextures.randomElement()!
            let newGalaxyNode = SKSpriteNode(texture: randomTexture)
            newGalaxyNode.position = CGPoint(x: CGFloat.random(in: 0..<self.size.width),
                                             y: CGFloat.random(in: 0..<self.size.height))
            newGalaxyNode.zPosition = 3
            

            // Boyutları daha büyük yapalım
            let randomSize = CGFloat.random(in: 50...300) // Büyük boyut
            newGalaxyNode.size = CGSize(width: randomSize, height: randomSize)
            
            self.addChild(newGalaxyNode)
        }
        
        // Galaxy'leri çok hızlı bir şekilde spawn etmek için aksiyon
        let spawnInterval = SKAction.repeatForever(SKAction.sequence([spawnNewGalaxy, SKAction.wait(forDuration: 0.01)]))
        
        // Galaxy'leri hızlı bir şekilde spawn etmeye başla
        run(spawnInterval)
        
        // Ekranı hızlıca kaplayacak şekilde tüm galaxy'ler çoğalacak
        let waitAction = SKAction.wait(forDuration: 3.0)  // 5 saniye sonra geçiş yapılacak
        let transitionAction = SKAction.run {
            self.transitionToBallonScene()  // Yeni sahneye geçiş
        }
        
        // Galaxiler çoğaldıktan sonra sahneye geçiş yapılacak
        let fullSequence = SKAction.sequence([waitAction, transitionAction])
        run(fullSequence)
    }


    func transitionToBallonScene() {
        let ballonScene = BallonScene(size: self.size)
        ballonScene.scaleMode = .aspectFill
        self.view?.presentScene(ballonScene, transition: SKTransition.fade(withDuration: 1.0))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            
            // Check if mouse is hovering over any button
        GlowEffectManager.createGlowEffect(at: location, in: self)
        }

    func playSequentialRocketSound() {
        let rocketSounds = ["roket1", "roket2", "roket"]
        
        // Ensure the index is within the array bounds
        if currentRocketSoundIndex >= rocketSounds.count {
            currentRocketSoundIndex = 0 // Reset to the first sound
        }
        
        let selectedSound = rocketSounds[currentRocketSoundIndex]
        currentRocketSoundIndex += 1 // Increment for the next call
        
        if let path = Bundle.main.path(forResource: selectedSound, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play() // Play the sound
            } catch {
                print("Error loading sound: \(error)")
            }
        } else {
            print("Sound file not found: \(selectedSound).mp3")
        }
    }


    func rotateRocket(_ spaceship: SKSpriteNode) {
        let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: 1.0) // Tam bir dönüş
        spaceship.run(rotateAction)
    }
      

        func explodeGalaxy(at position: CGPoint) {
            let ballCount = 20 // Taş sayısını arttırmak için bu değeri değiştirebilirsiniz

            for _ in 0..<ballCount {
                // Kendi eklediğiniz taş resmini kullanan SKSpriteNode oluşturuyoruz
                let customImage = SKSpriteNode(imageNamed: "stone.png") // Burada resminizin adını kullanın
                
                // Resminizin boyutunu kontrol edin ve ihtiyacınıza göre ayarlayın
                customImage.size = CGSize(width: 30, height: 30) // Resmin boyutunu ayarlayın
                customImage.position = position
                customImage.zPosition = 3
                customImage.alpha = 1.0 // Tam opaklık (saydam değil)
                addChild(customImage)
                
                // Ekran boyutlarına göre rastgele yön ve mesafe hesaplama
                let randomX = CGFloat.random(in: -self.size.width...self.size.width)
                let randomY = CGFloat.random(in: -self.size.height...self.size.height)
                let randomDuration = Double.random(in: 1.0...2.0) // Hareket süresi

                // Animasyon: Resimleri rastgele yönlere hareket ettirip kaybolmasını sağlamak
                customImage.run(SKAction.sequence([
                    SKAction.group([
                        SKAction.moveBy(x: randomX, y: randomY, duration: randomDuration),
                        SKAction.fadeOut(withDuration: randomDuration) // Kaybolma süresi
                    ]),
                    SKAction.removeFromParent()
                ]))
                
                // Rastgele dönme efekti ekleyerek görselliği artırabiliriz
                let rotateAction = SKAction.rotate(byAngle: CGFloat.random(in: -4 * .pi...4 * .pi), duration: randomDuration)
                customImage.run(rotateAction)
            }

            // Play the sound when the galaxy explodes
            if let path = Bundle.main.path(forResource: "galaxySounds", ofType: "mp3") {
                   let url = URL(fileURLWithPath: path)
                   do {
                       audioPlayer = try AVAudioPlayer(contentsOf: url)
                       audioPlayer?.play()
                   } catch {
                       print("Error playing explosion sound: \(error)")
                   }
               }
        }

    func loadSounds() {
           // Load explosion sound
           if let path = Bundle.main.path(forResource: "galaxySounds", ofType: "mp3") {
               let url = URL(fileURLWithPath: path)
               do {
                   audioPlayer = try AVAudioPlayer(contentsOf: url)
               } catch {
                   print("Error loading sound: \(error)")
               }
           }
           
           // Load background music
           if let path = Bundle.main.path(forResource: "galaxyBackgroundSounds", ofType: "wav") {
               let url = URL(fileURLWithPath: path)
               do {
                   audioPlayerBackground = try AVAudioPlayer(contentsOf: url)
                   audioPlayerBackground?.numberOfLoops = -1 // Loop indefinitely
                   audioPlayerBackground?.play() // Start background music
               } catch {
                   print("Error loading background sound: \(error)")
               }
           }
       }
    
    func moveRocketUp() {
        guard let spaceship = bottomGalaxy else { return }
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 0.5)
        spaceship.run(moveUp) {
            if spaceship.position.y >= self.size.height {
                print("Oyun bitti! Roket üst noktaya ulaştı.")
                
            }
        }
    }


       func shakeGalaxy(_ galaxy: SKSpriteNode) {
           let shakeLeft = SKAction.moveBy(x: -10, y: 0, duration: 0.1)
           let shakeRight = SKAction.moveBy(x: 10, y: 0, duration: 0.1)
           let shakeSequence = SKAction.sequence([shakeLeft, shakeRight, shakeLeft, shakeRight])
           galaxy.run(shakeSequence)
       }

    func createBottomGalaxy() {
        // Alt uzay mekiği
        let spaceshipImage = SKSpriteNode(imageNamed: "roket")
        spaceshipImage.size = CGSize(width: 250, height: 230)
        spaceshipImage.position = CGPoint(x: self.size.width / 2, y: spaceshipImage.size.height / 2 + 20)
        spaceshipImage.zPosition = 1
        spaceshipImage.name = "roket"
        addChild(spaceshipImage)
        bottomGalaxy = spaceshipImage
    }

    func addUniqueRandomNumber(to galaxy: SKSpriteNode) {
        var randomNumber: Int
        repeat {
            randomNumber = Int.random(in: 0...9)
        } while usedNumbers.contains(randomNumber)
        
        usedNumbers.insert(randomNumber)
        
        let numberNames = ["galaxySifir", "galaxyBir", "galaxyIki", "galaxyUc", "galaxyDort", "galaxyBes", "galaxyAlti", "galaxyYedi", "galaxySekiz", "galaxyDokuz"]
        let numberNode = SKSpriteNode(imageNamed: numberNames[randomNumber])
        numberNode.name = "number-\(randomNumber)"
        numberNode.size = CGSize(width: 70, height: 70)
        numberNode.zPosition = 2
        galaxy.addChild(numberNode)
    }

    func addGalaxyMotion(to galaxy: SKSpriteNode) {
        let randomX = CGFloat.random(in: -20...20)
        let randomY = CGFloat.random(in: -20...20)
        let randomDuration = Double.random(in: 1.0...2.0)
        
        let move1 = SKAction.moveBy(x: randomX, y: randomY, duration: randomDuration)
        let move2 = SKAction.moveBy(x: -randomX, y: -randomY, duration: randomDuration)
        let rotate1 = SKAction.rotate(byAngle: .pi / 8, duration: randomDuration)
        let rotate2 = SKAction.rotate(byAngle: -.pi / 8, duration: randomDuration)
        
        let moveSequence = SKAction.sequence([move1, rotate1, move2, rotate2])
        let repeatAction = SKAction.repeatForever(moveSequence)
        
        galaxy.run(repeatAction)
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
        audioPlayerBackground?.stop()
    }
}
