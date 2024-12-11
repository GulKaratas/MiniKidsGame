//
//  ColorScene.swift
//  MiniKids
//
//  Created by Gül Karataş on 11.12.2024.
//


import UIKit
import SpriteKit

class ColorScene: SKScene {
    
    var backButton: UIButton!
    var draggedItem: SKSpriteNode?
    var itemStartPositions: [String: CGPoint] = [:]
    var itemStartingPositions: [String: CGPoint] = [:]

    
    override func didMove(to view: SKView) {
        // Arka planı ayarla
        let background = SKSpriteNode(imageNamed: "colorBckground")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -2
        background.size = self.size
        addChild(background)
        
        // Çamaşır ipini oluştur
        createClothesline()
        
        // Sepetleri ekle
        addBaskets()
        createBackButton()
    }
    func addBasketsSequentially() {
        let basketNames = ["pembeSepet", "yeşilSepet", "maviSepet"]
        let basketSize = CGSize(width: 200, height: 140)
        
        let startX = size.width * 0.25
        let spacing = size.width * 0.25
        let yPosition = size.height * 0.27
        
        var delay: TimeInterval = 0
        for (index, name) in basketNames.enumerated() {
            let basket = SKSpriteNode(imageNamed: name)
            basket.size = basketSize
            basket.position = CGPoint(x: startX + CGFloat(index) * spacing, y: yPosition)
            basket.zPosition = 3
            basket.name = name // Sepetin adı
            
            let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
            let soundAction = SKAction.playSoundFileNamed("suDamlasi.mp3", waitForCompletion: false)
            let sequence = SKAction.sequence([SKAction.wait(forDuration: delay), soundAction, fadeInAction])
            basket.run(sequence)
            
            addChild(basket)
            
            delay += 0.5 // Increase delay for next basket
        }
    }

    func createClothesline() {
        // Düz bir yol oluştur
        let path = UIBezierPath()
        let startPoint = CGPoint(x: size.width * 0.1, y: size.height * 0.8) // Sol uç
        let endPoint = CGPoint(x: size.width * 0.9, y: size.height * 0.8)   // Sağ uç
        
        // Yolun başlangıç noktasına ve bitiş noktasına bir çizgi ekleyin
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        // Çamaşır ipini göstermek için bir SKShapeNode oluştur
        let clothesline = SKShapeNode(path: path.cgPath)
        clothesline.strokeColor = .brown // İp rengi
        clothesline.lineWidth = 4
        clothesline.zPosition = 1
        addChild(clothesline)
        
        // Çamaşır askılarını ip boyunca yerleştir
        addClothesHangers(path: path)
    }

    func addClothesHangers(path: UIBezierPath) {
        let numberOfHangers = 6 // Number of hangers
        let totalSpacing = 1.0 // Total spacing along the path (0.0 - 1.0)
        let spacing = totalSpacing / CGFloat(numberOfHangers + 1)
        let offset = spacing / 1.2

        let clothesImages = ["maviŞort", "pembeSweet", "yeşilAtkı"]
        var imageIndex = 0

        for i in 1...numberOfHangers {
            let t = offset + CGFloat(i - 1) * spacing // Calculate position based on the spacing and offset
            let point = pointOnBezierPath(path: path, t: t)
            
            // Askıyı yerleştir
            let hanger = SKSpriteNode(imageNamed: "askı")
            hanger.size = CGSize(width: 20, height: 40)
            hanger.position = point
            hanger.zPosition = 3
            addChild(hanger)
            
            // Her iki askıya kıyafet ekle
            if i % 2 == 0 {
                let itemImage = clothesImages[imageIndex]
                let item = SKSpriteNode(imageNamed: itemImage)
                
                item.name = itemImage // Sepet ile eşleşecek olan isim
                
                // Konumu belirle
                if itemImage == "pembeSweet" {
                    item.size = CGSize(width: 300, height: 200)
                    item.position = CGPoint(x: point.x - 110, y: point.y - 70) // Konumu daha sola kaydır
                } else {
                    item.size = CGSize(width: 200, height: 150)
                    item.position = CGPoint(x: point.x - 80, y: point.y - 60)
                }
                
                item.zPosition = 2
                
                // Başlangıç pozisyonu kaydedildi
                itemStartPositions[itemImage] = item.position
                
                addChild(item)
                
                imageIndex = (imageIndex + 1) % clothesImages.count
            }
        }
    }

    func pointOnBezierPath(path: UIBezierPath, t: CGFloat) -> CGPoint {
        guard let pathElements = path.cgPath.copyPathElementsPoints(), pathElements.count == 2 else {
            return .zero
        }
        
        let start = pathElements[0]
        let end = pathElements[1]
        
        // Lineer interpolasyon ile nokta hesaplama
        let x = (1 - t) * start.x + t * end.x
        let y = (1 - t) * start.y + t * end.y
        return CGPoint(x: x, y: y)
    }

    func addBaskets() {
        let basketNames = ["pembeSepet", "yeşilSepet", "maviSepet"]
        let basketSize = CGSize(width: 200, height: 140)
        
        let startX = size.width * 0.25
        let spacing = size.width * 0.25
        let yPosition = size.height * 0.27
        
        for (index, name) in basketNames.enumerated() {
            let basket = SKSpriteNode(imageNamed: name)
            basket.size = basketSize
            basket.position = CGPoint(x: startX + CGFloat(index) * spacing, y: yPosition)
            basket.zPosition = 3
            basket.name = name // Sepetin adı
            addChild(basket)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        // Kıyafetin üzerine tıklanıp tıklanmadığını kontrol et
        for node in self.children {
            if let item = node as? SKSpriteNode, item.contains(touchLocation), item.zPosition > 0 {
                // Askıları ve sepetleri sürüklemeyi engellemek için
                if item.name != "pembeSepet" && item.name != "maviSepet" && item.name != "yeşilSepet" && item.name != "askı" {
                    draggedItem = item
                    
                    // İlgili kıyafetin ismine göre ses çal
                    if item.name == "pembeSweet" {
                        playSound(named: "pink.mp3")
                    } else if item.name == "maviŞort" {
                        playSound(named: "blue.mp3")
                    } else if item.name == "yeşilAtkı" {
                        playSound(named: "green.mp3")
                    }
                    
                    break
                }
            }
        }
    }



    func playSound(named soundName: String) {
        // Check if the sound file exists and play it
        run(SKAction.playSoundFileNamed(soundName, waitForCompletion: false))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let item = draggedItem else { return }
        let touchLocation = touch.location(in: self)
        
        // Yalnızca kıyafet (draggedItem) hareket ettirilsin
        if item.name != "pembeSepet" && item.name != "maviSepet" && item.name != "yeşilSepet" && item.name != "askı" {
            item.position = touchLocation
        }
    }



    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let item = draggedItem else { return }
        
        let dropLocation = item.position
        var itemDroppedInCorrectBasket = false
        
        // Sepetlerle kıyafetin eşleşip eşleşmediğini kontrol et
        for node in self.children {
            if let basket = node as? SKSpriteNode, basket.contains(dropLocation) {
                if basket.name == "pembeSepet" && item.name == "pembeSweet" {
                    snapItemToBasket(item, basket: basket)
                    itemDroppedInCorrectBasket = true
                    break
                } else if basket.name == "maviSepet" && item.name == "maviŞort" {
                    snapItemToBasket(item, basket: basket)
                    itemDroppedInCorrectBasket = true
                    break
                } else if basket.name == "yeşilSepet" && item.name == "yeşilAtkı" {
                    snapItemToBasket(item, basket: basket)
                    itemDroppedInCorrectBasket = true
                    break
                }
            }
        }
        
        if !itemDroppedInCorrectBasket {
            // Yanlış sepete bırakıldıysa sallanma ve geri dönme işlemleri
            shakeItem(item)
            returnItemToStartPosition(item)
        }
        
        draggedItem = nil
    }


    // Kıyafeti doğru sepete yerleştir
    func snapItemToBasket(_ item: SKSpriteNode, basket: SKSpriteNode) {
        // Kıyafetin doğru sepete yerleştirildiğinde sesi çal
        if item.name == "pembeSweet" {
            playSound(named: "pink.mp3")
        } else if item.name == "maviŞort" {
            playSound(named: "blue.mp3")
        } else if item.name == "yeşilAtkı" {
            playSound(named: "green.mp3")
        }
        
        // Kıyafeti sepetin pozisyonuna taşı
        item.position = basket.position
        
        // Ekrandan kaybolma animasyonu
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOutAction, removeAction])
        
        // Kıyafet ve sepet için animasyonu çalıştır
        item.run(sequence)
        basket.run(sequence)
    }



    // Sallama animasyonu
    func shakeItem(_ item: SKSpriteNode) {
        let shakeAction = SKAction.sequence([
            SKAction.moveBy(x: -10, y: 0, duration: 0.1), // Sol hareket
            SKAction.moveBy(x: 20, y: 0, duration: 0.1), // Sağ hareket
            SKAction.moveBy(x: -10, y: 0, duration: 0.1)  // Sol hareket
        ])
        item.run(shakeAction)
    }

    // Kıyafeti başlangıç pozisyonuna geri gönder
    func returnItemToStartPosition(_ item: SKSpriteNode) {
        guard let startPosition = itemStartPositions[item.name ?? ""] else {
            return
        }
        
        let moveBackAction = SKAction.move(to: startPosition, duration: 0.2)
        item.run(SKAction.sequence([shakeItemAction(), moveBackAction]))
    }


    // Sallama animasyonu, hareketi biraz yavaşlatabiliriz
    func shakeItemAction() -> SKAction {
        return SKAction.sequence([
            SKAction.moveBy(x: -15, y: 0, duration: 0.1), // Sol hareket
            SKAction.moveBy(x: 30, y: 0, duration: 0.1), // Sağ hareket
            SKAction.moveBy(x: -15, y: 0, duration: 0.1)  // Sol hareket
        ])
    }


    func createBackButton() {
        guard let view = self.view else { return }
        
        // Buton oluştur
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
        
        // Geçiş yapıldığında butonu görünümden kaldır
        backButton.removeFromSuperview()
    }


    override func willMove(from view: SKView) {
        // Scene'den çıkarken butonun kaldırıldığından emin olun
        backButton.removeFromSuperview()
    }
}

extension CGPath {
    func copyPathElementsPoints() -> [CGPoint]? {
        var points: [CGPoint] = []
        
        self.applyWithBlock { element in
            let pathElement = element.pointee
            switch pathElement.type {
            case .moveToPoint, .addLineToPoint:
                points.append(pathElement.points[0])
            case .addQuadCurveToPoint:
                points.append(pathElement.points[0]) // Control point
                points.append(pathElement.points[1]) // End point
            case .addCurveToPoint:
                points.append(pathElement.points[0]) // First control point
                points.append(pathElement.points[1]) // Second control point
                points.append(pathElement.points[2]) // End point
            case .closeSubpath:
                break
            @unknown default:
                break
            }
        }
        return points
    }
}
