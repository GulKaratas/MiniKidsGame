//
//  IllustrationScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 20.11.2024.
//

import UIKit
import SpriteKit

class IllustrationScene: SKScene {
    
    private var selectedColor: UIColor = .white // Varsayılan renk
    private var drawingPath: CGMutablePath? // Çizim için path
    private var currentDrawingNode: SKShapeNode? // Çizim yapılan node
    private var isUsingSunger = false
    private var initialSungerPosition: CGPoint? // Süngerin başlangıç pozisyonu
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupItems()
        setupDefaultColor()
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

        // Çizilen çizgilerin üzerine tıklamayı engelle
        if touchedNode is SKShapeNode && touchedNode.name == "drawing" {
            return
        }

        if touchedNode.name == "sunger" {
            isUsingSunger = true
        } else if let colorName = touchedNode.name {
            // Yeni renk seçildiğinde eski çizim yolunu sıfırla
            selectedColor = color(from: colorName)
            updateTebesirYeri(with: colorName)  // Yeni tebeşir rengini güncelle

            // Eski çizim yolunu sıfırlama
            drawingPath = nil
            currentDrawingNode?.removeFromParent() // Eski çizim node'unu kaldır
            currentDrawingNode = nil

            // Yeni çizim node'u başlat
            drawingPath = CGMutablePath()
            let newDrawingNode = SKShapeNode()
            newDrawingNode.path = drawingPath
            newDrawingNode.strokeColor = selectedColor // Yeni seçilen rengi ata
            newDrawingNode.lineWidth = 5.0
            newDrawingNode.zPosition = 0
            newDrawingNode.name = "drawing" // Çizim düğümüne isim veriyoruz
            addChild(newDrawingNode)
            currentDrawingNode = newDrawingNode
        } else {
            // Yeni bir çizim yolu başlat
            drawingPath = CGMutablePath()
            drawingPath?.move(to: location)

            let newDrawingNode = SKShapeNode()
            newDrawingNode.path = drawingPath
            newDrawingNode.strokeColor = selectedColor // Çizim rengi doğru şekilde atanacak
            newDrawingNode.lineWidth = 5.0
            newDrawingNode.zPosition = 0
            newDrawingNode.name = "drawing" // Çizim düğümüne isim veriyoruz
            addChild(newDrawingNode)
            currentDrawingNode = newDrawingNode
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
                        shapeNode.removeFromParent() // Çizimi sil
                    }
                }
            }
        } else if let path = drawingPath {
            path.addLine(to: location)
            currentDrawingNode?.path = path
            currentDrawingNode?.strokeColor = selectedColor // Çizim rengi her hareketle güncellenir
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isUsingSunger {
            isUsingSunger = false

            // Süngeri başlangıç pozisyonuna geri döndür
            if let sungerNode = childNode(withName: "sunger"),
               let initialPosition = initialSungerPosition {
                let moveAction = SKAction.move(to: initialPosition, duration: 0.3)
                sungerNode.run(moveAction) { [weak self] in
                    // Sünger yerine döndükten sonra hızlıca eski renkle devam
                    self?.prepareForNewDrawing()
                }
            }
        } else {
            // Çizim yolunu bitir
            drawingPath = nil
            currentDrawingNode = nil
        }
    }

    // Yeni çizim hazırlığı
    private func prepareForNewDrawing() {
        drawingPath = CGMutablePath()
        let newDrawingNode = SKShapeNode()
        newDrawingNode.path = drawingPath
        newDrawingNode.strokeColor = selectedColor // Son kullanılan renk
        newDrawingNode.lineWidth = 5.0
        newDrawingNode.zPosition = 0
        newDrawingNode.name = "drawing"
        addChild(newDrawingNode)
        currentDrawingNode = newDrawingNode
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
}
