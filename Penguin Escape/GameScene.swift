//
//  GameScene.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/15/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit


class GameScene: SKScene {
	
	let world = SKNode()
	let ground = Ground()
	let player = Player()
	
	override func didMoveToView(view: SKView) {
		
		self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
	
		// Add the world for which our scene will take place
		addChild(world)
		
		// Spawn more bees
		let bee2 = Bee()
		let bee3 = Bee()
		let bee4 = Bee()
		
		bee2.spawn(world, position: CGPoint(x: 325, y: 325))
		bee3.spawn(world, position: CGPoint(x: 200, y: 325))
		bee4.spawn(world, position: CGPoint(x: 50, y: 200))
		
		// Add ground
		let groundPosition = CGPoint(x: -self.size.width, y: 100)
		let groundSize = CGSize(width: self.size.width*3, height: 0)
		ground.spawn(world, position: groundPosition, size: groundSize)
	
		// load player
		player.spawn(world, position: CGPoint(x: 150, y: 250))
		
		bee2.physicsBody?.mass = 0.2
		bee2.physicsBody?.applyImpulse(CGVector(dx: -15, dy: 0))
		
	}
	
	override func didSimulatePhysics() {
		
		// create a world that centers around the bee
		let worldXPos = -(player.position.x * world.xScale - (size.width/2))
		let worldYPos = -(player.position.y * world.yScale - (size.height/2))
		world.position = CGPoint(x: worldXPos, y: worldYPos)
		
	}
}
