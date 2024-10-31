//
//  ShapesScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 30.10.2024.
//

import UIKit
import SpriteKit
import AVFoundation

class ShapesScene: SKScene {

    var geriButonu: UIButton!
    var sesEfektleri: [String: SKAction] = [:] // Her şekil için ses efektlerini saklamak için sözlük

    override func didMove(to view: SKView) {
        // Geri butonunu oluştur
        geriButonuOlustur()
        
        // Sesleri yükle
        sesEfektleriniYukle()
        
        // Şekilleri sırayla ekle
        sekilleriSiraIleEkle()
    }

    func geriButonuOlustur() {
        guard let view = self.view else { return }
        
        let arkaPlan = SKSpriteNode(imageNamed: "bulutluBackground")
        arkaPlan.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        arkaPlan.zPosition = -1
        arkaPlan.size = self.size
        addChild(arkaPlan)
        
        // Arka plana yarı saydam bir katman ekle
        let katman = SKSpriteNode(color: UIColor.white.withAlphaComponent(0.9), size: self.size)
        katman.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        katman.zPosition = 0
        addChild(katman)
        
        // Geri butonunu başlat
        geriButonu = UIButton(type: .custom)
        geriButonu.setImage(UIImage(named: "backButton"), for: .normal)
        geriButonu.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
        geriButonu.layer.cornerRadius = 25
        geriButonu.clipsToBounds = true
        geriButonu.addTarget(self, action: #selector(geriButonuTiklandi), for: .touchUpInside)
        view.addSubview(geriButonu)
    }

    @objc func geriButonuTiklandi() {
        let sonrakiSahne = NextScene(size: self.size)
        sonrakiSahne.scaleMode = .aspectFill
        self.view?.presentScene(sonrakiSahne, transition: SKTransition.fade(withDuration: 1.0))
        geriButonu.removeFromSuperview()
    }
    
    func sesEfektleriniYukle() {
        // Her şekil için ses dosyalarını yükleyin
        sesEfektleri["kare"] = SKAction.playSoundFileNamed("kareSes", waitForCompletion: false)
        sesEfektleri["daire"] = SKAction.playSoundFileNamed("daireSes", waitForCompletion: false)
        sesEfektleri["yildiz"] = SKAction.playSoundFileNamed("yildizSes", waitForCompletion: false)
        sesEfektleri["ucgen"] = SKAction.playSoundFileNamed("ucgenSes", waitForCompletion: false)
    }

    func sekilleriSiraIleEkle() {
        // Şekil isimleri ve konum bilgilerini liste halinde tanımlayın
        let sekilBilgileri = [
            (isim: "kare", x: self.size.width * 0.25, y: self.size.height * 0.75),
            (isim: "yildiz", x: self.size.width * 0.75, y: self.size.height * 0.75),
            (isim: "daire", x: self.size.width * 0.25, y: self.size.height * 0.25),
            (isim: "ucgen", x: self.size.width * 0.75, y: self.size.height * 0.25)
        ]
        
        // Her şekli sırayla eklemek için zamanlamalı bir döngü başlatın
        for (index, sekil) in sekilBilgileri.enumerated() {
            let beklemeSuresi = Double(index) * 0.2 // Her şekil için 1.5 saniye aralık bırak
            run(SKAction.wait(forDuration: beklemeSuresi)) { [weak self] in
                self?.sekilEkleVeSesCal(sekil.isim, x: sekil.x, y: sekil.y)
            }
        }
    }
    
    func sekilEkleVeSesCal(_ isim: String, x: CGFloat, y: CGFloat) {
        let sekilNode = SKSpriteNode(imageNamed: isim)
        sekilNode.position = CGPoint(x: x, y: y)
        sekilNode.zPosition = 1
        addChild(sekilNode)
        
        // Şekil belirirken ilgili sesi çal
        if let ses = sesEfektleri[isim] {
            sekilNode.run(ses)
        }
    }

    override func willMove(from view: SKView) {
        geriButonu.removeFromSuperview()
    }
}
