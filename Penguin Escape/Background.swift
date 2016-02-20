//
//  Background.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/18/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit

class Background: SKSpriteNode {
	
	var movementMultiplier = CGFloat(0)
	var jumpAdjustment = CGFloat(0)
	let backgroundSize = CGSize(width: 1000, height: 1000)
	
	func spawn(parentNode:SKNode, imageName:String, zPosition:CGFloat,  movementMultiplier:CGFloat) {
		
		self.anchorPoint = CGPointZero
		self.position = CGPoint(x: 0, y: 30)
		self.zPosition = zPosition
		self.movementMultiplier = movementMultiplier
		parentNode.addChild(self)
		
		// build 3 child node texture instances
		for i in -1...1 {
			let newBGNode = SKSpriteNode(imageNamed: imageName)
			newBGNode.size = backgroundSize
			newBGNode.anchorPoint = CGPointZero
			newBGNode.position = CGPoint(x: i * Int(backgroundSize.width), y: 0)
			self.addChild(newBGNode)
		}
	}
	
	func updatePostition(playerProgress:CGFloat) {
	
		let adjustedPosition = jumpAdjustment + playerProgress * (1 - movementMultiplier)
		if playerProgress - adjustedPosition > backgroundSize.width {
			jumpAdjustment += backgroundSize.width
		}
		
		self.position.x	= adjustedPosition
		
	}
	
}