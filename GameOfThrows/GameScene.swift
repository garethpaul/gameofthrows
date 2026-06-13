//
//  GameScene.swift
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    let verticalPipeGap = 150.0
    
    var bird:SKSpriteNode!
    var skyColor:SKColor!
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
    var moving:SKNode!
    var pipes:SKNode!
    var canRestart = Bool()
    var scoreLabelNode:SKLabelNode!
    var score = NSInteger()
    
    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3

    func cancelBirdDeathRotation() {
        bird?.removeActionForKey("deathRotation")
    }

    func resetScenePresentation() {
        cancelBirdDeathRotation()
        self.removeActionForKey("spawnPipes")
        self.removeActionForKey("flash")
        self.removeAllChildren()
    }
    
    override func didMoveToView(view: SKView) {
        resetScenePresentation()
        
        canRestart = false
        
        // setup physics
        self.physicsWorld.gravity = CGVectorMake( 0.0, -5.0 )
        self.physicsWorld.contactDelegate = self
        
        // setup background color
        skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor
        
        moving = SKNode()
        self.addChild(moving)
        pipes = SKNode()
        moving.addChild(pipes)
        
        // ground
        let groundTexture = SKTexture(imageNamed: "land")
        groundTexture.filteringMode = .Nearest // shorter form for SKTextureFilteringMode.Nearest
        
        let moveGroundSprite = SKAction.moveByX(-groundTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveByX(groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
        
        for i in 0 ..< Int(2.0 + self.frame.size.width / (groundTexture.size().width * 2.0)){
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPointMake(CGFloat(i) * sprite.size.width, sprite.size.height / 2.0)
            sprite.runAction(moveGroundSpritesForever)
            moving.addChild(sprite)
        }
        
        // skyline
        let skyTexture = SKTexture(imageNamed: "sky")
        skyTexture.filteringMode = .Nearest
        
        let moveSkySprite = SKAction.moveByX(-skyTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveByX(skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveSkySprite,resetSkySprite]))
        
        for i in 0 ..< Int(2.0 + self.frame.size.width / (groundTexture.size().width * 2.0)){
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPointMake(CGFloat(i) * sprite.size.width, sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            sprite.runAction(moveSkySpritesForever)
            moving.addChild(sprite)
        }
        
        // create the pipes textures
        pipeTextureUp = SKTexture(imageNamed: "PipeUp")
        pipeTextureUp.filteringMode = .Nearest
        pipeTextureDown = SKTexture(imageNamed: "PipeDown")
        pipeTextureDown.filteringMode = .Nearest
        
        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        // spawn the pipes
        let spawn = SKAction.runBlock({ [weak self] in self?.spawnPipes() })
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever, withKey: "spawnPipes")
        
        // setup our bird
        let birdTexture1 = SKTexture(imageNamed: "bird-01")
        birdTexture1.filteringMode = .Nearest
        let birdTexture2 = SKTexture(imageNamed: "bird-02")
        birdTexture2.filteringMode = .Nearest
        
        let anim = SKAction.animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.2)
        let flap = SKAction.repeatActionForever(anim)
        
        bird = SKSpriteNode(texture: birdTexture1)
        bird.setScale(2.0)
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
        bird.runAction(flap)
        
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        self.addChild(bird)
        
        // create the ground
        let ground = SKNode()
        ground.position = CGPointMake(0, groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture.size().height * 2.0))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        self.addChild(ground)
        
        // Initialize label and create a label which holds the score
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        scoreLabelNode.position = CGPointMake( CGRectGetMidX( self.frame ), 3 * self.frame.size.height / 4 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(score)
        self.addChild(scoreLabelNode)
        
    }

    override func willMoveFromView(view: SKView) {
        cancelBirdDeathRotation()
        self.removeActionForKey("spawnPipes")
        self.removeActionForKey("flash")
        self.physicsWorld.contactDelegate = nil
    }
    
    func spawnPipes() {
        if !shouldSpawnPipes() {
            return
        }

        let pipePair = SKNode()
        pipePair.position = CGPointMake( self.frame.size.width + pipeTextureUp.size().width * 2, 0 )
        pipePair.zPosition = -10
        
        let height = max(UInt32(UInt(self.frame.size.height / 4)), 1)
        let y = arc4random_uniform(height) + height
        
        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPointMake(0.0, CGFloat(Double(y)) + pipeDown.size.height + CGFloat(verticalPipeGap))
        
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(Double(y)))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody?.dynamic = false
        pipeUp.physicsBody?.categoryBitMask = pipeCategory
        pipeUp.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeUp)
        
        let contactNode = SKNode()
        contactNode.position = CGPointMake( pipeDown.size.width + bird.size.width / 2, CGRectGetMidY( self.frame ) )
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake( pipeUp.size.width, self.frame.size.height ))
        contactNode.physicsBody?.dynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)
        
        pipePair.runAction(movePipesAndRemove)
        pipes.addChild(pipePair)
        
    }

    func shouldSpawnPipes() -> Bool {
        return isGameplayRunning() &&
            pipes != nil &&
            pipeTextureUp != nil &&
            pipeTextureDown != nil &&
            bird != nil &&
            movePipesAndRemove != nil
    }

    func isGameplayRunning() -> Bool {
        return moving != nil && moving.speed > 0
    }
    
    func resetScene (){
        guard let bird = bird,
            let pipes = pipes,
            let moving = moving,
            let scoreLabelNode = scoreLabelNode else {
            return
        }

        bird.removeActionForKey("deathRotation")

        // Move bird to original position and reset velocity
        bird.position = CGPointMake(self.frame.size.width / 2.5, CGRectGetMidY(self.frame))
        bird.physicsBody?.velocity = CGVectorMake( 0, 0 )
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.speed = 1.0
        bird.zRotation = 0.0
        
        // Remove all existing pipes
        pipes.removeAllChildren()
        
        // Reset _canRestart
        canRestart = false
        
        // Reset score
        score = 0
        scoreLabelNode.text = String(score)
        scoreLabelNode.setScale(1.0)
        
        // Restart animation
        moving.speed = 1
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {        /* Called when a touch begins */
        if isGameplayRunning() {
            applyBirdImpulse()
        }else if canRestart {
            self.resetScene()
        }
    }

    func applyBirdImpulse() {
        guard let bird = bird, let physicsBody = bird.physicsBody else {
            return
        }

        physicsBody.velocity = CGVectorMake(0, 0)
        physicsBody.applyImpulse(CGVectorMake(0, 30))
    }
    
    // TODO: Move to utilities somewhere. There's no reason this should be a member function
    func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        if( value > max ) {
            return max
        } else if( value < min ) {
            return min
        } else {
            return value
        }
    }

    func bodyMatchesCategory(body: SKPhysicsBody, category: UInt32) -> Bool {
        return ( body.categoryBitMask & category ) == category
    }

    func scoreContactNode(contact: SKPhysicsContact) -> SKNode? {
        let bodyAIsScore = bodyMatchesCategory(contact.bodyA, category: scoreCategory)
        let bodyBIsScore = bodyMatchesCategory(contact.bodyB, category: scoreCategory)
        let bodyAIsBird = bodyMatchesCategory(contact.bodyA, category: birdCategory)
        let bodyBIsBird = bodyMatchesCategory(contact.bodyB, category: birdCategory)

        if bodyAIsScore && bodyBIsBird {
            return contact.bodyA.node
        }

        if bodyBIsScore && bodyAIsBird {
            return contact.bodyB.node
        }

        return nil
    }

    func isBirdCollisionContact(contact: SKPhysicsContact) -> Bool {
        let bodyAIsBird = bodyMatchesCategory(contact.bodyA, category: birdCategory)
        let bodyBIsBird = bodyMatchesCategory(contact.bodyB, category: birdCategory)
        let bodyAIsObstacle = bodyMatchesCategory(contact.bodyA, category: worldCategory) ||
            bodyMatchesCategory(contact.bodyA, category: pipeCategory)
        let bodyBIsObstacle = bodyMatchesCategory(contact.bodyB, category: worldCategory) ||
            bodyMatchesCategory(contact.bodyB, category: pipeCategory)

        return (bodyAIsBird && bodyBIsObstacle) || (bodyBIsBird && bodyAIsObstacle)
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        guard let bird = bird, let physicsBody = bird.physicsBody else {
            return
        }

        let verticalVelocity = physicsBody.velocity.dy
        bird.zRotation = self.clamp( -1, max: 0.5, value: verticalVelocity * ( verticalVelocity < 0 ? 0.003 : 0.001 ) )
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if !isGameplayRunning() {
            return
        }

        guard let bird = bird,
            let moving = moving,
            let scoreLabelNode = scoreLabelNode,
            let skyColor = skyColor else {
            return
        }

        if let scoringNode = scoreContactNode(contact) {
            // Bird has contact with score entity
            scoringNode.physicsBody = nil
            scoringNode.removeFromParent()
            score += 1
            scoreLabelNode.text = String(score)

            // Add a little visual feedback for the score increment
            scoreLabelNode.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
            return
        }

        if !isBirdCollisionContact(contact) {
            return
        }

        moving.speed = 0

        bird.physicsBody?.collisionBitMask = worldCategory
        let deathRotation = SKAction.rotateByAngle(CGFloat(M_PI) * CGFloat(bird.position.y) * 0.01, duration:1)
        let stopBird = SKAction.runBlock({ bird.speed = 0 })
        bird.runAction(SKAction.sequence([deathRotation, stopBird]), withKey: "deathRotation")


        // Flash background if contact is detected
        self.removeActionForKey("flash")
        self.runAction(SKAction.sequence([SKAction.repeatAction(SKAction.sequence([SKAction.runBlock({
            self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
            }),SKAction.waitForDuration(NSTimeInterval(0.05)), SKAction.runBlock({
                self.backgroundColor = skyColor
                }), SKAction.waitForDuration(NSTimeInterval(0.05))]), count:4), SKAction.runBlock({
                    self.canRestart = true
                    })]), withKey: "flash")
    }
}
