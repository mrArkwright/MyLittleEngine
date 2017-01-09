//
//  Scene.swift
//  My Little Engine
//
//  Created by Jannik Theiß on 03.01.17.
//
//

import OpenGL

class Scene {
	
	let primitiveShader: SimpleShaderProgram
	let lightingShader: LightingShaderProgram
	
	private var lightPosition: Vertex?
	
	init?(shaderDirectory: String) {
		
		glEnable(GLenum(GL_DEPTH_TEST))
		glEnable(GLenum(GL_MULTISAMPLE))
		glEnable(GLenum(GL_CULL_FACE))
		
//		glEnable(GLenum(GL_BLEND))
//		glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
		
		guard let _primitiveShader = SimpleShaderProgram(pathBase: shaderDirectory + "/simple") else {
			Swift.print("Error compiling primitive shader program.\n")
			return nil
		}
		primitiveShader = _primitiveShader
		
		guard let _lightingShader = LightingShaderProgram(pathBase: shaderDirectory + "/lighting") else {
				Swift.print("Error compiling lighting shader program.\n")
				return nil
		}
		lightingShader = _lightingShader
		
		
		var vertexArrayObject: GLuint = GLuint()
		glGenVertexArrays(1, &vertexArrayObject)
		glBindVertexArray(vertexArrayObject)
	}
	
	func setClearColor(r: GLfloat, g: GLfloat, b: GLfloat, a: GLfloat) { // TODO: use NSColor?
		glClearColor(r, g, b, a)
	}
	
	func clear() {
		glClear(GLenum(GL_COLOR_BUFFER_BIT) | GLenum(GL_DEPTH_BUFFER_BIT))
	}
	
	func setProjectionMatrix(_ projectionMatrix: Matrix) {
		primitiveShader.setProjectionMatrix(projectionMatrix)
		lightingShader.setProjectionMatrix(projectionMatrix)
	}
	
	func setViewMatrix(_ viewMatrix: Matrix) {
		primitiveShader.setViewMatrix(viewMatrix)
		lightingShader.setViewMatrix(viewMatrix)
	}
	
	func setLightPosition(_ position: Vertex) {
		lightingShader.setLightPosition(position)
		lightPosition = position
	}
	
//	func setViewPosition(_ position: Vertex) {
//		lightingShader.setViewPosition(position)
//	}
	
	func drawPoints(vertices: Vertices, modelMatrix: Matrix, size: GLfloat) {
		primitiveShader.drawPoints(vertices: vertices, modelMatrix: modelMatrix, size: size)
	}
	
	func drawPoints(model: Model, modelMatrix: Matrix, size: GLfloat) {
		primitiveShader.drawPoints(model: model, modelMatrix: modelMatrix, size: size)
	}
	
	func drawLines(vertices: Vertices, modelMatrix: Matrix) {
		primitiveShader.drawLines(vertices: vertices, modelMatrix: modelMatrix)
	}
	
	func drawLines(model: Model, modelMatrix: Matrix) {
		primitiveShader.drawLines(model: model, modelMatrix: modelMatrix)
	}
	
	func draw(model: Model, modelMatrix: Matrix) {
		lightingShader.draw(model: model, modelMatrix: modelMatrix)
	}
	
	func drawAxes() {
		let size: GLfloat = 25.0
		
		drawLines(vertices: [(-size, 0.0, 0.0), (size, 0.0, 0.0)], modelMatrix: Matrix())
		drawLines(vertices: [(0.0, -size, 0.0), (0.0, size, 0.0)], modelMatrix: Matrix())
		drawLines(vertices: [(0.0, 0.0, -size), (0.0, 0.0, size)], modelMatrix: Matrix())
	}
	
	func drawLightPosition() {
		if let lightPosition = self.lightPosition {
			drawPoints(vertices: [lightPosition], modelMatrix: Matrix(), size: 10.0)
		}
	}
	
	func setWiredMode(_ wired: Bool) {
		if wired {
			glPolygonMode(GLenum(GL_FRONT_AND_BACK), GLenum(GL_LINE))
		} else {
			glPolygonMode(GLenum(GL_FRONT_AND_BACK), GLenum(GL_FILL))
		}
	}
	
	
}
