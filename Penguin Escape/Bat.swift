//
//  Bat.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/17/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit

class Bat: SKSpriteNode, GameSprite {
	
	var textureAtlas = SKTextureAtlas(named: "enemies.atlas")
	var flyAnimation = SKAction()
	
	func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 44, height: 24)) {
		
		parentNode.addChild(self)
		createAnimations()
		self.size = size
		self.position = position
		self.runAction(flyAnimation)
		self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
		self.physicsBody?.affectedByGravity = false
		
		// Assign categories to physics bodies
		self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
		self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
	}
	
	func createAnimations() {
		
		// make bat fly!!
		let flyFrames:[SKTexture] = [textureAtlas.textureNamed("bat-fly-1.png"), textureAtlas.textureNamed("bat-fly-2.png"), textureAtlas.textureNamed("bat-fly-3.png"), textureAtlas.textureNamed("bat-fly-4.png"), textureAtlas.textureNamed("bat-fly-3.png"), textureAtlas.textureNamed("bat-fly-2.png")]
		let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.06)
		
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