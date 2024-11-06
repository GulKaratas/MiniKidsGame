import SpriteKit
import GameplayKit
import Lottie

class GameScene: SKScene {
    
    var animationTiger: LottieAnimationView!
    var animationFlyBalloon: LottieAnimationView!
    
    override func didMove(to view: SKView) {
        guard let skView = self.view else { return }
        
        // Setup Tiger Animation
        setupTigerAnimation(in: skView)
        
        // Setup Balloon Animation
        setupBalloonAnimation(in: skView)
        
        // Setup Play Button
        setupPlayButton(in: skView)
            

    }
    
    private func setupTigerAnimation(in skView: SKView) {
        animationTiger = LottieAnimationView(name: "AnimationTiger")
        animationTiger.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationTiger.center = CGPoint(x: skView.bounds.midX - 120, y: skView.bounds.midY + 50)
        animationTiger.loopMode = .loop
        
        animationTiger.play()
        skView.addSubview(animationTiger)
    }
    
    private func setupBalloonAnimation(in skView: SKView) {
        animationFlyBalloon = LottieAnimationView(name: "AnimationFlyBallonn")
        animationFlyBalloon.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        animationFlyBalloon.center = CGPoint(x: skView.bounds.midX + 120, y: skView.bounds.midY + 50)
        animationFlyBalloon.loopMode = .loop
        animationFlyBalloon.play()
        skView.addSubview(animationFlyBalloon)
    }
    
    private func setupPlayButton(in skView: SKView) {
        let playButton = UIButton(type: .system)
        playButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        playButton.center = CGPoint(x: animationFlyBalloon.center.x, y: animationFlyBalloon.center.y - 60)
        playButton.backgroundColor = .clear
        playButton.setTitle("\u{25B6}", for: .normal)
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 70)
        playButton.setTitleColor(.white, for: .normal)
        
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        skView.addSubview(playButton)
    }
    
    @objc private func playButtonTapped() {
        // Stop the animations
               animationTiger.stop()
               animationFlyBalloon.stop()
               
               // Remove animations and button from the superview
               animationTiger.removeFromSuperview()
               animationFlyBalloon.removeFromSuperview()
               
               // Remove the play button
               if let button = self.view?.subviews.first(where: { $0 is UIButton }) {
                   button.removeFromSuperview()
               }
               
               // Transition to the NextScene
               let nextScene = NextScene(size: self.size)
               let transition = SKTransition.flipHorizontal(withDuration: 0.5)
               self.view?.presentScene(nextScene, transition: transition)
    }
    
    // Touch methods can be left empty or removed if not needed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {for touch in touches {
        let touchLocation = touch.location(in: self)
        GlowEffectManager.createGlowEffect(at: touchLocation, in: self)
    }}
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { for touch in touches {
        let touchLocation = touch.location(in: self)
        GlowEffectManager.createGlowEffect(at: touchLocation, in: self)
    }}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func update(_ currentTime: TimeInterval) {}
}
