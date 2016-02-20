//
//  Ground.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/16/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit

class Ground: SKSpriteNode, GameSprite {
	
	
	var textureAtlas = SKTextureAtlas(named: "ground.atlas")
	var groundTexture:SKTexture?
	var jumpWidth = CGFloat()
	var jumpCount = CGFloat(1)
	
	
	func spawn(parentNode: SKNode, position: CGPoint, size: CGSize) {
		parentNode.addChild(self)
		self.size = size
		self.position = position
		self.anchorPoint = CGPointMake(0, 1)
		
		// defualt ot ice texture
		if groundTexture == nil {
			groundTexture = textureAtlas.textureNamed("ice-tile.png")
		}
		
		// repeat texture
		createChildren()
		
		
		// add physics body
		let pointTopRight = CGPoint(x: size.width, y: 0)
		self.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointZero, toPoint: pointTopRight)
		
		// Assign categories to physics bodies
		self.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
		
	}
	
	func createChildren() {
		
		// get the tile texture and repeat it to crate one full lenght ground image
		if let texture = groundTexture {
			var tileCount:CGFloat = 0
			let textureSize = texture.size()
			let tileSize = CGSize(width: textureSize.width/2, height: textureSize.height/2)
			
			while tileCount * tileSize.width < self.size.width {
				let tileNode = SKSpriteNode(texture: texture)
				tileNode.size = tileSize
				tileNode.position.x = tileCount * tileSize.width
				tileNode.anchorPoint = CGPoint(x: 0, y: 1)
				self.addChild(tileNode)
				tileCount++
			}
			
			// get width of 1/3 of child nodes
			jumpWidth = tileSize.width * floor(tileCount/3)
		}
	}
	
	func checkForReposition(playerProgress:CGFloat) {
	
		// see if the ground needs to move forward
		let groundJumpPosition = jumpWidth * jumpCount
		
		if playerProgress >= groundJumpPosition {
			// player has moved past indicated jump position
			self.position.x	+= jumpWidth
			jumpCount++
		}
	}
	
	func onTap() {
	}
}