//
//  AnimalScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 30.10.2024.
//

import UIKit
import SpriteKit

class AnimalScene: SKScene {
    var backButton: UIButton!
    var cardNodes: [CardNode] = []
    var flippedCards: [CardNode] = []
    var isCheckingMatch = false
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "farmBackground")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
        
        let overlay = SKSpriteNode(color: UIColor.white.withAlphaComponent(0.7), size: self.size)
        overlay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        overlay.zPosition = 0
        addChild(overlay)
        
        createBackButton()
        setupCards()
    }
    
    func setupCards() {
        // Front images for the cards (animal images)
        let cardImages = ["at", "kaplan", "tavuk", "kedi", "tavşan", "inek", "at", "kaplan", "tavuk", "kedi", "tavşan", "inek"]
        var shuffledImages = cardImages.shuffled()
        
        // Back images for the cards (card 1, card 2, etc.)
        var backImages = ["kart 1", "kart 2", "kart 3", "kart 4", "kart 5", "kart 6", "kart 7", "kart 8", "kart 9", "kart 10", "kart 11", "kart 12"]

        let rows = 3
        let columns = 4
        let cardWidth: CGFloat = 160
        let cardHeight: CGFloat = 160
        let padding: CGFloat = 20
        
        // Calculate the starting position to center the grid on the screen
        let totalWidth = CGFloat(columns) * (cardWidth + padding) - padding
        let totalHeight = CGFloat(rows) * (cardHeight + padding) - padding
        let startX = (self.size.width - totalWidth) / 2 + cardWidth / 2
        let startY = (self.size.height + totalHeight) / 2 - cardHeight / 2

        for row in 0..<rows {
                for col in 0..<columns {
                    let xPosition = startX + CGFloat(col) * (cardWidth + padding)
                    let yPosition = startY - CGFloat(row) * (cardHeight + padding)

                    let frontImageName = shuffledImages.removeLast()
                    let backImageName = backImages.removeLast()

                    let card = CardNode(frontImageName: frontImageName, backImageName: backImageName)
                    card.position = CGPoint(x: xPosition, y: yPosition)
                    card.size = CGSize(width: cardWidth, height: cardHeight)
                    card.alpha = 0  // Start invisible for fade-in effect
                    card.zPosition = 1
                    addChild(card)
                    cardNodes.append(card)

                    // Add fade-in animation
                    let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
                    let waitAction = SKAction.wait(forDuration: 0.1 * Double(row * columns + col)) // Staggered effect
                    card.run(SKAction.sequence([waitAction, fadeInAction]))
            }
        }
    }

    
    func flipCard(_ card: CardNode) {
            // Prevent flipping another card if a match check is in progress or if two cards are already flipped
            guard !isCheckingMatch, flippedCards.count < 2, !card.isFlipped else { return }
            
            // Flip the selected card
            card.flip()
            flippedCards.append(card)
            
            // If there are two flipped cards, check for a match
            if flippedCards.count == 2 {
                checkForMatch()
            }
        }
    
    func checkForMatch() {
            let firstCard = flippedCards[0]
            let secondCard = flippedCards[1]
            
            // Set flag to prevent further flips during match check
            isCheckingMatch = true
            
            if firstCard.frontImageName == secondCard.frontImageName {
                // Cards match
                firstCard.matchFound()
                secondCard.matchFound()
                
                // Add glow effect to matched cards
                GlowEffectManager.createGlowOutlineEffect(around: firstCard, in: self)
                GlowEffectManager.createGlowOutlineEffect(around: secondCard, in: self)
                
                // Clear flipped cards and reset flag
                flippedCards.removeAll()
                isCheckingMatch = false
            } else {
                // If cards don't match, flip them back after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    firstCard.flipBack()
                    secondCard.flipBack()
                    
                    // Clear flipped cards and reset flag after flipping back
                    self.flippedCards.removeAll()
                    self.isCheckingMatch = false
                }
            }
        }


    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if let card = nodes(at: location).first(where: { $0 is CardNode }) as? CardNode {
            flipCard(card)
        }
    }
    
    func createBackButton() {
        guard let view = self.view else { return }
        backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
        backButton.layer.cornerRadius = 25
        backButton.clipsToBounds = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
    }

    @objc func backButtonTapped() {
        let nextScene = NextScene(size: self.size)
        nextScene.scaleMode = .aspectFill
        self.view?.presentScene(nextScene, transition: SKTransition.fade(withDuration: 1.0))
        backButton.removeFromSuperview()
    }
    
    
    override func willMove(from view: SKView) {
        backButton.removeFromSuperview()
    }
}
