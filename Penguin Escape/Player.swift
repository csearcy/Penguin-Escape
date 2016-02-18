//
//  Player.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/16/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode, GameSprite {
	
	
	var textureAtlas = SKTextureAtlas(named: "pierre.atlas")
	var flyAnimation = SKAction()
	var soarAnimation = SKAction()
	var flapping = false
	let maxFlappingForce:CGFloat = 57000
	let maxHeight:CGFloat = 1000
	
	func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 64, height: 64)) {
		
		// initialize player
		parentNode.addChild(self)
		createAnimations()
		self.size = size
		self.position = position
		self.runAction(soarAnimation, withKey: "soarAnimation")
		
		// add physics body
		let bodyTexture = textureAtlas.textureNamed("pierre-flying-3.png")
		self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: size)
		self.physicsBody?.linearDamping = 0.9
		self.physicsBody?.mass = 30
		self.physicsBody?.allowsRotation = false
		
	}
	
	func createAnimations() {
		let rotateUpAction = SKAction.rotateToAngle(0, duration: 0.475)
		rotateUpAction.timingMode = .EaseOut
		
		let rotateDownAction = SKAction.rotateToAngle(-1, duration: 0.8)
		rotateDownAction.timingMode = .EaseIn
		
		let flyFrames:[SKTexture] = [textureAtlas.textureNamed("pierre-flying-1.png"), textureAtlas.textureNamed("pierre-flying-2.png"), textureAtlas.textureNamed("pierre-flying-3.png"), textureAtlas.textureNamed("pierre-flying-4.png"), textureAtlas.textureNamed("pierre-flying-3.png"), textureAtlas.textureNamed("pierre-flying-2.png")]
		let flyAction = SKAction.animateWithTextures(flyFrames, timePerFrame: 0.03)
		flyAnimation = SKAction.group([SKAction.repeatActionForever(flyAction), rotateUpAction])
		
		let soarFrames:[SKTexture] = [textureAtlas.textureNamed("pierre-flying-1.png")]
		let soarAction = SKAction.animateWithTextures(soarFrames, timePerFrame: 1)
		soarAnimation = SKAction.group([SKAction.repeatActionForever(soarAction),rotateDownAction])
	
	}
	
	func update() {
		
		// set constant velocity for player
		self.physicsBody?.velocity.dx = 200
		
		if self.flapping {
			var forceToApply = maxFlappingForce
			
			if position.y > 600 {
				let percentOfMaxHeight = position.y / maxHeight
				let flappingForceSubtraction = percentOfMaxHeight * maxFlappingForce
				forceToApply -= flappingForceSubtraction
			}
			self.physicsBody?.applyForce(CGVector(dx: 0, dy: forceToApply))
		}
		
		if self.physicsBody?.velocity.dy > 300 {
			self.physicsBody?.velocity.dy = 300
		}
	}
	
	func startFlapping() {
		self.removeActionForKey("soarAnimation")
		self.runAction(flyAnimation, withKey: "flapAnimation")
		self.flapping = true
	}
	
	func stopFlapping() {
		self.runAction(soarAnimation, withKey: "soarAnimation")
		self.flapping = false
	}
	
	func onTap() {
		
	}

	
}