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
    
    var playIconSprite: SKSpriteNode!
    
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
        animationFlyBalloon = LottieAnimationView(name: "AnimationFlyBallonn") // Balloon JSON animasyonu
        animationFlyBalloon.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationFlyBalloon.center = CGPoint(x: skView.bounds.midX + 120, y: skView.bounds.midY + 50) // Pozisyonlama
        animationFlyBalloon.loopMode = .loop
        animationFlyBalloon.play()
        
        // Balloon animasyonunu SKView'e ekle
        skView.addSubview(animationFlyBalloon)
        
        // Buton Oluşturma
        let playButton = UIButton(type: .system)
        playButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        playButton.center = CGPoint(x: animationFlyBalloon.center.x , y: animationFlyBalloon.center.y - 80) // Balonun merkezine yerleştirir
        playButton.backgroundColor = UIColor.clear
        
        // Play icon (Unicode play symbol)
        playButton.setTitle("\u{25B6}", for: .normal)
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 70) // Set the font size
        playButton.setTitleColor(.white, for: .normal) // Change color to orange
        
        // Butona işlev ekle
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        // SKView'e buton ekle
        skView.addSubview(playButton)
        
    }
    
    @objc func playButtonTapped() {
        // Butona basıldığında yapılacak işlemler
        print("Play butonuna tıklandı!")
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
