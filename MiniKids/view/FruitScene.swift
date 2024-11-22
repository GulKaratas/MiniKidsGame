//  FruitScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 30.10.2024.
//

import UIKit
import SpriteKit

class FruitScene: SKScene {
    var backButton: UIButton!

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

        // Geri butonunu oluştur
        createBackButton()
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
        let thoughtCloudImage = SKSpriteNode(imageNamed: "düsünceBulutu")  // Düşünce bulutu görseli
        thoughtCloudImage.size = CGSize(width: self.size.width * 0.4, height: self.size.height * 0.6) // Boyut ayarı
        thoughtCloudImage.position = CGPoint(x: rabbitImage.position.x, y: rabbitImage.position.y + rabbitImage.size.height / 2 + thoughtCloudImage.size.height / 5)
        thoughtCloudImage.zPosition = 2  // Tavşanın üzerinde olmalı
        addChild(thoughtCloudImage)
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
        let fruitNames = ["domates", "havuç", "kiraz", "mantar", "soğan", "kabak","bezelye","steak","çilek","armut","avakado","biber","brokoli","but","ekmek","elma","ekmek","karpuz","kivi","üzüm","yumurta","salatalık","portakal","muz","peynir","morSoğan","marul"] // Meyve isimleri

        // Raf konumlarını ayarla
        let numberOfShelves = 3 // Toplam raf sayısı
        let shelfHeightSpacing: CGFloat = counter.size.height / CGFloat(numberOfShelves) // Raflar arasındaki mesafe
        let shelfStartY = counter.position.y + counter.size.height / 2 - shelfHeightSpacing / 2 // Üst rafın başlangıç y pozisyonu

        // Raflar için ayarlanmış Y ofsetleri
        let shelfOffsets: [CGFloat] = [
            shelfStartY - 90,               // Üst raf (biraz aşağıya indirildi)
            shelfStartY - shelfHeightSpacing * 1.0 - 10, // Orta raf (çok az aşağıya indirildi)
            shelfStartY - shelfHeightSpacing * 2.0 + 60  // Alt raf (biraz yukarıya çıkarıldı)
        ]

        // Rafların zPosition değerlerini belirle
        let shelfZPosition: CGFloat = 0
        let fruitZPosition: CGFloat = 1 // Meyveler rafların üstünde olacak

        // Her rafta sürekli meyve çıkışı sağlayan bir döngü
        for (index, shelfY) in shelfOffsets.enumerated() {
            let waitDuration = Double(index) * 0.5 // Her raf için zamanlama farkı (ekran doluluk için)
            let actionSequence = SKAction.sequence([
                SKAction.wait(forDuration: waitDuration), // Zamanlama farkı
                SKAction.run { [weak self] in
                    self?.spawnFruit(on: counter, at: shelfY, zPosition: fruitZPosition) // Meyve oluştur
                },
                SKAction.wait(forDuration: 1.5) // Yeni meyve çıkmadan önce bekleme süresi kısaltıldı (3. Meyve hızlıca gelir)
            ])
            let repeatForever = SKAction.repeatForever(actionSequence)
            run(repeatForever)
        }
    }

    func spawnFruit(on counter: SKSpriteNode, at shelfY: CGFloat, zPosition: CGFloat) {
        let fruitNames = ["domates", "havuç", "kiraz", "mantar", "soğan", "kabak","steak","çilek","armut","avakado","biber","brokoli","but","ekmek","elma","ekmek","karpuz","kivi","üzüm","yumurta","salatalık","portakal","muz","peynir","morSoğan","marul"] // Meyve isimleri
        let fruitName = fruitNames.randomElement() ?? "domates" // Rastgele bir meyve seç
        let fruit = SKSpriteNode(imageNamed: fruitName)

        // Meyve boyutunu ayarlama (özel boyutlar için kontrol ekle)
        var fruitSize: CGSize
        switch fruitName {
        case "karpuz":
            fruitSize = CGSize(width: counter.size.width * 0.18, height: counter.size.height * 0.2) // Karpuz biraz daha büyük
        case "salatalık":
            fruitSize = CGSize(width: counter.size.width * 0.2, height: counter.size.height * 0.06) // Salatalık daha küçük
        case "elma":
            fruitSize = CGSize(width: counter.size.width * 0.12, height: counter.size.height * 0.12) // Elma boyutunu farklı yap
        case "but":
            fruitSize = CGSize(width: counter.size.width * 0.15, height: counter.size.height * 0.15) // Elma boyutunu farklı yap
        case "havuç":
            fruitSize = CGSize(width: counter.size.width * 0.13, height: counter.size.height * 0.13) // Elma boyutunu farklı yap
        default:
            fruitSize = CGSize(width: counter.size.width * 0.12, height: counter.size.height * 0.12) // Diğer meyveler için standart boyut
        }

        fruit.size = fruitSize

        // Meyvenin başlangıç pozisyonunu ayarla (rafın sol dışından başlayacak, biraz daha sağa kaydırıldı)
        fruit.position = CGPoint(
            x: counter.position.x - counter.size.width / 2 - fruit.size.width + 115, // Meyvenin biraz daha sağda başlaması için 115 eklenmiş
            y: shelfY
        )

        // Rafların önünde görünmesini sağlamak için meyve zPosition değerini ayarla
        fruit.zPosition = 3 // Meyve rafların önünde olacak

        // Meyveyi ekle
        addChild(fruit)

        // Meyveyi sağa doğru hareket ettir (kaybolma noktası biraz daha sola kaydırıldı)
        let moveRight = SKAction.moveBy(x: counter.size.width + fruit.size.width * 2 - 285, y: 0, duration: 4.0) // Kaybolma noktası biraz daha sola kaydırıldı
        let remove = SKAction.removeFromParent()

        // Animasyon dizisi: Sağa hareket et ve kaldır
        let sequence = SKAction.sequence([moveRight, remove])
        fruit.run(sequence)
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
