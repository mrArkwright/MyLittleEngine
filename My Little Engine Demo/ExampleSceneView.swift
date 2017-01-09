//
//  ExampleSceneView.swift
//  My Little Engine
//
//  Created by Jannik Theiß on 01.01.17.
//  Copyright © 2017 Exceptional Eye Staring. All rights reserved.
//

import Cocoa
import GLKit

class ExampleSceneView: EngineOpenGLView {
	
	var zoom: GLfloat = -10.0
	var rotationX: GLfloat = 0.0
	var rotationY: GLfloat = 0.0
	
	var cube: Model!
	var teapot: Model!
	var sphere: Model!
	
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		let cubePath = Bundle.main.path(forResource: "cube", ofType: "obj", inDirectory: "Models")!
		cube = Model(wavefrontFile: cubePath)
		
		let teapotPath = Bundle.main.path(forResource: "teapot", ofType: "obj", inDirectory: "Models")!
		teapot = Model(wavefrontFile: teapotPath)
		
		let spherePath = Bundle.main.path(forResource: "sphere", ofType: "obj", inDirectory: "Models")!
		sphere = Model(wavefrontFile: spherePath)
		
		scene.setClearColor(r: 1.0, g: 0.41, b: 0.71, a: 0.1)
	}
	
	override func drawScene(time: Float) {
		exampleScene(time)
//		iconScene()
	}
	
	func exampleScene(_ time: Float) {
		
		let viewWidth = GLfloat(self.frame.size.width)
		let viewHeight = GLfloat(self.frame.size.height)
		
		// ---------------- projection ----------------
		let projectionMatrix = Matrix(withPerspectiveFovy: 45.0, aspect: viewWidth/viewHeight, zNear: 0.1, zFar: 100.0)
		scene.setProjectionMatrix(projectionMatrix)
		
		// ---------------- view ----------------
		let viewMatrix = Matrix()
		viewMatrix.rotateY(angle: rotationY)
		viewMatrix.rotateX(angle: rotationX)
		viewMatrix.translate(x: 0.0, y: 0.0, z: zoom)
		scene.setViewMatrix(viewMatrix)
		//scene.setViewPosition(())
		
		//Swift.print(viewMatrix)
		
		// ---------------- lighting ----------------
		scene.setLightPosition((5.0, 5.0, 5.0))
		
		// ---------------- models ----------------
		var modelMatrix: Matrix
		
		modelMatrix = Matrix()
		modelMatrix.scale(factor: 2.5)
		modelMatrix.rotateX(angle: time*0.16)
		modelMatrix.rotateY(angle: time*0.8 + 2.0 * GLfloat.pi / 16)
		modelMatrix.translate(x: -5.0, y: 0.0, z: 0.0)
		scene.draw(model: cube, modelMatrix: modelMatrix)
		
		modelMatrix = Matrix()
		modelMatrix.scale(factor: 2.5)
		modelMatrix.rotateX(angle: time*0.16)
		modelMatrix.rotateY(angle: -time*0.8 + 2.0 * GLfloat.pi / 16)
		modelMatrix.translate(x: 5.0, y: 0.0, z: 0.0)
		scene.draw(model: cube, modelMatrix: modelMatrix)
		
//		modelMatrix = Matrix()
//		modelMatrix.scale(factor: 0.5)
//		modelMatrix.rotateY(angle: -time*0.8 + 2.0 * GLfloat.pi / 16)
//		scene.draw(model: teapot, modelMatrix: modelMatrix)
	}
	
	func iconScene() {
		
		let viewWidth = GLfloat(self.frame.size.width)
		let viewHeight = GLfloat(self.frame.size.height)
		
		scene.setClearColor(r: 0.0, g: 0.0, b: 0.0, a: 0.0)
		
		// ---------------- projection ----------------
		let projectionMatrix = Matrix(withPerspectiveFovy: 45.0, aspect: viewWidth/viewHeight, zNear: 0.1, zFar: 100.0)
		scene.setProjectionMatrix(projectionMatrix)
		
		// ---------------- view ----------------
		let viewMatrix = Matrix()
		viewMatrix.translate(x: 0.0, y: 0.0, z: -5.0)
		scene.setViewMatrix(viewMatrix)
		
		// ---------------- lighting ----------------
		scene.setLightPosition((5.0, 5.0, 5.0))
		
		// ---------------- models ----------------
		var modelMatrix: Matrix
		
		modelMatrix = Matrix()
		modelMatrix.scale(factor: 2.5)
		modelMatrix.rotateY(angle: -0.559596121)
		modelMatrix.rotateX(angle: 0.394672483)
		scene.draw(model: cube, modelMatrix: modelMatrix)
	}
	
	override func mouseDragged(with event: NSEvent) {
		let screenWidth = GLfloat(self.window!.screen!.visibleFrame.size.width)
		let screenHeight = GLfloat(self.window!.screen!.visibleFrame.size.height)
		
		rotationX += 2.0 * GLfloat.pi * GLfloat(event.deltaY) / screenHeight * 2.0
		rotationY += 2.0 * GLfloat.pi * GLfloat(event.deltaX) / screenWidth * 2.0
	}
	
	override func magnify(with event: NSEvent) {
		zoom = min(zoom + GLfloat(event.magnification) * 25.0, -5.0)
	}
	
}
