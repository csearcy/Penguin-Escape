//
//  Coin.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/17/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode, GameSprite {
	
	var textureAtlas = SKTextureAtlas(named: "goods.atlas")
	var value = 1
	var spinAnimation = SKAction()
	let coinSound = SKAction.playSoundFileNamed("Sound/Coin.aif", waitForCompletion: false)
	func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 26, height: 26)) {
		
		parentNode.addChild(self)
		self.size = size
		self.position = position
		self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
		self.physicsBody?.affectedByGravity = false
		self.texture = textureAtlas.textureNamed("coin-bronze.png")
		createAnimations()
		self.runAction(spinAnimation)
		
		// Assign categories to physics bodies
		self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
		self.physicsBody?.collisionBitMask = 0
	}
	
	func turnToGold() {
		
		self.texture = textureAtlas.textureNamed("coin-gold.png")
		self.value = 5
		
	}
	
	func createAnimations() {
		
		// Make the coins spin
		let spin1 = SKAction.scaleXTo(0, duration: 1.5)
		let spin2 = SKAction.scaleXTo(1, duration: 1.5)
		
		let spinSequence = SKAction.sequence([spin1, spin2])
		
		spinAnimation = SKAction.repeatActionForever(spinSequence)

	}
	
	func collect() {
		// set animations for coin collecting
		self.physicsBody?.categoryBitMask = 0
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
		runAction(coinSound)
	}
	
	func onTap() {
		
	}
}