//
//  LightingShaderProgram.swift
//  My Little Engine
//
//  Created by Jannik Theiß on 01.01.17.
//  Copyright © 2017 Exceptional Eye Staring. All rights reserved.
//

import OpenGL

// TODO: Phong lighting
// TODO: Colors, Textures, Light Color
class LightingShaderProgram: ShaderProgram {
	
	var lightPositionUniform: GLint!
//	var viewPositionUniform: GLint!
	
	var normalAttribute: GLuint!
	
	override init?(pathBase: String) {
		super.init(pathBase: pathBase)
		
		lightPositionUniform = GLint(glGetUniformLocation(shaderProgram, "lightPosition"))
//		viewPositionUniform = GLint(glGetUniformLocation(shaderProgram, "viewPosition"))
		
		normalAttribute = GLuint(glGetAttribLocation(shaderProgram, "normal"))
	}
	
	func setLightPosition(_ position: Vertex) {
		glUseProgram(shaderProgram)
		glUniform3f(lightPositionUniform, position.0, position.1, position.2)
	}
	
//	func setViewPosition(_ position: Vertex) {
//		glUseProgram(shaderProgram)
//		glUniform3f(viewPositionUniform, position.0, position.1, position.2)
//	}
	
	func draw(model: Model, modelMatrix: Matrix, color: Color) {
		
		glUseProgram(shaderProgram)
		
		glUniformMatrix4fv(modelUniform, 1, GLboolean(GL_FALSE), modelMatrix.values)
		
		glUniform3f(vertexColorUniform, color.red, color.green, color.blue)
		
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), model.vertexBufferObject);
		glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), model.elementBufferObject);
		
		glEnableVertexAttribArray(positionAttribute)
		glVertexAttribPointer(positionAttribute, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(6*MemoryLayout<GLfloat>.size), UnsafeRawPointer(bitPattern: 0))
		
		glEnableVertexAttribArray(normalAttribute)
		glVertexAttribPointer(normalAttribute, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(6*MemoryLayout<GLfloat>.size), UnsafeRawPointer(bitPattern: 3 * MemoryLayout<GLfloat>.size))
		
		glDrawElements(GLenum(GL_TRIANGLES), GLsizei(model.indices.count), GLenum(GL_UNSIGNED_INT), UnsafeRawPointer(bitPattern: 0))
	}
	
}
