//  FruitScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 30.10.2024.
//

import UIKit
import SpriteKit
import AVFoundation

class FruitScene: SKScene {
    var backButton: UIButton!
       var currentFruitName: String?
       var correctSound: AVAudioPlayer?
       var wrongSound: AVAudioPlayer?
       var thoughtCloudImage: SKSpriteNode!
       var remainingFruits: [String] = [] // Kalan meyveler
       let allFruits = ["domates", "havuç", "kiraz", "mantar", "soğan", "kabak","steak","çilek","armut","avakado","biber","brokoli","but","ekmek","elma","ekmek","karpuz","kivi","üzüm","yumurta","portakal","muz","peynir","morSoğan","marul","kabak1","lahana","kereviz","pırasa","yabanMersini","ejderMeyvesi","ananas","nar","kahvaltı","makarna","balik","köfte"]


    override func didMove(to view: SKView) {
        // Arka planı ayarla
        let background = SKSpriteNode(imageNamed: "fruitBackground")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -2
        
        // Arkaplan boyutunu ekran boyutuna sığacak şekilde ayarla
        background.size = self.size // Arkaplan tamamen ekrana sığacak
        addChild(background)

        // Masa ve yemek resmini ekle
        addTableWithFood()

        
        remainingFruits = allFruits.shuffled() // Meyveleri karıştır ve başlat
                showRandomFruitInThoughtCloud()
        // Geri butonunu oluştur
        createBackButton()
        loadSounds()
    }
    
    func addTableWithFood() {
        // Masa resmini oluştur
        let tableImage = SKSpriteNode(imageNamed: "masa")
        tableImage.size = CGSize(width: self.size.width * 0.35, height: self.size.height * 0.08) // Masayı orantılı boyutlandır
        tableImage.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.12) // Ekranın sol tarafına yerleştir
        tableImage.zPosition = 1
        addChild(tableImage)
        
        // Tavşan resmini oluştur
        let rabbitImage = SKSpriteNode(imageNamed: "catt")
        rabbitImage.size = CGSize(width: tableImage.size.width * 1.5, height: tableImage.size.height * 7.0) // Tavşanı orantılı boyutlandır
        rabbitImage.position = CGPoint(x: tableImage.position.x, y: tableImage.position.y + tableImage.size.height * 2.7) // Masanın üstüne yerleştir
        rabbitImage.zPosition = -1
        addChild(rabbitImage)
        
        // Tavşan nefes alıp verme animasyonu
        let breatheIn = SKAction.scaleY(to: 1.05, duration: 1.0) // Tavşanın boyu biraz uzuyor
        let breatheOut = SKAction.scaleY(to: 1.0, duration: 1.0) // Tavşan normal boyutuna dönüyor

        // Nefes alıp verme işlemi
        let breathing = SKAction.sequence([breatheIn, breatheOut])

        // Bekleme süresi (örneğin 2 saniye bekle)
        let wait = SKAction.wait(forDuration: 1.0)

        // Nefes alma ve bekleme işlemini tekrar et
        let breathingWithPause = SKAction.sequence([breathing, wait])

        // Hareketi tekrarlayacak şekilde ayarla
        rabbitImage.run(SKAction.repeatForever(breathingWithPause))

        // Tezgah resmi ekle
        let counterImage = SKSpriteNode(imageNamed: "tezgahh") // "tezgah" resminin ismini kullanıyorum.
        counterImage.size = CGSize(width: self.size.width * 0.48, height: self.size.height * 0.8) // Tezgah boyutları
        counterImage.zPosition = 1
        counterImage.position = CGPoint(x: self.size.width * 0.70, y: self.size.height * 0.57) // Sağ üst köşe
        addChild(counterImage)
        
        addShelves(to: counterImage)
        addMovingFruits(on: counterImage)
        
        // Düşünce bulutu ekle
        thoughtCloudImage = SKSpriteNode(imageNamed: "düsünceBulutu")  // Düşünce bulutu görseli
                thoughtCloudImage.size = CGSize(width: self.size.width * 0.4, height: self.size.height * 0.6) // Boyut ayarı
                thoughtCloudImage.position = CGPoint(x: rabbitImage.position.x, y: rabbitImage.position.y + rabbitImage.size.height / 2 + thoughtCloudImage.size.height / 10)
                thoughtCloudImage.zPosition = 2  // Tavşanın üzerinde olmalı
                addChild(thoughtCloudImage)

                // İlk rastgele meyveyi göster
                showRandomFruitInThoughtCloud()
    }
    
    func addShelves(to counter: SKSpriteNode) {
        let shelfHeight = counter.size.height * 0.025 // Rafların boyutunu tezgaha göre ayarla
        let yOffset: CGFloat = -200 // Rafların aşağı kayma miktarı
        let xOffset: CGFloat = -counter.size.width * 0.0080
        let topShelfExtraOffset: CGFloat = -12 // En üstteki raf için ekstra aşağı kaydırma miktarı

        for i in 0..<3 { // Üç raf ekle
            let shelf = SKSpriteNode(imageNamed: "raf") // Raf görselini kullan
            shelf.size = CGSize(width: counter.size.width * 0.816, height: shelfHeight) // Raf boyutları
            
            // En üstteki raf için ekstra kaydırma uygula
            let additionalYOffset = (i == 0) ? topShelfExtraOffset : 0
            
            shelf.position = CGPoint(
                x: counter.position.x + xOffset, // Rafları sola kaydır
                y: counter.position.y + counter.size.height / 2 - shelfHeight / 2 - CGFloat(i) * (shelfHeight + 115) + yOffset + additionalYOffset
            ) // Raflar arasına boşluk bırak ve aşağı kaydır
            shelf.zPosition = counter.zPosition + 1
            addChild(shelf)
        }
    }
    func addMovingFruits(on counter: SKSpriteNode) {
        let numberOfShelves = 3
        let shelfHeightSpacing: CGFloat = counter.size.height / CGFloat(numberOfShelves)
        let shelfStartY = counter.position.y + counter.size.height / 2 - shelfHeightSpacing / 2

        let shelfOffsets: [CGFloat] = [
            shelfStartY - 85,
            shelfStartY - shelfHeightSpacing * 1.0 - 5,
            shelfStartY - shelfHeightSpacing * 2.0 + 60
        ]

        let fruitZPosition: CGFloat = 1

        for (index, shelfY) in shelfOffsets.enumerated() {
            let waitDuration = Double(index) * 0.1
            let actionSequence = SKAction.sequence([
                SKAction.wait(forDuration: waitDuration),
                SKAction.run { [weak self] in
                    self?.spawnFruit(on: counter, at: shelfY, zPosition: fruitZPosition)
                },
                SKAction.wait(forDuration: 1.5)
            ])
            let repeatForever = SKAction.repeatForever(actionSequence)
            run(repeatForever)
        }
    }

    func spawnFruit(on counter: SKSpriteNode, at shelfY: CGFloat, zPosition: CGFloat) {
        // Eğer kalan meyve yoksa listeyi tekrar başlat
        if remainingFruits.isEmpty {
            remainingFruits = allFruits.shuffled()
        }

        // Kalan meyvelerden birini rastgele al
        let fruitName = remainingFruits.removeFirst()

        let fruit = SKSpriteNode(imageNamed: fruitName)
        fruit.name = fruitName

        var fruitSize: CGSize
        switch fruitName {
        case "karpuz":
            fruitSize = CGSize(width: counter.size.width * 0.18, height: counter.size.height * 0.2)
        case "elma":
            fruitSize = CGSize(width: counter.size.width * 0.12, height: counter.size.height * 0.12)
        case "but":
            fruitSize = CGSize(width: counter.size.width * 0.15, height: counter.size.height * 0.15)
        case "havuç":
            fruitSize = CGSize(width: counter.size.width * 0.13, height: counter.size.height * 0.13)
        case "yabanMersini":
            fruitSize = CGSize(width: counter.size.width * 0.13, height: counter.size.height * 0.13)
        case "ananas":
            fruitSize = CGSize(width: counter.size.width * 0.15, height: counter.size.height * 0.15)
        case "ejderMeyvesi":
            fruitSize = CGSize(width: counter.size.width * 0.13, height: counter.size.height * 0.13)
        case "nar":
            fruitSize = CGSize(width: counter.size.width * 0.17, height: counter.size.height * 0.17)
        default:
            fruitSize = CGSize(width: counter.size.width * 0.12, height: counter.size.height * 0.12)
        }

        fruit.size = fruitSize

        fruit.position = CGPoint(
            x: counter.position.x - counter.size.width / 2 - fruit.size.width + 115,
            y: shelfY
        )
        fruit.zPosition = 3

        addChild(fruit)

        let moveRight = SKAction.moveBy(x: counter.size.width + fruit.size.width * 2 - 285, y: 0, duration: 4.0)
        let remove = SKAction.removeFromParent()

        let sequence = SKAction.sequence([moveRight, remove])
        fruit.run(sequence)
    }

    func showRandomFruitInThoughtCloud() {
        // Düşünce bulutunun içindeki tüm çocukları kaldır
        thoughtCloudImage.removeAllChildren()

        // Eğer kalan meyve yoksa listeyi tekrar başlat
        if remainingFruits.isEmpty {
            remainingFruits = allFruits.shuffled()
        }

        // Kalan meyvelerden bir tane al
        currentFruitName = remainingFruits.removeFirst()

        guard let fruitName = currentFruitName else { return }

        // Seçilen meyve resmi oluştur
        let fruit = SKSpriteNode(imageNamed: fruitName)

        // Meyve boyutunu düşünce bulutunun boyutuna göre ayarla
        fruit.size = CGSize(width: thoughtCloudImage.size.width * 0.2,
                            height: thoughtCloudImage.size.height * 0.2)

        // Düşünce bulutunun merkezinin biraz yukarısına yerleştir
        fruit.position = CGPoint(x: 0, y: thoughtCloudImage.size.height * 0.1)

        // Z-pozisyonunu ayarla
        fruit.zPosition = 1

        // Meyveyi düşünce bulutunun içine ekle
        thoughtCloudImage.addChild(fruit)
    }



       func handleFruitTap(fruitName: String) {
           if fruitName == currentFruitName {
               // Doğru cevap
               correctSound?.play() // Doğru sesini çal
               showRandomFruitInThoughtCloud() // Yeni rastgele meyve göster
           } else {
               // Yanlış cevap
               wrongSound?.play() // Yanlış sesini çal
           }
       }

       func loadSounds() {
           // Doğru sesini yükle
           if let correctSoundURL = Bundle.main.url(forResource: "correctSound", withExtension: "mp3") {
               correctSound = try? AVAudioPlayer(contentsOf: correctSoundURL)
           }

           // Yanlış sesini yükle
           if let wrongSoundURL = Bundle.main.url(forResource: "wrongSound", withExtension: "mp3") {
               wrongSound = try? AVAudioPlayer(contentsOf: wrongSoundURL)
           }
       }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        // Dokunulan nesneleri al
        let touchedNodes = nodes(at: location)
        for node in touchedNodes {
            if let fruitNode = node as? SKSpriteNode, let fruitName = fruitNode.name {
                // Meyve adı düşünce bulutundaki meyveyle aynı mı?
                if fruitName == currentFruitName {
                    // Doğru cevap
                    correctSound?.play()
                    fruitNode.removeFromParent() // Doğru meyveyi ekrandan kaldır
                    showRandomFruitInThoughtCloud() // Yeni meyve göster
                } else {
                    // Yanlış cevap
                    wrongSound?.play()
                }
            }
        }
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
