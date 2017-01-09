//
//  ExampleSceneView.swift
//  My Little Engine
//
//  Created by Jannik Theiß on 01.01.17.
//
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
		
		scene.setClearColor(color: (1.0, 0.41, 0.71), alpha: 0.1)
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
		scene.setViewPosition((zoom*sin(rotationY)*cos(rotationX), -zoom*sin(rotationX), -zoom*cos(rotationY)*cos(rotationX)))
		
		//Swift.print(viewMatrix)
		
		// ---------------- lighting ----------------
		//scene.setLightPosition((10.0*sin(time*0.4), 5.0, 10.0*cos(time*0.4)))
		scene.setLightPosition((5.0, 5.0, 5.0))
		
		// ---------------- models ----------------
		var modelMatrix: Matrix
		
		modelMatrix = Matrix()
		modelMatrix.scale(factor: 2.5)
		modelMatrix.rotateX(angle: time*0.16)
		modelMatrix.rotateY(angle: time*0.8 + 2.0 * GLfloat.pi / 16)
		modelMatrix.translate(x: -5.0, y: 0.0, z: 0.0)
		scene.draw(model: cube, modelMatrix: modelMatrix, color: (1.0, 0.5, 0.31))
		
		modelMatrix = Matrix()
		modelMatrix.scale(factor: 2.5)
		modelMatrix.rotateX(angle: time*0.16)
		modelMatrix.rotateY(angle: -time*0.8 + 2.0 * GLfloat.pi / 16)
		modelMatrix.translate(x: 5.0, y: 0.0, z: 0.0)
		scene.draw(model: sphere, modelMatrix: modelMatrix, color: (0.3, 0.3, 0.3))
		
		modelMatrix = Matrix()
		modelMatrix.scale(factor: 0.5)
		modelMatrix.rotateY(angle: -time*0.8 + 2.0 * GLfloat.pi / 16)
		scene.draw(model: teapot, modelMatrix: modelMatrix, color: (0.333, 0.569, 0.835))
	}
	
	func iconScene() {
		
		let viewWidth = GLfloat(self.frame.size.width)
		let viewHeight = GLfloat(self.frame.size.height)
		
		scene.setClearColor(color: (0.0, 0.0, 0.0), alpha: 0.0)
		
		// ---------------- projection ----------------
		let projectionMatrix = Matrix(withPerspectiveFovy: 45.0, aspect: viewWidth/viewHeight, zNear: 0.1, zFar: 100.0)
		scene.setProjectionMatrix(projectionMatrix)
		
		// ---------------- view ----------------
		let viewMatrix = Matrix()
		viewMatrix.translate(x: 0.0, y: 0.0, z: -5.0)
		scene.setViewMatrix(viewMatrix)
		scene.setViewPosition((0.0, 0.0, 5.0))
		
		// ---------------- lighting ----------------
		scene.setLightPosition((5.0, 5.0, 5.0))
		
		// ---------------- models ----------------
		var modelMatrix: Matrix
		
		modelMatrix = Matrix()
		modelMatrix.scale(factor: 2.5)
		modelMatrix.rotateY(angle: -0.559596121)
		modelMatrix.rotateX(angle: 0.394672483)
		scene.draw(model: cube, modelMatrix: modelMatrix, color: (1.0, 0.5, 0.31))
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
