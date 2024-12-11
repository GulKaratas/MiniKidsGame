//
//  IllustrationScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 20.11.2024.
//
//
//  IllustrationScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 20.11.2024.
//

import UIKit
import SpriteKit

class IllustrationScene: SKScene {
    
    var backButton: UIButton!
    private var selectedColor: UIColor = .white // Varsayılan renk
    private var drawingPath: CGMutablePath? // Çizim için path
    private var currentDrawingNode: SKShapeNode? // Çizim yapılan node
    private var isUsingSunger = false
    private var initialSungerPosition: CGPoint? // Süngerin başlangıç pozisyonu
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupItems()
        setupDefaultColor()
        createBackButton()
    }
    
    private func setupDefaultColor() {
        selectedColor = .white
        updateTebesirYeri(with: "beyaz")
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "Vector")
        let screenAspectRatio = self.size.width / self.size.height
        let imageAspectRatio = background.texture!.size().width / background.texture!.size().height
        
        // Boyut küçültme çarpanı
        let scaleFactor: CGFloat = 0.9
        
        if screenAspectRatio > imageAspectRatio {
            background.size.height = self.size.height * scaleFactor
            background.size.width = (self.size.height * imageAspectRatio) * scaleFactor
        } else {
            background.size.width = self.size.width * scaleFactor
            background.size.height = (self.size.width / imageAspectRatio) * scaleFactor
        }
        
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        background.name = "background" // Dokunma kontrolü için isim ekle
        addChild(background)
    }


    private func setupItems() {
        let colors = ["turuncu", "mavi", "koyuMavi", "kırmızı", "beyaz", "sari", "pembe", "mor"]
        let startX = self.size.width * 0.1
        let spacing = self.size.width * 0.09
        let chalkSize = CGSize(width: self.size.width * 0.08, height: self.size.height * 0.04)
        
        for (index, colorName) in colors.enumerated() {
            let chalk = SKSpriteNode(imageNamed: colorName)
            chalk.size = chalkSize
            chalk.position = CGPoint(x: startX + CGFloat(index) * spacing, y: self.size.height * 0.143)
            chalk.name = colorName
            chalk.zPosition = 1
            addChild(chalk)
        }
        
        let sünger = SKSpriteNode(imageNamed: "sunger")
        sünger.size = CGSize(width: self.size.width * 0.1, height: self.size.height * 0.09)
        sünger.position = CGPoint(x: self.size.width * 0.9, y: self.size.height * 0.150)
        sünger.name = "sunger"
        sünger.zPosition = 1
        addChild(sünger)
        
        // Süngerin başlangıç pozisyonunu kaydet
        initialSungerPosition = sünger.position
    }
    
    private func updateTebesirYeri(with colorName: String) {
        // Eski "tebeşirYeri" node'unu kaldır
        if let currentTebesir = childNode(withName: "tebesirYeri") {
            currentTebesir.removeFromParent()
        }
        
        // Yeni "tebeşirYeri" node'unu oluştur
        let tebesirYeri = SKSpriteNode(imageNamed: colorName)
        tebesirYeri.size = CGSize(width: self.size.width * 0.1, height: self.size.height * 0.05)
        tebesirYeri.position = CGPoint(x: self.size.width * 0.12, y: self.size.height * 0.85)
        tebesirYeri.name = "tebesirYeri"
        tebesirYeri.zPosition = 1
        addChild(tebesirYeri)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)

        // Eğer süngere dokunulmuşsa
        if touchedNode.name == "sunger" {
            isUsingSunger = true
        } else if let colorName = touchedNode.name, colorName != "drawing" && colorName != "background" {
            // Yeni renk seçildiğinde
            selectedColor = color(from: colorName)
            updateTebesirYeri(with: colorName)
        } else {
            // Yeni bir çizim yolu başlat
            if drawingPath == nil {
                drawingPath = CGMutablePath()
                drawingPath?.move(to: location)

                let newDrawingNode = SKShapeNode()
                newDrawingNode.path = drawingPath
                newDrawingNode.strokeColor = selectedColor
                newDrawingNode.lineWidth = 5.0
                newDrawingNode.zPosition = 0
                newDrawingNode.name = "drawing"
                addChild(newDrawingNode)
                currentDrawingNode = newDrawingNode
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if isUsingSunger {
            if let sungerNode = childNode(withName: "sunger") {
                sungerNode.position = location

                // Süngerle silme işlemi
                for node in children {
                    if let shapeNode = node as? SKShapeNode,
                       shapeNode.name == "drawing",
                       shapeNode.contains(location) {
                        shapeNode.removeFromParent()
                    }
                }
            }
        } else {
            guard let path = drawingPath else { return }
            path.addLine(to: location)
            currentDrawingNode?.path = path
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isUsingSunger {
            isUsingSunger = false

            // Süngeri başlangıç pozisyonuna geri döndür
            if let sungerNode = childNode(withName: "sunger"),
               let initialPosition = initialSungerPosition {
                let moveAction = SKAction.move(to: initialPosition, duration: 0.3)
                sungerNode.run(moveAction)
            }
        } else {
            drawingPath = nil
            currentDrawingNode = nil
        }
    }

    private func color(from name: String) -> UIColor {
        switch name {
        case "turuncu": return .orange
        case "mavi": return .blue
        case "koyuMavi": return UIColor(red: 0, green: 0, blue: 0.5, alpha: 1)
        case "kırmızı": return .red
        case "beyaz": return .white
        case "sari": return .yellow
        case "pembe": return .systemPink
        case "mor": return .purple
        default: return .black
        }
    }
    func createBackButton() {
        guard let view = self.view else { return }
        
        // Butonu başlat
        backButton = UIButton(type: .custom)
        
        // Buton görselini ayarla
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        
        // Buton boyutunu ayarla ve yuvarlak yap
        backButton.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
        backButton.layer.cornerRadius = 25
        backButton.clipsToBounds = true
        
        // Butona tıklama işlevi ekle
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Butonu görünüme ekle
        view.addSubview(backButton)
    }

    @objc func backButtonTapped() {
        let nextScene = NextScene(size: self.size)
        nextScene.scaleMode = .aspectFill
        self.view?.presentScene(nextScene, transition: SKTransition.fade(withDuration: 1.0))
        
        // Geçiş yapıldığında butonu görünümden kaldır
        backButton.removeFromSuperview()
    }

    override func willMove(from view: SKView) {
        // Scene'den çıkarken butonun kaldırıldığından emin olun
        backButton.removeFromSuperview()
    }
}
