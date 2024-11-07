import SpriteKit

class GlowEffectManager {
    
    // İnce ışıltı efekti oluşturmak için static bir metod
    static func createGlowEffect(at position: CGPoint, in scene: SKScene) {
        // .sks dosyasından partikül efektini yükle
        if let glowEmitter = SKEmitterNode(fileNamed: "Particle.sks") {
            
            glowEmitter.position = position
            glowEmitter.zPosition = 3   // Işıltı efektini diğer objelerin üstüne koy
            glowEmitter.particleScale = 0.0001  // Daha ince bir efekt için partikül boyutunu küçült
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
    static func createGlowOutlineEffect(around node: SKNode, in scene: SKScene) {
        // Set the glow effect's shape and size based on the node's size
        let glowOutline = SKShapeNode(rectOf: CGSize(width: node.frame.width + 10, height: node.frame.height + 10), cornerRadius: 10)
        glowOutline.position = node.position
        glowOutline.zPosition = 2  // Place the glow outline above other elements
        
        // Style the outline with a white glow effect
        glowOutline.strokeColor = .white  // White glow color for a "magic" effect
        glowOutline.lineWidth = 5         // Outline thickness
        glowOutline.glowWidth = 15        // Width of the glow effect
        
        // Add the glow outline to the scene
        scene.addChild(glowOutline)
    
        
        // Play a "magic" sound effect
      //  let magicSound = SKAction.playSoundFileNamed("magic.mp3", waitForCompletion: false)
      //  scene.run(magicSound)
        
      
        // Remove the glow effect after a short duration
        glowOutline.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()
        ]))
    }

}
