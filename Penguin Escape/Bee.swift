//
//  Bee.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/16/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit

// Create  a class for bees that are of type SKSpriteNode and follow the GameSprite protocol
class Bee: SKSpriteNode, GameSprite {
	
	var textureAtlas = SKTextureAtlas(named: "bee.atlas")
	var flyAnimation = SKAction()
	
	func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 28, height: 24)) {
		
		// initalize
		parentNode.addChild(self)
		createAnimations()
		self.size = size
		self.position = position
		self.runAction(flyAnimation)
		
		// add physics
		self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
		self.physicsBody?.affectedByGravity = false
		
		// Assign categories to physics bodies
		self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
		self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue

	}

	func createAnimations() {
		let flyFrames = [textureAtlas.textureNamed("bee.png"), textureAtlas.textureNamed("bee_fly.png")]
		let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.14)
		flyAnimation = SKAction.repeatActionForever(flyAction)
	}
	
	func remove() {
		// set animations for enemy removal
		self.physicsBody?.categoryBitMask = 0
		self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
		let collectAnimation = SKAction.group([SKAction.fadeAlphaTo(0, duration: 0.2), SKAction.scaleTo(1.5, duration: 0.2), SKAction.moveBy(CGVector(dx: 0, dy: 25), duration: 0.2)])
		let resetAfterCollected = SKAction.runBlock {
			self.position.y	= 5000
			self.alpha = 1
			self.xScale = 1
			self.yScale = 1
			self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
		}
		let collectSequence = SKAction.sequence([collectAnimation, resetAfterCollected])
		runAction(collectSequence)
	}
	
	func onTap() {
		
	}
}