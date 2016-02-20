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
import AVFoundation

class GameViewController: UIViewController {

	var musicPlayer = AVAudioPlayer()
	
	override func viewWillLayoutSubviews() {
		
		super.viewWillLayoutSubviews()
		
		let menuScene = MenuScene()
		let skView = self.view as! SKView
		
		skView.ignoresSiblingOrder = true
		menuScene.size = view.bounds.size
		skView.presentScene(menuScene)
		
		// Add background music
		let musicUrl = NSBundle.mainBundle().URLForResource("Sound/BackgroundMusic.m4a", withExtension: nil)
		if let url = musicUrl {
			do { musicPlayer =  try AVAudioPlayer(contentsOfURL: url, fileTypeHint:nil)}
			catch let error as NSError { print(error.description) }
			musicPlayer.numberOfLoops = -1
			musicPlayer.prepareToPlay()
			musicPlayer.play()
		}
		
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
