//
//  AppDelegate.swift
//  My Little Engine
//
//  Created by Jannik Theiß on 25.12.16.
//  Copyright © 2016 Exceptional Eye Staring. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	@IBOutlet weak var openGLView: ExampleSceneView!
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		window.backgroundColor = NSColor.clear
	}
	
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}

	@IBAction func toggleShowDebug(_ sender: NSMenuItem) {
		sender.state = 1 - sender.state
		let showDebug = sender.state == 0 ? false : true
		
		openGLView.showDebug = showDebug
	}
	
	@IBAction func toggleBackgroundTransparency(_ sender: NSMenuItem) {
		sender.state = 1 - sender.state
		let isTransparent = sender.state == 0 ? false : true
		
		window.isOpaque = !isTransparent
		window.hasShadow = !isTransparent
		
		openGLView.setBackgroundTransparency(isTransparent)
	}
	
	@IBAction func screenshot(_ sender: NSMenuItem) {
		
		let image = openGLView.screenshot()
		let imageTiff = image.tiffRepresentation!
		
		let savePanel = NSSavePanel()
		savePanel.nameFieldStringValue = "screenshot.tiff"
		
		savePanel.beginSheetModal(for: window) { result in
			
			if (result == NSFileHandlingPanelOKButton) {
				if let url = savePanel.url {
					try! imageTiff.write(to: url)
				}
			}
		}

	}
}

