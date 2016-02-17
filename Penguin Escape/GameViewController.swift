//
//  GameViewController.swift
//  Penguin Escape
//
//  Created by Chris Searcy on 2/15/16.
//  Copyright (c) 2016 Chris Searcy. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {

	override func viewWillLayoutSubviews() {
		
		super.viewWillLayoutSubviews()
		
		let scene = GameScene()
		let skView = self.view as! SKView
		
		skView.showsFPS =  true
		skView.showsNodeCount = true
		skView.ignoresSiblingOrder = true
		scene.scaleMode = .AspectFill
		
		scene.size = view.bounds.size
		skView.presentScene(scene)
		
	}
    func handleTap(gestureRecognize: UIGestureRecognizer) {
		
	}
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.Landscape
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
