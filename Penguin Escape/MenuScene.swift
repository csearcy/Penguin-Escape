//
//  MenuScene.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/18/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
	
	let texture = SKTextureAtlas(named: "hud.atlas")
	let startButton = SKSpriteNode()
	
	override func didMoveToView(view: SKView) {
		
		// Set background
		self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
		let backgroundImage = SKSpriteNode(imageNamed: "Background-menu.png")
		backgroundImage.size = CGSize(width: 1024, height: 768)
		backgroundImage.zPosition = 10
		self.addChild(backgroundImage)
		
		// Set game title
		let logoText = SKLabelNode(fontNamed: "AvenirNext-Heavy")
		logoText.text = "Penguin Escape!"
		logoText.position = CGPoint(x: 0, y: 75)
		logoText.fontSize = 60
		logoText.zPosition = 15
		self.addChild(logoText)
		
		// Create Start Button
		startButton.texture = SKTexture(imageNamed: "button.png")
		startButton.size = CGSize(width: 295, height: 76)
		startButton.name = "StartBtn"
		startButton.position = CGPoint(x: 0, y: -20)
		startButton.zPosition = 15
		self.addChild(startButton)
		
		let startText = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
		startText.text = "START GAME!"
		startText.verticalAlignmentMode = .Center
		startText.position = CGPoint(x: 0, y: 2)
		startText.fontSize = 40
		startText.name = "StartBtn"
		startText.zPosition = 20
		startButton.addChild(startText)
		
		// pulse start button
		let pulseaction = SKAction.sequence([SKAction.fadeAlphaTo(0.7, duration: 0.9), SKAction.fadeAlphaTo(1, duration: 0.9)])
		startButton.runAction(SKAction.repeatActionForever(pulseaction))
		
		// Create snow
		let snow = SKEmitterNode(fileNamed: "Snow.sks")
		snow!.particleZPosition = 17
		self.addChild(snow!)
		snow!.targetNode = self.parent
		
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches {
			
			let location = touch.locationInNode(self)
			let nodeTouched = nodeAtPoint(location)
			
			if nodeTouched.name	== "StartBtn" {
				self.view?.presentScene(GameScene(size: self.size))
			}
			
		}
	}
	
}