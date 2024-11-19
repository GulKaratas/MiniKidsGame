//
//  CardNode.swift
//  MiniKids
//
//  Created by Gül Karataş on 7.11.2024.
//

import UIKit
import SpriteKit
import AVFoundation

class CardNode: SKSpriteNode {
    let frontImageName: String
    let backImageName: String
    var isFlipped = false
    var isMatched = false
    private var synthesizer = AVSpeechSynthesizer()  // TTS (Text-to-Speech) için synthesizer (Artık kullanılmayacak)

    init(frontImageName: String, backImageName: String) {
        self.frontImageName = frontImageName
        self.backImageName = backImageName
        let texture = SKTexture(imageNamed: backImageName)
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flip() {
        guard !isFlipped else { return }
        isFlipped = true
        texture = SKTexture(imageNamed: frontImageName)
    }
    
    func flipBack() {
        guard isFlipped, !isMatched else { return }
        isFlipped = false
        texture = SKTexture(imageNamed: backImageName)
    }
    
    
    func matchFound() {
        isMatched = true
        playMagicSound()  // Magic sound when a match is found
    }
    
    // Magic sound (instead of animal name) when a match is found
    private func playMagicSound() {
        let magicSound = SKAction.playSoundFileNamed("magic.mp3", waitForCompletion: false)
        self.run(magicSound)
    }
}
