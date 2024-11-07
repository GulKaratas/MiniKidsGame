import UIKit
import SpriteKit
import AVFoundation
import Lottie
import GameplayKit

class ShapesScene: SKScene {
    var geriButonu: UIButton!
    var sesEfektleri: [String: SKAction] = [:]
    var dogruSesEfekti: SKAction!
    
    var currentImage: SKSpriteNode?
    var imageNames: [[String]] = [
        ["daireDunya", "kareBiskuvi", "ucgenCetvel", "yildiz1"],
        ["daireKurabiye", "kareCerceve", "ucgenKarpuz", "yildizCicek"],
        ["daireMeyve", "kareCikolata", "ucgenLed", "yildizDeniz"],
        ["daireSaat", "kareKutu", "ucgenLevha", "yildizKurabiye"],
        ["daireFootball","kareTablo","ucgenPizza","yildizSet"]
    ]
    var currentCycle = 0
    var imagesNode: SKSpriteNode!
    var initialImagePosition: CGPoint?
    var matchedShapesCount = 0
    var animationView: LottieAnimationView?
    
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
        
        let katman = SKSpriteNode(color: UIColor.white.withAlphaComponent(0.2), size: self.size)
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
        dogruSesEfekti = SKAction.playSoundFileNamed("suDamlasi2", waitForCompletion: false)
    }

    func sekilleriSiraIleEkle() {
           matchedShapesCount = 0
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
        if imageNames[currentCycle].isEmpty { return }

        // GameplayKit random number generator
        let randomSource = GKRandomSource.sharedRandom()
        let randomIndex = randomSource.nextInt(upperBound: imageNames[currentCycle].count)
        let imageName = imageNames[currentCycle].remove(at: randomIndex)

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
            
            // Safely check if imagesNode is non-nil before accessing it
            if let imagesNode = imagesNode, imagesNode.contains(location) {
                // Only set currentImage if imagesNode contains the touch location
                currentImage = imagesNode
                initialImagePosition = imagesNode.position
            }
        }
    }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let imageNode = currentImage {
            let location = touch.location(in: self)
            // Dokunulan konumu takip etmek için imagesNode'u hareket ettiriyoruz
            imageNode.position = location
            
            GlowEffectManager.createGlowEffect(at: location, in: self)
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
                    print("Matched!")
                    shape.removeFromParent()
                    imageNode.removeFromParent()
                    matchedShapesCount += 1
                    run(dogruSesEfekti)
                    
                    if matchedShapesCount == 4 {
                        startNextCycle()
                    } else {
                        rastgeleResimEkleEfektli()
                    }
                    matched = true
                    break
                }
            }
        }

        if !matched {
            // Shake animation for incorrect match
            let shakeAction = SKAction.sequence([
                SKAction.moveBy(x: -10, y: 0, duration: 0.05),
                SKAction.moveBy(x: 20, y: 0, duration: 0.05),
                SKAction.moveBy(x: -20, y: 0, duration: 0.05),
                SKAction.moveBy(x: 20, y: 0, duration: 0.05),
                SKAction.moveBy(x: -10, y: 0, duration: 0.05),
                SKAction.run { imageNode.position = self.initialImagePosition ?? CGPoint(x: self.size.width / 2, y: self.size.height / 2) }
            ])
            imageNode.run(shakeAction)
        }
    }


    func startNextCycle() {
           currentCycle += 1
           
           if currentCycle >= imageNames.count {
               showLottieAnimation()
           } else {
               imageNames[currentCycle] = imageNames[currentCycle] // Assign new cycle images
               
               matchedShapesCount = 0
               run(SKAction.wait(forDuration: 0.5)) { [weak self] in
                   self?.sekilleriSiraIleEkle()
               }
               
           }
       }
    func showLottieAnimation() {
        animationView = LottieAnimationView(name: "AnimationYildiz")
        guard let animationView = animationView, let view = self.view else { return }

        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop // Set to loop continuously
        animationView.center = view.center
        
        view.addSubview(animationView)

        // Ensure back button is always visible and interactive
        geriButonu.isHidden = false
        geriButonu.isUserInteractionEnabled = true
        view.bringSubviewToFront(geriButonu)

        // Play animation
        animationView.play()
    }


       func resetGame() {
           currentCycle = 0
           matchedShapesCount = 0
           imageNames = [
               ["daireDunya", "kareBiskuvi", "ucgenCetvel", "yildiz1"],
               ["daireKurabiye", "kareCerceve", "ucgenKarpuz", "yildizCicek"],
               ["daireMeyve", "kareCikolata", "ucgenLed", "yildizDeniz"],
               ["daireSaat", "kareKutu", "ucgenLevha", "yildizKurabiye"],
               ["daireFootball", "kareTablo", "ucgenPizza", "yildizSet"]
           ]
           sekilleriSiraIleEkle()
       }


       func isMatching(shapeName: String, imageName: String?) -> Bool {
           guard let imageName = imageName else { return false }
           switch shapeName {
           case "daire":
               return imageName.contains("daire")
           case "kare":
               return imageName.contains("kare")
           case "ucgen":
               return imageName.contains("ucgen")
           case "yildiz":
               return imageName.contains("yildiz")
           default:
               return false
           }
       }
   
    override func willMove(from view: SKView) {
        geriButonu.removeFromSuperview()
        animationView?.removeFromSuperview()
    }
}
