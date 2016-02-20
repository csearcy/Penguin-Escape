//
//  HUD.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/18/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit

class HUD: SKNode {
	
	var textureAtlas = SKTextureAtlas(named: "hud.atlas")
	var heartNodes:[SKSpriteNode] = []
	let coinCountText = SKLabelNode(text: "000000")
	let hitsAllowed = initialHealth
	let restartButton = SKSpriteNode()
	let menuButton = SKSpriteNode()
	
	func createHudNodes(screenSize: CGSize) {
		
		// Create icon coin counter
		let coinTextureAtlas = SKTextureAtlas(named: "goods.atlas")
		let coinIcon = SKSpriteNode(texture: coinTextureAtlas.textureNamed("coin-bronze.png"))
		let coinYPos = screenSize.height - 23
		coinIcon.size = CGSize(width: 26, height: 26)
		coinIcon.position = CGPoint(x: 23, y: coinYPos)
		
		coinCountText.fontName = "AvenirNext-HeavyItalic"
		coinCountText.position = CGPoint(x: 41, y: coinYPos)
		coinCountText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
		coinCountText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
		
		addChild(coinCountText)
		addChild(coinIcon)
		
		// Creat heart nodes
		for (var index = 0; index < hitsAllowed; ++index) {
			let newHeartNode = SKSpriteNode(texture: textureAtlas.textureNamed("heart-full"))
			newHeartNode.size = CGSize(width: 46, height: 40)
			
			let xPos = CGFloat(index * 60 + 33)
			let yPos = CGFloat(screenSize.height - 66)
			newHeartNode.position = CGPoint(x: xPos, y: yPos)
			heartNodes.append(newHeartNode)
			self.addChild(newHeartNode)
		}
		
		// create menu and restart buttons
		restartButton.texture = SKTexture(imageNamed: "button-restart.png")
		menuButton.texture = SKTexture(imageNamed: "button-menu.png")
		restartButton.name = "restartGame"
		menuButton.name = "returnToMenu"
		let centerOfHud = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
		restartButton.position = centerOfHud
		menuButton.position = CGPoint(x: centerOfHud.x - 140, y: centerOfHud.y)
		restartButton.size = CGSize(width: 140, height: 140)
		menuButton.size = CGSize(width: 70, height: 70)
		
	}
	
	func setCoinCountDisplay(newCoinCoout: Int) {
		
		// formate coin count and update label text
		let formatter = NSNumberFormatter()
		formatter.minimumIntegerDigits = 6
		if let coinStr = formatter.stringFromNumber(newCoinCoout) {
			coinCountText.text = coinStr
		}
	}
	
	func setHealthDisplay(newHealth: Int) {
		
		// fade out any lost hearts
		let fadeAction = SKAction.fadeAlphaTo(0.2, duration: 0.3)
		
		// loop through hearts and update their status
		for var index = 0; index < heartNodes.count; ++index {
			if index < newHealth {
				heartNodes[index].alpha = 1
			} else {
				heartNodes[index].runAction(fadeAction)
			}
		}
	}
	
	func showButtons() {
		restartButton.alpha = 0
		menuButton.alpha = 0
		self.addChild(restartButton)
		self.addChild(menuButton)
		
		let fadeAnimation = SKAction.fadeAlphaTo(1, duration: 0.4)
		restartButton.runAction(fadeAnimation)
		menuButton.runAction(fadeAnimation)
	}
}