import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //variables
    var inGame = false
    var score = 0
    var highScore = 0
    var mole = SKSpriteNode()
    var scoreLabel: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    var playButton: SKLabelNode!
    
    //set up the screen
    override func didMove(to view: SKView) {
        //the label for score and high score
        scoreLabel = SKLabelNode()
        //label for the "click to play text"
        playButton = SKLabelNode()
        //positioning the label 35 pixels from the top and in the middle
        scoreLabel.position = CGPoint(x: size.width * 0.5, y: size.height - 35)
        //puting the play text in the middle
        playButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        //Scaling to make them big and readable
        scoreLabel.fontSize *= 1.25
        playButton.fontSize *= 1.25
        addChild(scoreLabel)
        addChild(playButton) 
        playButton.text = "TOUCH TO PLAY"
    }
    
    func spawnMole(){
        //Mole is now this thing called a spritnode with us passing in the image we put in assets
        mole = SKSpriteNode(imageNamed: "mole")
        mole.name = "mole"
        //make the image the right size this might need tweeking for different devices
        mole.setScale(0.1)
        //this is the random placment part take a sec to figure out how this works
        //the CGFloat.random is given a range equal to the screen size - the width of the mole so all moles are on screen
        let x = CGFloat.random(in: 1 + mole.size.width ... size.width-mole.size.width)
        let y = CGFloat.random(in: 1 + mole.size.height ... size.height-mole.size.height)
        //setting its position to the two numbers we made
        mole.position = CGPoint(x: x, y: y)
        //adding it to the scene
        addChild(mole)
        //it then runs this sequence where it waits for an amount of time and then triggers the game over func
        mole.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 1.5),
                SKAction.run(gameOver),
            ]))
    }
   
    func game(){
        if score > highScore{
            highScore=score
        }
        scoreLabel.text = "score: \(score)" + "    max: \(highScore)"
        run(SKAction.sequence([SKAction.run(spawnMole),SKAction.wait(forDuration: 0.5 - (0.005 * Double(score))), SKAction.run(game)
                ]))
    }
    
    func startGame(){
        inGame = true
        self.backgroundColor = UIColor.green
        playButton.run(SKAction.fadeOut(withDuration: 0.3))
        game()
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
