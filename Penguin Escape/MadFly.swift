//
//  MadFly.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/17/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit

class MadFly: SKSpriteNode, GameSprite {
	
	var textureAtlas = SKTextureAtlas(named: "enemies.atlas")
	var flyAnimation = SKAction()
	
	func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 61, height: 29)) {
		
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
		
		// make fly...well, fly!!
		let flyFrames:[SKTexture] = [textureAtlas.textureNamed("mad-fly-1.png"), textureAtlas.textureNamed("mad-fly-2.png")]
		let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.14)
		
		flyAnimation = SKAction.repeatActionForever(flyAction)
	}
	
	
	func onTap() {
		
	}
}
