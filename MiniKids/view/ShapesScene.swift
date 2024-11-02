import UIKit
import SpriteKit
import AVFoundation

class ShapesScene: SKScene {

    var geriButonu: UIButton!
    var sesEfektleri: [String: SKAction] = [:]
    var daireDunya: SKSpriteNode!
    var seciliSekil: SKSpriteNode?
    var isDaireDunyaMatched = false // Flag to check if the match has occurred

    override func didMove(to view: SKView) {
        geriButonuOlustur()
        sesEfektleriniYukle()
        sekilleriSiraIleEkleVeOrtadakiResmiEfektleEkle()
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
    }

    func sekilleriSiraIleEkleVeOrtadakiResmiEfektleEkle() {
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
        
        let toplamBeklemeSuresi = Double(sekilBilgileri.count) * 0.2 + 0.5
        run(SKAction.wait(forDuration: toplamBeklemeSuresi)) { [weak self] in
            self?.ortadakiResmiEfektleEkle()
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
    
    func ortadakiResmiEfektleEkle() {
        daireDunya = SKSpriteNode(imageNamed: "daireDunya")
        daireDunya.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        daireDunya.zPosition = 2
        daireDunya.alpha = 0
        daireDunya.setScale(0.5)
        daireDunya.name = "daireDunya"
        addChild(daireDunya)
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.5)
        let efekt = SKAction.group([fadeIn, scaleUp])
        
        daireDunya.run(efekt)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if daireDunya.contains(location) && !isDaireDunyaMatched { // Check if daireDunya is matched
                seciliSekil = daireDunya
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let sekil = seciliSekil, !isDaireDunyaMatched { // Restrict movement if matched
            let location = touch.location(in: self)
            sekil.position = location
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sekil = seciliSekil else { return }
        
        if let daireSekil = childNode(withName: "daire"), daireSekil.contains(sekil.position) {
            // Snap daireDunya to the center of daire
            daireDunya.position = CGPoint(x: daireSekil.position.x, y: daireSekil.position.y)
            daireDunya.texture = sekil.texture
            
            let dogruSes = SKAction.playSoundFileNamed("suDamlasi3", waitForCompletion: false)
            sekil.run(dogruSes)
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.3)
            let scaleDown = SKAction.scale(to: 0.5, duration: 0.3)
            let group = SKAction.group([fadeOut, scaleDown])
            
            daireDunya.run(group) { [weak self] in
                self?.daireDunya.alpha = 0
                self?.daireDunya.setScale(1.0)
                self?.daireDunya.alpha = 1
            }
            isDaireDunyaMatched = true // Set matched flag
        } else {
            let shakeAction = SKAction.sequence([
                SKAction.moveBy(x: -10, y: 0, duration: 0.1),
                SKAction.moveBy(x: 10, y: 0, duration: 0.1),
                SKAction.moveBy(x: -10, y: 0, duration: 0.1),
                SKAction.moveBy(x: 10, y: 0, duration: 0.1)
            ])
            
            let geriDonus = SKAction.move(to: CGPoint(x: self.size.width / 2, y: self.size.height / 2), duration: 0.3)
            let combinedAction = SKAction.sequence([shakeAction, geriDonus])
            daireDunya.run(combinedAction)
        }
        
        seciliSekil = nil // Clear selection
    }

    override func willMove(from view: SKView) {
        geriButonu.removeFromSuperview()
    }
}
