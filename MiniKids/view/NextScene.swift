import UIKit
import SpriteKit

class NextScene: SKScene {
    
    var buttons: [SKCropNode] = []
    var backButton: UIButton!
    
    override func didMove(to view: SKView) {
        
        
        // Add background
        let background = SKSpriteNode(imageNamed: "h96b_d11e_210608")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
        
        // Add a transparent overlay to dim the background
        let overlay = SKSpriteNode(color: UIColor.white.withAlphaComponent(0.3), size: self.size)
        overlay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        overlay.zPosition = 0
        addChild(overlay)
        
        // Button settings
        let buttonSize = CGSize(width: 150, height: 150)
        let horizontalSpacing: CGFloat = 180
        let verticalSpacing: CGFloat = 200
        let centerX = self.size.width / 2
        let centerY = self.size.height / 2
        
        // Start positions for a 3x2 grid centered on the screen
        let positions = [
            CGPoint(x: centerX - horizontalSpacing, y: centerY + verticalSpacing / 2),  // Top left
            CGPoint(x: centerX, y: centerY + verticalSpacing / 2),                     // Top center
            CGPoint(x: centerX + horizontalSpacing, y: centerY + verticalSpacing / 2), // Top right
            CGPoint(x: centerX - horizontalSpacing, y: centerY - verticalSpacing / 2), // Bottom left
            CGPoint(x: centerX, y: centerY - verticalSpacing / 2),                     // Bottom center
            CGPoint(x: centerX + horizontalSpacing, y: centerY - verticalSpacing / 2)  // Bottom right
        ]
        
        // Button images
        let buttonImages = ["sekillerButton", "number", "hayvanlar", "meyveler", "renkler", "sıralama"]
        
        for (index, imageName) in buttonImages.enumerated() {
            let button = createRoundedButton(imageName: imageName, position: positions[index], size: buttonSize)
            buttons.append(button)
            addSoftPulseAnimation(to: button)
        }
        
        createBackButton()
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
        // NextScene'e geri dön
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
    
    func createRoundedButton(imageName: String, position: CGPoint, size: CGSize) -> SKCropNode {
        // Button image
        let buttonImage = SKSpriteNode(imageNamed: imageName)
        buttonImage.size = size
        
        // Circular mask
        let mask = SKShapeNode(circleOfRadius: size.width / 2)
        mask.fillColor = .white
        
        // Add mask with CropNode
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
        
        // Check which button is touched and present the corresponding scene
        if buttons[0].contains(location) {
            presentScene(ShapesScene(size: self.size))
        } else if buttons[1].contains(location) {
            presentScene(NumberScene(size: self.size))
        } else if buttons[2].contains(location) {
            presentScene(AnimalScene(size: self.size))
        } else if buttons[3].contains(location) {
            presentScene(FruitScene(size: self.size))
        }
    }
    
    // Helper function to present a new scene
    func presentScene(_ scene: SKScene) {
        scene.scaleMode = .aspectFill
        self.view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
    }
}
