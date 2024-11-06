import SpriteKit

class GlowEffectManager {
    
    // İnce ışıltı efekti oluşturmak için static bir metod
    static func createGlowEffect(at position: CGPoint, in scene: SKScene) {
        // .sks dosyasından partikül efektini yükle
        if let glowEmitter = SKEmitterNode(fileNamed: "Particle.sks") {
            
            glowEmitter.position = position
            glowEmitter.zPosition = 3   // Işıltı efektini diğer objelerin üstüne koy
            glowEmitter.particleScale = 0.02  // Daha ince bir efekt için partikül boyutunu küçült
            glowEmitter.particleScaleRange = 0.01  // Partiküllerin boyutlarının küçük bir değişim göstermesini sağla
            glowEmitter.particleBirthRate = 80  // Partiküllerin daha hızlı doğmasını sağla
            glowEmitter.particleColor = .cyan  // Işıltı rengini belirle (istediğiniz renge göre değiştirebilirsiniz)
            
            // Efekti sahneye ekle
            scene.addChild(glowEmitter)
            
            // Efektin bitiminde kısa bir süre sonra kaldırılmasını sağla
            glowEmitter.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.5),  // Efektin görünme süresi (yarım saniye)
                SKAction.removeFromParent()       // Efekti sahneden kaldır
            ]))
        }
    }
}
