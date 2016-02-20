//
//  EncounterManager.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/17/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit

class EncounterManager {
	
	
	let encounterNames:[String] = ["EncounterBats", "EncounterBees", "EncounterCoins"]
	var encounters:[SKNode] = []
	var currentEncounterIndex:Int?
	var previousEncounterIndex:Int?
	
	init()	{
		for encounterFileName in encounterNames {
			let encounter = SKNode()
			
			if let encounterScene = SKScene(fileNamed: encounterFileName) {
				
				for placeholder in encounterScene.children {
					if let node = placeholder as? SKNode {
						switch node.name! {
						case "Bat":
							let bat = Bat()
							bat.spawn(encounter, position: node.position)
						case "Bee":
							let bee = Bee()
							bee.spawn(encounter, position: node.position)
						case "Blade":
							let blade = Blade()
							blade.spawn(encounter, position: node.position)
						case "Ghost":
							let ghost = Ghost()
							ghost.spawn(encounter, position: node.position)
						case "MadFly":
							let madFly = MadFly()
							madFly.spawn(encounter, position: node.position)
						case "GoldCoin":
							let goldCoin = Coin()
							goldCoin.spawn(encounter, position: node.position)
							goldCoin.turnToGold()
						case "BronzeCoin":
							let bronzeCoin = Coin()
							bronzeCoin.spawn(encounter, position: node.position)
						default:
							print("Name Error: \(node.name)")
						}
					}
				}
			}
			
			encounters.append(encounter)
			saveSpritePostions(encounter)
		}
	}
	
	func addEncountersToWorld(world: SKNode) {
		for index in 0 ... encounters.count - 1 {
			encounters[index].position = CGPoint(x: -2000, y: index*1000)
			world.addChild(encounters[index])
		}
	}
	
	func saveSpritePostions(node: SKNode) {
		
		for sprite in node.children {
			if let spriteNode = sprite as? SKSpriteNode {
				let initialPositionValue = NSValue(CGPoint: sprite.position)
				spriteNode.userData = ["initialPosition": initialPositionValue]
				saveSpritePostions(spriteNode)
			}
		}
		
	}
	
	func resetSpritePositions(node:SKNode) {
		
		for sprite in node.children {
			
			if let spriteNode = sprite as? SKSpriteNode	{
				spriteNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
				spriteNode.physicsBody?.angularVelocity = 0
				spriteNode.zRotation = 0
				if let initialPositionVal = spriteNode.userData?.valueForKey("initialPosition") as? NSValue {
					spriteNode.position = initialPositionVal.CGPointValue()
				}
				resetSpritePositions(spriteNode)
			}
			
		}
		
	}
	
	func placeNextEncounter(currentXPos: CGFloat) {
	
		let encounterCount = UInt32(encounters.count)
		if encounters.count < 3 { return }
		
		var nextEncounterIndex:Int?
		var trulyNew:Bool?
		
		while trulyNew == false || trulyNew == nil {
			nextEncounterIndex = Int(arc4random_uniform(encounterCount))
			trulyNew = true
			if let currentIndex = currentEncounterIndex {
				if (nextEncounterIndex == currentIndex) {
					trulyNew = false
				}
			}
			if let previousIndex = previousEncounterIndex {
				if (nextEncounterIndex == previousIndex) {
					trulyNew = false
				}
			}
		}
		
		previousEncounterIndex = currentEncounterIndex
		currentEncounterIndex = nextEncounterIndex
		
		let encounter = encounters[currentEncounterIndex!]
		encounter.position = CGPoint(x: currentXPos + 1000, y: 0)
		resetSpritePositions(encounter)
		
	}
	
}