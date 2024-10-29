import UIKit
import SpriteKit

class NextScene: SKScene {
    
    var button1: SKCropNode!
    var button2: SKCropNode!
    var button3: SKCropNode!
    var button4: SKCropNode!
    
    override func didMove(to view: SKView) {
        
        // Arka plan ekleme
        let background = SKSpriteNode(imageNamed: "h96b_d11e_210608")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
        
        // Arka planın canlılığını azaltmak için saydam kaplama ekleme
        let overlay = SKSpriteNode(color: UIColor.white.withAlphaComponent(0.3), size: self.size)
        overlay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        overlay.zPosition = 0
        addChild(overlay)
        
        // Buton ayarları
        let buttonSize = CGSize(width: 150, height: 150)
        let spacing: CGFloat = 170
        let startX = (self.size.width / 2) - (spacing * 1.5)
        let yPosition = self.size.height / 2
        
        button1 = createRoundedButton(imageName: "sekiller", position: CGPoint(x: startX, y: yPosition), size: buttonSize)
        button2 = createRoundedButton(imageName: "number", position: CGPoint(x: startX + spacing, y: yPosition), size: buttonSize)
        button3 = createRoundedButton(imageName: "hayvanlar", position: CGPoint(x: startX + (2 * spacing), y: yPosition), size: buttonSize)
        button4 = createRoundedButton(imageName: "meyveler", position: CGPoint(x: startX + (3 * spacing), y: yPosition), size: buttonSize)
        
        // Daha hafif animasyon ekleme
        addSoftPulseAnimation(to: button1)
        addSoftPulseAnimation(to: button2)
        addSoftPulseAnimation(to: button3)
        addSoftPulseAnimation(to: button4)
    }
    
    func createRoundedButton(imageName: String, position: CGPoint, size: CGSize) -> SKCropNode {
        // Butonun görseli
        let buttonImage = SKSpriteNode(imageNamed: imageName)
        buttonImage.size = size
        
        // Çember şeklinde bir maske oluşturma
        let mask = SKShapeNode(circleOfRadius: size.width / 2)
        mask.fillColor = .white
        
        // CropNode ile maske ekleme
        let cropNode = SKCropNode()
        cropNode.maskNode = mask
        cropNode.addChild(buttonImage)
        cropNode.position = position
        cropNode.zPosition = 1
        addChild(cropNode)
        
        return cropNode
    }
    
    func addSoftPulseAnimation(to button: SKCropNode) {
        let scaleUp = SKAction.scale(to: 1.07, duration: 1.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 1.2)
        let pulse = SKAction.sequence([scaleUp, scaleDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        button.run(repeatPulse)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if button1.contains(location) {
            print("Button 1 clicked")
        } else if button2.contains(location) {
            print("Button 2 clicked")
        } else if button3.contains(location) {
            print("Button 3 clicked")
        } else if button4.contains(location) {
            print("Button 4 clicked")
        }
    }
}
