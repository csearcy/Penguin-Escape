//
//  Star.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/17/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit

class Star: SKSpriteNode, GameSprite {
	
	var textureAtlas = SKTextureAtlas(named: "goods.atlas")
	var pulseAnimation = SKAction()
	
	func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 40, height: 38)) {
		
		parentNode.addChild(self)
		createAnimations()
		self.size = size
		self.position = position
		self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
		self.physicsBody?.affectedByGravity = false
		self.texture = textureAtlas.textureNamed("power-up-star.png")
		self.runAction(pulseAnimation)
		
		// Assign categories to physics bodies
		self.physicsBody?.categoryBitMask = PhysicsCategory.powerup.rawValue
		
	}
	
	func createAnimations() {
		
		// pulse the star
		let pulseOutGroup = SKAction.group([SKAction.fadeAlphaTo(0.85, duration: 0.8), SKAction.scaleTo(0.6, duration: 0.8)])
		let pulseInGroup = SKAction.group([SKAction.fadeAlphaTo(1, duration: 1.5), SKAction.scaleTo(1, duration: 1.5)])
		let pulseSequence = SKAction.sequence([pulseOutGroup, pulseInGroup])
		
		pulseAnimation = SKAction.repeatActionForever(pulseSequence)
	}
	
	
	func remove() {
		// set animations for coin collecting
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