//
//  GameScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 17.10.2024.
//

import SpriteKit
import GameplayKit
import Lottie

class GameScene: SKScene {
    
    var animationTiger : LottieAnimationView!
    
    var animationFlyBalloon : LottieAnimationView!
    
    override func didMove(to view: SKView) {
        
        // `SKView`'i güvenli şekilde unwrap ediyoruz
        guard let skView = self.view else { return }
        
        // Tiger Animasyonu
        animationTiger = LottieAnimationView(name: "AnimationTiger") // Tiger JSON animasyonu
        animationTiger.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationTiger.center = CGPoint(x: skView.bounds.midX - 120, y: skView.bounds.midY + 50) // Pozisyonlama
        animationTiger.loopMode = .loop
        animationTiger.play()
        
        // Animasyon görünümünü SKView'e ekle
        skView.addSubview(animationTiger)
        
        // Balloon Fly Animasyonu
        animationFlyBalloon = LottieAnimationView(name: "AnimationFlyBallon") // Balloon JSON animasyonu
        animationFlyBalloon.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationFlyBalloon.center = CGPoint(x: skView.bounds.midX + 120, y: skView.bounds.midY + 50) // Pozisyonlama
        animationFlyBalloon.loopMode = .loop
        animationFlyBalloon.play()
        
        // Balloon animasyonunu SKView'e ekle
        skView.addSubview(animationFlyBalloon)
        // Buton Oluşturma
        let forwardButton = UIButton(type: .system)
        forwardButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        forwardButton.center = CGPoint(x: animationFlyBalloon.center.x, y: animationFlyBalloon.center.y) // Balonun merkezine yerleştirir
        forwardButton.backgroundColor = UIColor.clear
        
        // İleri sarma simgesi
        let forwardIcon = UIImage(systemName: "forward.fill")
        forwardButton.setImage(forwardIcon, for: .normal)
        
        // Butona işlev ekle
        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        
        // SKView'e buton ekle
        skView.addSubview(forwardButton)
        
    }
    
    @objc func forwardButtonTapped() {
        // Butona basıldığında yapılacak işlemler
        print("İleri sarma butonuna tıklandı!")
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    
    
    
}
