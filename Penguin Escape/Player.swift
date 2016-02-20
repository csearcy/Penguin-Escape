//
//  Player.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/16/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox

// set global health value to be used by HUD and Gamescene to display health level
let initialHealth = 3

class Player: SKSpriteNode, GameSprite {
	
	
	var textureAtlas = SKTextureAtlas(named: "pierre.atlas")
	var flyAnimation = SKAction()
	var soarAnimation = SKAction()
	var flapping = false
	let maxFlappingForce:CGFloat = 57000
	let maxHeight:CGFloat = 1000
	var invulnerable = false
	var damaged = false
	var health:Int = initialHealth
	var damageAnimation = SKAction()
	var dieAnimation = SKAction()
	var forwardVelocity:CGFloat = 200
	let powerupSound = SKAction.playSoundFileNamed("Sound/Powerup.aif", waitForCompletion: false)
	let hurtSound = SKAction.playSoundFileNamed("Sound/Hurt.aif", waitForCompletion: false)
	
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
		
		// Assign categories to physics bodies
		self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
		self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.ground.rawValue | PhysicsCategory.powerup.rawValue | PhysicsCategory.coin.rawValue
		
		// Create dot trail for player
		let dotEmitter = SKEmitterNode(fileNamed: "PlayerPath.sks")
		dotEmitter!.particleZPosition = -1
		self.addChild(dotEmitter!)
		dotEmitter!.targetNode = self.parent
		
		self.physicsBody?.affectedByGravity = false
		self.physicsBody?.velocity.dy = 50
		let startGravitySequence = SKAction.sequence([SKAction.waitForDuration(0.6), SKAction.runBlock {
			self.physicsBody?.affectedByGravity = true
			}])
		self.runAction(startGravitySequence)
	}
	
	func createAnimations() {
		
		// Create flapping and soaring animations
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
	
		// Create taking damage animation
		let damageStart = SKAction.runBlock {
			// let user pass through enemies after taking damage
			self.physicsBody?.categoryBitMask = PhysicsCategory.damagedPenguin.rawValue
			self.physicsBody?.collisionBitMask = ~PhysicsCategory.enemy.rawValue
		}
		
		let slowFade = SKAction.sequence([SKAction.fadeAlphaTo(0.3, duration: 0.35), SKAction.fadeAlphaTo(0.7, duration: 0.35)])
		let fastFade = SKAction.sequence([SKAction.fadeAlphaTo(0.3, duration: 0.2), SKAction.fadeAlphaTo(0.7, duration: 0.2)])
		let fadeOutFadeIn = SKAction.sequence([SKAction.repeatAction(slowFade, count: 2), SKAction.repeatAction(fastFade, count: 5), SKAction.fadeAlphaTo(1, duration: 0.15)])
		let damagedEnd = SKAction.runBlock {
			// reactivate physics collisions
			self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
			self.physicsBody?.collisionBitMask = 0xFFFFFFFF
			self.damaged = false
		}
		
		damageAnimation = SKAction.sequence([damageStart, fadeOutFadeIn, damagedEnd])
		
		
		// Create dying animation
		let startDie = SKAction.runBlock {
			self.texture = self.textureAtlas.textureNamed("pierre-dead.png")
			self.physicsBody?.affectedByGravity	= false
			self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
			self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
		}
		
		let endDie = SKAction.runBlock {
			self.physicsBody?.affectedByGravity = true
		}
		
		dieAnimation = SKAction.sequence([startDie, SKAction.scaleTo(1.3, duration: 0.1), SKAction.rotateToAngle(CGFloat(M_PI), duration: 0.5), endDie])
		
	}
	
	func update() {
		
		// set constant velocity for player
		self.physicsBody?.velocity.dx = forwardVelocity
		
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
		// only allow flapping if player is still alive
		if health <= 0 { return }
		self.removeActionForKey("soarAnimation")
		self.runAction(flyAnimation, withKey: "flapAnimation")
		self.flapping = true
	}
	
	func stopFlapping() {
		// only allow soaring if player is still alive
		if health <= 0 { return }
		self.runAction(soarAnimation, withKey: "soarAnimation")
		self.flapping = false
	}
	
	func die() {
		// make player fully visible
		self.alpha = 1
		
		// stop play animations and run death animation
		removeAllActions()
		runAction(dieAnimation)
		self.flapping = false
		self.forwardVelocity = 0
		
		// alert the gamescene
		if let gameScene = self.parent?.parent as? GameScene {
			gameScene.gameOver()
		}
		
	}
	
	func takeDamage() {
		// do nothing if player is invulnerable or damaged
		if invulnerable || damaged { return }
		
		// otherwise remove one health
		damaged = true
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
		health--
		if health == 0 {
			die()
		} else {
			// take damage animation
			runAction(damageAnimation)
		}
		runAction(hurtSound)
	}
	
	func starPower() {
		self.removeActionForKey("starPower")
		self.forwardVelocity += 200
		self.invulnerable = true
		
		let starSequence = SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.3), SKAction.waitForDuration(8), SKAction.scaleTo(1, duration: 1), SKAction.runBlock {
				self.forwardVelocity -= 200
				self.invulnerable = false
			}])
		runAction(starSequence, withKey: "starPower")
		runAction(powerupSound)
	}
	
	func onTap() {
		
	}

	
}