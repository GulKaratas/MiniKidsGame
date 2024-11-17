//
//  GalaxyScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 17.11.2024.
//

import UIKit
import SpriteKit

class GalaxyScene: SKScene {
    var backButton: UIButton!
    var usedNumbers = Set<Int>()
    var currentNumber = 0
    var bottomGalaxy: SKSpriteNode?
    var isSoundPlaying = false

    override func didMove(to view: SKView) {
        // Arka planı ayarla
        let background = SKSpriteNode(imageNamed: "galaxyBackground")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
        
        // Geri butonunu oluştur
        createBackButton()
        
        // Galaxy'leri ekrana yerleştir
        createGalaxies()
        
        // Alt uzay mekiği oluştur
        createBottomGalaxy()
    }

    func createGalaxies() {
        let galaxySize = CGSize(width: 180, height: 180)

        // Pozisyonlar aynı kalabilir
        let leftBackPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.75),
            CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.55),
            CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.35)
        ]

        let leftFrontPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.65),
            CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.45)
        ]

        let rightBackPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.75),
            CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.55),
            CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.35)
        ]

        let rightFrontPositions: [CGPoint] = [
            CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.65),
            CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.45)
        ]

        // Sol taraf için 3 arka galaxy
        for i in 0..<3 {
            let galaxy = SKSpriteNode(imageNamed: "galaxy \(i)")
            galaxy.name = "galaxy-\(i)"
            galaxy.size = galaxySize
            galaxy.position = leftBackPositions[i]
            galaxy.zPosition = 0
            addChild(galaxy)
            addUniqueRandomNumber(to: galaxy)
        }

        // Sol taraf için 2 ön galaxy
        for i in 3..<5 {
            let galaxy = SKSpriteNode(imageNamed: "galaxy \(i)")
            galaxy.name = "galaxy-\(i)"
            galaxy.size = galaxySize
            galaxy.position = leftFrontPositions[i - 3]
            galaxy.zPosition = 1
            addChild(galaxy)
            addUniqueRandomNumber(to: galaxy)
        }

        // Sağ taraf için 3 arka galaxy
        for i in 5..<8 {
            let galaxy = SKSpriteNode(imageNamed: "galaxy \(i)")
            galaxy.name = "galaxy-\(i)"
            galaxy.size = galaxySize
            galaxy.position = rightBackPositions[i - 5]
            galaxy.zPosition = 0
            addChild(galaxy)
            addUniqueRandomNumber(to: galaxy)
        }

        // Sağ taraf için 2 ön galaxy
        for i in 8..<10 {
            let galaxy = SKSpriteNode(imageNamed: "galaxy \(i)")
            galaxy.name = "galaxy-\(i)"
            galaxy.size = galaxySize
            galaxy.position = rightFrontPositions[i - 8]
            galaxy.zPosition = 1
            addChild(galaxy)
            addUniqueRandomNumber(to: galaxy)
        }
    }

    func createBottomGalaxy() {
        // Alt uzay mekiği
        let spaceshipImage = SKSpriteNode(imageNamed: "spaceship")
        spaceshipImage.size = CGSize(width: 200, height: 200)
        spaceshipImage.position = CGPoint(x: self.size.width / 2, y: spaceshipImage.size.height / 2 + 40)
        spaceshipImage.zPosition = 1
        spaceshipImage.name = "spaceship"
        addChild(spaceshipImage)
        bottomGalaxy = spaceshipImage
    }

    func addUniqueRandomNumber(to galaxy: SKSpriteNode) {
        var randomNumber: Int
        repeat {
            randomNumber = Int.random(in: 0...9)
        } while usedNumbers.contains(randomNumber)
        
        usedNumbers.insert(randomNumber)
        
        let numberNames = ["sıfır", "bir", "iki", "üç", "dört", "beş", "altı", "yedi", "sekiz", "dokuz"]
        let numberNode = SKSpriteNode(imageNamed: numberNames[randomNumber])
        numberNode.name = "number-\(randomNumber)"
        numberNode.size = CGSize(width: 70, height: 70)
        numberNode.zPosition = 2
        galaxy.addChild(numberNode)
        
        // 3D hareket efekti
        let randomX = CGFloat.random(in: -20...20)
        let randomY = CGFloat.random(in: -20...20)
        let randomDuration = Double.random(in: 1.0...2.0)
        
        let move1 = SKAction.moveBy(x: randomX, y: randomY, duration: randomDuration)
        let move2 = SKAction.moveBy(x: -randomX, y: -randomY, duration: randomDuration)
        let rotate1 = SKAction.rotate(byAngle: .pi / 8, duration: randomDuration)
        let rotate2 = SKAction.rotate(byAngle: -.pi / 8, duration: randomDuration)
        
        let moveSequence = SKAction.sequence([move1, rotate1, move2, rotate2])
        let repeatAction = SKAction.repeatForever(moveSequence)
        
        numberNode.run(repeatAction)
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
