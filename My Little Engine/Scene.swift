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
	
	func setClearColor(color: Color, alpha: GLfloat) {
		glClearColor(color.red, color.green, color.blue, alpha)
	}
	
	func clear() {
		glClear(GLenum(GL_COLOR_BUFFER_BIT) | GLenum(GL_DEPTH_BUFFER_BIT))
	}
	
	func setProjection(withPerspectiveFovy fovy: GLfloat, aspect: GLfloat, zNear: GLfloat, zFar: GLfloat) {
		let projectionMatrix = Matrix(withPerspectiveFovy: fovy, aspect: aspect, zNear: zNear, zFar: zFar)
		primitiveShader.setProjectionMatrix(projectionMatrix)
		lightingShader.setProjectionMatrix(projectionMatrix)
	}
	
	private func setViewMatrix(_ viewMatrix: Matrix) {
		primitiveShader.setViewMatrix(viewMatrix)
		lightingShader.setViewMatrix(viewMatrix)
	}
	
	private func setViewPosition(_ position: Vertex) {
		lightingShader.setViewPosition(position)
	}
	
	func setCamera(withRadius radius: GLfloat, azimuthAngle: GLfloat, elevationAngle: GLfloat) {
		
		let viewMatrix = Matrix()
		viewMatrix.rotateY(angle: azimuthAngle)
		viewMatrix.rotateX(angle: elevationAngle)
		viewMatrix.translate(x: 0.0, y: 0.0, z: -radius)
		self.setViewMatrix(viewMatrix)
		
		self.setViewPosition((-radius*sin(azimuthAngle)*cos(elevationAngle), radius*sin(elevationAngle), radius*cos(azimuthAngle)*cos(elevationAngle)))
	}
	
	func setLightPosition(_ position: Vertex) {
		lightingShader.setLightPosition(position)
		lightPosition = position
	}
	
	func drawPoints(vertices: Vertices, modelMatrix: Matrix, size: GLfloat, color: Color) {
		primitiveShader.drawPoints(vertices: vertices, modelMatrix: modelMatrix, color: color, size: size)
	}
	
	func drawPoints(model: Model, modelMatrix: Matrix, size: GLfloat, color: Color) {
		primitiveShader.drawPoints(model: model, modelMatrix: modelMatrix, color: color, size: size)
	}
	
	func drawLines(vertices: Vertices, modelMatrix: Matrix, color: Color) {
		primitiveShader.drawLines(vertices: vertices, modelMatrix: modelMatrix, color: color)
	}
	
	func drawLines(model: Model, modelMatrix: Matrix, color: Color) {
		primitiveShader.drawLines(model: model, modelMatrix: modelMatrix, color: color)
	}
	
	func draw(model: Model, modelMatrix: Matrix, color: Color) {
		lightingShader.draw(model: model, modelMatrix: modelMatrix, color: color)
	}
	
	func drawAxes() {
		let size: GLfloat = 25.0
		let color: Color = (1.0, 1.0, 1.0)
		
		drawLines(vertices: [(-size, 0.0, 0.0), (size, 0.0, 0.0)], modelMatrix: Matrix(), color: color)
		drawLines(vertices: [(0.0, -size, 0.0), (0.0, size, 0.0)], modelMatrix: Matrix(), color: color)
		drawLines(vertices: [(0.0, 0.0, -size), (0.0, 0.0, size)], modelMatrix: Matrix(), color: color)
	}
	
	func drawLightPosition() {
		if let lightPosition = self.lightPosition {
			drawPoints(vertices: [lightPosition], modelMatrix: Matrix(), size: 10.0, color: (1.0, 1.0, 1.0))
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
