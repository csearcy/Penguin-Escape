//
//  Ghost.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/17/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit

class Ghost: SKSpriteNode, GameSprite {
	
	var textureAtlas = SKTextureAtlas(named: "enemies.atlas")
	var fadeAnimation = SKAction()
	
	func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 30, height: 44)) {
		
		parentNode.addChild(self)
		createAnimations()
		self.size = size
		self.position = position
		self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
		self.physicsBody?.affectedByGravity = false
		self.texture = textureAtlas.textureNamed("ghost-frown.png")
		self.runAction(fadeAnimation)
		self.alpha = 0.8
		
		// Assign categories to physics bodies
		self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
		self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
	}
	
	func createAnimations() {
		
		// make the ghost fade in and out
		let fadeOutGroup = SKAction.group([SKAction.fadeAlphaTo(0.3, duration: 2), SKAction.scaleTo(0.8, duration: 2)])
		let fadeInGroup = SKAction.group([SKAction.fadeAlphaTo(0.8, duration: 2), SKAction.scaleTo(1, duration: 2)])
		let fadeSequence = SKAction.sequence([fadeOutGroup, fadeInGroup])
		
		fadeAnimation = SKAction.repeatActionForever(fadeSequence)
		
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