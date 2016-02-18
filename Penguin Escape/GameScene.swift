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

class GameScene: SKScene {
	
	let world = SKNode()
	let ground = Ground()
	let player = Player()
	var screenCenterY = CGFloat()
	let initialPlayerPosition = CGPoint(x: 150, y: 250)
	var playerProgress = CGFloat()
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
		
		let coin = Coin()
		coin.spawn(world, position: CGPoint(x: 460, y: 250))
		
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
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		// get location of touch and find out which, if any, node is at that posistion. Run the nodes onTap() function
		for touch in touches {
			let location = touch.locationInNode(self)
			let nodeTouched = nodeAtPoint(location)
			
			if let gameSprite = nodeTouched as? GameSprite {
				gameSprite.onTap()
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
}
