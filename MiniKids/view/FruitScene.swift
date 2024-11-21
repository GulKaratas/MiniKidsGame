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
        let rabbitImage = SKSpriteNode(imageNamed: "cat")
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
        let wait = SKAction.wait(forDuration: 2.0)

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
        
        // Düşünce bulutu ekle
        let thoughtCloudImage = SKSpriteNode(imageNamed: "düsünceBulutu")  // Düşünce bulutu görseli
        thoughtCloudImage.size = CGSize(width: self.size.width * 0.4, height: self.size.height * 0.6) // Boyut ayarı
        thoughtCloudImage.position = CGPoint(x: rabbitImage.position.x, y: rabbitImage.position.y + rabbitImage.size.height / 2 + thoughtCloudImage.size.height / 5)
        thoughtCloudImage.zPosition = 2  // Tavşanın üzerinde olmalı
        addChild(thoughtCloudImage)
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
