import UIKit
import SpriteKit

class AnimalScene: SKScene {
    var backButton: UIButton!
    var cardNodes: [CardNode] = []
    var flippedCards: [CardNode] = []
    var isCheckingMatch = false
    var transitionMusic: SKAudioNode?
    
    var backgroundNode: SKSpriteNode! // Arka plan node'u değişkeni
    var currentRound = 1
    
    override func didMove(to view: SKView) {
        setupBackground() // Arka planı ayarlayan fonksiyon çağrılıyor
        createBackButton()
        setupCards(forRound: currentRound)
    }
    
    func setupBackground() {
        // Arka plan nodu oluşturulup sahneye ekleniyor
        backgroundNode = SKSpriteNode(imageNamed: "dunya")
        backgroundNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundNode.zPosition = -1
        backgroundNode.size = self.size
        addChild(backgroundNode)
        
        
    }
    
    func setupCards(forRound round: Int) {
        let cardImages: [String]
        
        switch round {
        case 1:
            cardImages = ["at", "kaplan", "tavuk", "kedi", "tavşan", "inek", "at", "kaplan", "tavuk", "kedi", "tavşan", "inek"]
        case 2:
            cardImages = ["aslan", "ayı", "karga", "koala", "balık", "penguen", "aslan", "ayı", "karga", "koala", "balık", "penguen"]
        case 3:
            cardImages = ["balina", "çita", "fil", "ördek", "serçe", "sincap", "balina", "çita", "fil", "ördek", "serçe", "sincap"]
        default:
            cardImages = []
        }
        
        var shuffledImages = cardImages.shuffled()
        var backImages = ["kart 1", "kart 2", "kart 3", "kart 4", "kart 5", "kart 6", "kart 7", "kart 8", "kart 9", "kart 10", "kart 11", "kart 12"]
        
        let rows = 3
        let columns = 4
        let cardWidth: CGFloat = 160
        let cardHeight: CGFloat = 160
        let padding: CGFloat = 20
        
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
                card.alpha = 0
                card.zPosition = 1
                addChild(card)
                cardNodes.append(card)

                let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
                let waitAction = SKAction.wait(forDuration: 0.1 * Double(row * columns + col))
                card.run(SKAction.sequence([waitAction, fadeInAction]))
            }
        }
    }

    func addBounceEffect(to card: CardNode) {
        let bounceUp = SKAction.scale(to: 1.2, duration: 0.1)
        let bounceDown = SKAction.scale(to: 1.0, duration: 0.1)
        let bounceSequence = SKAction.sequence([bounceUp, bounceDown])
        card.run(bounceSequence)
    }

    func flipCard(_ card: CardNode) {
        guard !isCheckingMatch, flippedCards.count < 2, !card.isFlipped else { return }
        
        addBounceEffect(to: card)
        card.flip()
        flippedCards.append(card)
        
        if flippedCards.count == 2 {
            checkForMatch()
        }
    }

    func checkForMatch() {
        let firstCard = flippedCards[0]
        let secondCard = flippedCards[1]

        isCheckingMatch = true

        if firstCard.frontImageName == secondCard.frontImageName {
            firstCard.matchFound()
            secondCard.matchFound()
            GlowEffectManager.createGlowOutlineEffect(around: firstCard, in: self)
            GlowEffectManager.createGlowOutlineEffect(around: secondCard, in: self)

            flippedCards.removeAll()
            isCheckingMatch = false

            // Check if all cards are matched
            if cardNodes.allSatisfy({ $0.isMatched }) {
                startTransitionMusic()
                fillScreenWithAnimalFaces()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                firstCard.flipBack()
                secondCard.flipBack()
                self.flippedCards.removeAll()
                self.isCheckingMatch = false
            }
        }
    }

    func startTransitionMusic() {
        guard transitionMusic == nil else { return }

        // SKAudioNode'u doğrudan dosya adı ile başlatıyoruz
        let musicNode = SKAudioNode(fileNamed: "musicGecis.mp3")
        musicNode.autoplayLooped = true
        addChild(musicNode)
        transitionMusic = musicNode
    }


    func stopTransitionMusic() {
        transitionMusic?.removeFromParent()
        transitionMusic = nil
    }

    func resetCardsForNewRound() {
        stopTransitionMusic()  // Müziği durdur
        // Geçişten önce arka planda gereksiz öğeleri temizle
        self.children.filter { $0 is SKSpriteNode && ($0 as! SKSpriteNode).texture != nil && $0 != backgroundNode }.forEach { $0.removeFromParent() }
        
        // Kartlar ve flip işlemlerini sıfırlayın
        cardNodes.removeAll()
        flippedCards.removeAll()
        
        // Yeni tura başla
        currentRound += 1
        setupCards(forRound: currentRound)
    }


    
    func fillScreenWithAnimalFaces() {
        let spawnAction = SKAction.repeat(SKAction.sequence([
            SKAction.run { self.spawnAnimalFace() },
            SKAction.wait(forDuration: 0.01)
        ]), count: 300)

        self.run(spawnAction) {
            self.resetCardsForNewRound()
        }
    }

    func spawnAnimalFace() {
        guard let randomCard = cardNodes.randomElement() else { return }
        let animalFaceNode = SKSpriteNode(imageNamed: randomCard.frontImageName)
        
        let randomX = CGFloat.random(in: 0...self.size.width)
        let randomY = CGFloat.random(in: 0...self.size.height)
        animalFaceNode.position = CGPoint(x: randomX, y: randomY)
        animalFaceNode.size = CGSize(width: 100, height: 100)
        animalFaceNode.zPosition = 3
        
        addChild(animalFaceNode)
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
        stopTransitionMusic() // Müziği durdur
        
        // Eski öğeleri temizle
        self.children.filter { $0 is SKSpriteNode && ($0 as! SKSpriteNode).texture != nil && $0 != backgroundNode }.forEach { $0.removeFromParent() }
        
        let nextScene = NextScene(size: self.size)
        nextScene.scaleMode = .aspectFill
        self.view?.presentScene(nextScene, transition: SKTransition.fade(withDuration: 1.0))
    }



    override func willMove(from view: SKView) {
        backButton.removeFromSuperview()
    }
}
