//
//  GameScene.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/15/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit
//import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	let world = SKNode()
	let ground = Ground()
	let player = Player()
	var screenCenterY = CGFloat()
	let initialPlayerPosition = CGPoint(x: 150, y: 250)
	var playerProgress = CGFloat()
	let encounterManager = EncounterManager()
	var nextEncounterSpawnPosition = CGFloat(150)
	let powerUpStar = Star()
	var coinsCollected = 0
	let hud = HUD()
	var backgrounds:[Background] = []
	let gameStartSound = SKAction.playSoundFileNamed("Sound/StartGame.aif", waitForCompletion: false)
	//let motionManager = CMMotionManager()
	
	override func didMoveToView(view: SKView) {
		
		// set a blue sky background
		self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
	
		// Add the world for which our scene will take place
		addChild(world)
		
		// Add ground
		let groundPosition = CGPoint(x: -self.size.width, y: 30)
		let groundSize = CGSize(width: self.size.width*3, height: 0)
		ground.spawn(world, position: groundPosition, size: groundSize)
	
		// load player
		player.spawn(world, position: initialPlayerPosition)
		
		/* tilt function call
		// poll orientation data
		self.motionManager.startAccelerometerUpdates()
		*/

		// adjust the force of gravity
		self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
		
		// get the center of the screen
		screenCenterY = self.size.height / 2
		
		// set up initial encounter
		encounterManager.addEncountersToWorld(self.world)
		encounterManager.encounters[0].position = CGPoint(x: 300, y: 0)
		
		// spawn power up star
		powerUpStar.spawn(world, position: CGPoint(x: -2000, y: -2000))
		
		// inform gameScene of contact events
		self.physicsWorld.contactDelegate = self
		
		// create hud child nodes
		hud.createHudNodes(self.size)
		addChild(hud)
		hud.zPosition = 50
		
		// spawn backgrounds
		for _ in 0...3 {
			backgrounds.append(Background())
		}
		
		backgrounds[0].spawn(world, imageName: "Background-1", zPosition: -5, movementMultiplier: 0.75)
		backgrounds[1].spawn(world, imageName: "Background-2", zPosition: -10, movementMultiplier: 0.5)
		backgrounds[2].spawn(world, imageName: "Background-3", zPosition: -15, movementMultiplier: 0.2)
		backgrounds[3].spawn(world, imageName: "Background-4", zPosition: -20, movementMultiplier: 0.1)
		
		// Play Start game sound
		runAction(gameStartSound)
	}
	
	override func didSimulatePhysics() {
		
		// create a world that centers around the player
		var worldYPos: CGFloat = 0
		
		// Zoom out as the player flies higher
		if (player.position.y > screenCenterY) {
			let percentOfMaxHeight = (player.position.y - screenCenterY) / (player.maxHeight - screenCenterY)
			let scaleSubstration = (percentOfMaxHeight > 1 ? 1 : percentOfMaxHeight) * 0.6
			let newScale = 1 - scaleSubstration
			
			world.yScale = newScale
			world.xScale = newScale
			
			worldYPos = -(player.position.y * world.yScale - (self.size.height / 2))
		}
		
		let worldXPos = -(player.position.x * world.xScale - (self.size.width / 3))
			
		world.position = CGPoint(x: worldXPos, y: worldYPos)
		
		// Track how far player has flown horizontally
		playerProgress = player.position.x - initialPlayerPosition.x
		ground.checkForReposition(playerProgress)
		
		
		// Check to see if a new encounter should be set
		if player.position.x > nextEncounterSpawnPosition {
			encounterManager.placeNextEncounter(nextEncounterSpawnPosition)
			nextEncounterSpawnPosition += 1400
			let starRoll = Int(arc4random_uniform(10))
			if starRoll == 0 {
				if abs(player.position.x - powerUpStar.position.x) > 1200 {
					// only move star if it's off the screen
					let randomYPos = CGFloat(arc4random_uniform(400))
					powerUpStar.position = CGPoint(x: nextEncounterSpawnPosition, y: randomYPos)
					powerUpStar.physicsBody?.angularVelocity = 0
					powerUpStar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
				}
			}
		}
		
		// reposition backgrounds
		for background in self.backgrounds {
			background.updatePostition(playerProgress)
		}
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		// get location of touch and find out which, if any, node is at that posistion. Run the nodes onTap() function
		for touch in touches {
			let location = touch.locationInNode(self)
			let nodeTouched = nodeAtPoint(location)
			
			if let gameSprite = nodeTouched as? GameSprite {
				gameSprite.onTap()
			}
			
			// Check hud buttons
			if nodeTouched.name == "restartGame" {
				self.view?.presentScene(GameScene(size: self.size), transition: .crossFadeWithDuration(0.6))
			} else if nodeTouched.name == "returnToMenu" {
				self.view?.presentScene(MenuScene(size: self.size), transition: .crossFadeWithDuration(0.6))

			}
		}
		
		player.startFlapping()
		
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		player.stopFlapping()
	}
	
	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		player.stopFlapping()
	}
	
	override func update(currentTime: NSTimeInterval) {
		player.update()
		
		
		/*
		// Utilizing tilt function
		if let accelData = self.motionManager.accelerometerData {
			
			var forceAmount:CGFloat
			var movement = CGVector()
			
			switch UIApplication.sharedApplication().statusBarOrientation {
				case .LandscapeLeft:
					forceAmount = 20000
				case .LandscapeRight:
					forceAmount = -20000
				default:
					forceAmount = 0
			}
			
			if accelData.acceleration.y > 0.15 {
				movement.dx = forceAmount
			} else if accelData.acceleration.y < -0.15 {
				movement.dx = -forceAmount
			}
			
			player.physicsBody?.applyForce(movement)
			
		}
		*/
	}
	
	func didBeginContact(contact: SKPhysicsContact) {
		// determine which body is the penguin
		let otherBody:SKPhysicsBody
		let penguinMask = PhysicsCategory.penguin.rawValue | PhysicsCategory.damagedPenguin.rawValue
		
		if (contact.bodyA.categoryBitMask & penguinMask) > 0 {
			// body A is penguin
			otherBody = contact.bodyB
		} else {
			// body B is the penguin
			otherBody = contact.bodyA
		}
		
		switch otherBody.categoryBitMask {
		case PhysicsCategory.ground.rawValue:
			player.takeDamage()
			hud.setHealthDisplay(player.health)
		case PhysicsCategory.enemy.rawValue:
			player.takeDamage()
			hud.setHealthDisplay(player.health)
		case PhysicsCategory.coin.rawValue:
			if let coin = otherBody.node as? Coin {
				coin.collect()
				self.coinsCollected += coin.value
				hud.setCoinCountDisplay(self.coinsCollected)
			}
		case PhysicsCategory.powerup.rawValue:
			player.starPower()
		default:
			print("Contact with no game logic")
		}
	}
	
	func gameOver() {
		hud.showButtons()
	}
	
}

enum PhysicsCategory:UInt32 {
	case penguin = 1
	case damagedPenguin = 2
	case ground = 4
	case enemy = 8
	case coin = 16
	case powerup = 32
}

