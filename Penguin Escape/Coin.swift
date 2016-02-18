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
	
	func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 26, height: 26)) {
		
		parentNode.addChild(self)
		self.size = size
		self.position = position
		self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
		self.physicsBody?.affectedByGravity = false
		self.texture = textureAtlas.textureNamed("coin-bronze.png")
		//createAnimations()
		//self.runAction(spinAnimation)
	}
	
	func turnToGold() {
		
		self.texture = textureAtlas.textureNamed("coin-gold.png")
		self.value = 5
		
	}
	
	func createAnimations() {
		
		// let coin rotate
		//self.xScale = self.xScale * -1
		
		//spinAnimation = SKAction.repeatActionForever(spin)

	}
	
	func onTap() {
		
	}
}