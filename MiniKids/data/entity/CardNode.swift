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
    private var synthesizer = AVSpeechSynthesizer()  // TTS (Text-to-Speech) için synthesizer

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
        playAnimalSound()
    }
    
    // Hayvanın ismine göre adını sesli olarak okuma
    private func playAnimalSound() {
        let animalName: String
        
        // frontImageName'e göre hayvan ismini seç
        switch frontImageName {
        case "at":
            animalName = "at"
        case "tavuk":
            animalName = "tavuk"
        case "tavşan":
            animalName = "tavşan"
        case "inek":
            animalName = "inek"
        case "kaplan":
            animalName = "kaplan"
        case "kedi":
            animalName = "kedi"
        // Diğer hayvanlar için de benzer case ifadeleri ekleyebilirsiniz
        default:
            return // Tanımlı bir hayvan adı yoksa geri dön
        }
        
        // AVSpeechUtterance ile sesli olarak hayvan adını okuma
        let utterance = AVSpeechUtterance(string: animalName)
        utterance.voice = AVSpeechSynthesisVoice(language: "tr-TR")  // Türkçe seslendirme
        synthesizer.speak(utterance)
    }
}
