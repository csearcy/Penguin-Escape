//
//  GameSprite.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/16/16.
//  Copyright © 2016 Chris Searcy. All rights reserved.
//

import Foundation
import SpriteKit

// Classes that adopt protocols must follow its specifications
protocol GameSprite {
	var textureAtlas: SKTextureAtlas { get set }
	
	func spawn(parentNode: SKNode, position: CGPoint, size: CGSize)
	func onTap()
	
}