import UIKit
import SpriteKit
import AVFoundation

class ShapesScene: SKScene {
    var geriButonu: UIButton!
    var sesEfektleri: [String: SKAction] = [:]
    var dogruSesEfekti: SKAction!
    
    var currentImage: SKSpriteNode?
    var imageNames = ["daireDunya", "kareBiskuvi", "ucgenCetvel", "yildiz1"]
    var imagesNode: SKSpriteNode!
    var initialImagePosition: CGPoint?

    override func didMove(to view: SKView) {
        geriButonuOlustur()
        sesEfektleriniYukle()
        sekilleriSiraIleEkle()
    }

    func geriButonuOlustur() {
        guard let view = self.view else { return }
        
        let arkaPlan = SKSpriteNode(imageNamed: "bulutluBackground")
        arkaPlan.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        arkaPlan.zPosition = -1
        arkaPlan.size = self.size
        addChild(arkaPlan)
        
        let katman = SKSpriteNode(color: UIColor.white.withAlphaComponent(0.9), size: self.size)
        katman.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        katman.zPosition = 0
        addChild(katman)
        
        geriButonu = UIButton(type: .custom)
        geriButonu.setImage(UIImage(named: "backButton"), for: .normal)
        geriButonu.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
        geriButonu.layer.cornerRadius = 25
        geriButonu.clipsToBounds = true
        geriButonu.addTarget(self, action: #selector(geriButonuTiklandi), for: .touchUpInside)
        view.addSubview(geriButonu)
    }

    @objc func geriButonuTiklandi() {
        let sonrakiSahne = NextScene(size: self.size)
        sonrakiSahne.scaleMode = .aspectFill
        self.view?.presentScene(sonrakiSahne, transition: SKTransition.fade(withDuration: 1.0))
        geriButonu.removeFromSuperview()
    }

    func sesEfektleriniYukle() {
        sesEfektleri["kare"] = SKAction.playSoundFileNamed("suDamlasi", waitForCompletion: false)
        sesEfektleri["daire"] = SKAction.playSoundFileNamed("suDamlasi", waitForCompletion: false)
        sesEfektleri["yildiz"] = SKAction.playSoundFileNamed("suDamlasi", waitForCompletion: false)
        sesEfektleri["ucgen"] = SKAction.playSoundFileNamed("suDamlasi", waitForCompletion: false)
        dogruSesEfekti = SKAction.playSoundFileNamed("suDamlasi2", waitForCompletion: false) // Doğru eşleşme sesi
    }

    func sekilleriSiraIleEkle() {
        let sekilBilgileri = [
            (isim: "kare", x: self.size.width * 0.25, y: self.size.height * 0.75),
            (isim: "yildiz", x: self.size.width * 0.75, y: self.size.height * 0.75),
            (isim: "daire", x: self.size.width * 0.25, y: self.size.height * 0.25),
            (isim: "ucgen", x: self.size.width * 0.75, y: self.size.height * 0.25)
        ]
        
        for (index, sekil) in sekilBilgileri.enumerated() {
            let beklemeSuresi = Double(index) * 0.2
            run(SKAction.wait(forDuration: beklemeSuresi)) { [weak self] in
                self?.sekilEkleVeSesCal(sekil.isim, x: sekil.x, y: sekil.y)
            }
        }
        
        let toplamBeklemeSuresi = Double(sekilBilgileri.count) * 0.2
        run(SKAction.wait(forDuration: toplamBeklemeSuresi)) { [weak self] in
            self?.rastgeleResimEkleEfektli()
        }
    }
    
    func sekilEkleVeSesCal(_ isim: String, x: CGFloat, y: CGFloat) {
        let sekilNode = SKSpriteNode(imageNamed: isim)
        sekilNode.position = CGPoint(x: x, y: y)
        sekilNode.zPosition = 1
        sekilNode.name = isim
        addChild(sekilNode)
        
        if let ses = sesEfektleri[isim] {
            sekilNode.run(ses)
        }
    }

    func rastgeleResimEkleEfektli() {
        if imageNames.isEmpty { return }
        
        let randomIndex = Int(arc4random_uniform(UInt32(imageNames.count)))
        let imageName = imageNames.remove(at: randomIndex)
        
        imagesNode = SKSpriteNode(imageNamed: imageName)
        imagesNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        imagesNode.zPosition = 2
        imagesNode.alpha = 0
        imagesNode.name = imageName
        addChild(imagesNode)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 1.0)
        imagesNode.run(fadeInAction)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if let node = atPoint(location) as? SKSpriteNode {
                if node == imagesNode {
                    currentImage = node
                    initialImagePosition = node.position // Başlangıç konumunu kaydet
                }
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let imageNode = currentImage {
            let location = touch.location(in: self)
            imageNode.position = location
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let imageNode = currentImage {
            let location = touch.location(in: self)
            checkForMatch(at: location, imageNode: imageNode)
        }
        currentImage = nil
    }
    
    func checkForMatch(at location: CGPoint, imageNode: SKSpriteNode) {
        let shapes = children.filter { $0 is SKSpriteNode && $0.zPosition == 1 }
        var matched = false

        for shape in shapes {
            if shape.contains(location) {
                let shapeName = shape.name ?? ""
                if isMatching(shapeName: shapeName, imageName: imageNode.name) {
                    print("Eşleşti!")
                    shape.removeFromParent()
                    imageNode.removeFromParent()
                    run(dogruSesEfekti) // Doğru eşleşme sesini çal
                    rastgeleResimEkleEfektli()
                    matched = true
                    break
                }
            }
        }

        if !matched {
            let shakeAction = SKAction.sequence([
                SKAction.moveBy(x: -10, y: 0, duration: 0.1),
                SKAction.moveBy(x: 20, y: 0, duration: 0.1),
                SKAction.moveBy(x: -20, y: 0, duration: 0.1),
                SKAction.moveBy(x: 20, y: 0, duration: 0.1),
                SKAction.moveBy(x: -10, y: 0, duration: 0.1),
                SKAction.move(to: initialImagePosition ?? CGPoint.zero, duration: 0.2) // Eski konuma dön
            ])
            imageNode.run(shakeAction) // Yanlış eşleşme sallama ve geri dönme hareketi
            print("Yanlış eşleşme!")
        }
    }
    
    func isMatching(shapeName: String, imageName: String?) -> Bool {
        guard let imageName = imageName else { return false }
        switch shapeName {
        case "daire":
            return imageName == "daireDunya"
        case "kare":
            return imageName == "kareBiskuvi"
        case "ucgen":
            return imageName == "ucgenCetvel"
        case "yildiz":
            return imageName == "yildiz1"
        default:
            return false
        }
    }

    override func willMove(from view: SKView) {
        geriButonu.removeFromSuperview()
    }
}
