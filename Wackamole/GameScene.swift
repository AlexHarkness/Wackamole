import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var inGame = false
    var score = 0
    var highScore = 0
    var mole = SKSpriteNode()
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    var playButton: SKLabelNode!
    
    override func didMove(to view: SKView) {
        scoreLabel = SKLabelNode()
        playButton = SKLabelNode()
        scoreLabel.position = CGPoint(x: size.width * 0.5, y: size.height - 35)
        playButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        scoreLabel.fontSize *= 1.25
        playButton.fontSize *= 1.25
        addChild(scoreLabel)
        addChild(playButton) 
        playButton.text = "TOUCH TO PLAY"
    }
    
    func startGame(){
        inGame = true
        self.backgroundColor = UIColor.green
        playButton.run(SKAction.fadeOut(withDuration: 0.3))
        game()
    }
    
    func game(){
        if score > highScore{
            highScore=score
        }
        scoreLabel.text = "score: \(score)" + "    max: \(highScore)"
        run(SKAction.sequence([SKAction.run(spawnMole),SKAction.wait(forDuration: 0.5 - (0.005 * Double(score))), SKAction.run(game)
                ]))
    }
    func spawnMole(){
        mole = SKSpriteNode(imageNamed: "mole")
        mole.name = "mole"
        mole.setScale(0.1)
        let x = CGFloat.random(in: 1+mole.size.width..<size.width-mole.size.width)
        let y = CGFloat.random(in: 1+mole.size.height..<size.height-mole.size.height)
        mole.position = CGPoint(x: x, y: y)
        addChild(mole)
        mole.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 1.5),
                SKAction.run(gameOver),
            ]))
    }
   
    func gameOver(){
        self.backgroundColor = UIColor.red
        self.removeAllChildren()
        self.removeAllActions()
        addChild(scoreLabel)
        addChild(playButton)
        playButton.text = "UH OH - Play again?"
        playButton.run(SKAction.fadeIn(withDuration: 0.3))
        playButton.run(SKAction.rotate(byAngle: (2 * 3.14), duration: 0.5))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.inGame=false
        }
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !inGame{
            score = 0
            startGame()
        }
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNodes = self.nodes(at: location)
            for touchedNode in touchedNodes{
                if touchedNode.name == "mole"{
                    touchedNode.removeFromParent()
                    score += 1
                }
            }
        }
    }
}
