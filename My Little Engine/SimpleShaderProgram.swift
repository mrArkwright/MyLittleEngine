//
//  SimpleShaderProgram.swift
//  My Little Engine
//
//  Created by Jannik Theiß on 01.01.17.
//
//

import OpenGL

class SimpleShaderProgram: ShaderProgram {
	
	private func draw(vertices: Vertices, modelMatrix: Matrix, color: Color, mode: GLenum) {
		glUseProgram(shaderProgram)
		
		glUniformMatrix4fv(modelUniform, 1, GLboolean(GL_FALSE), modelMatrix.values)
		
		glUniform3f(vertexColorUniform, color.red, color.green, color.blue)
		
		var vertexBufferObject: GLuint = GLuint()
		glGenBuffers(1, &vertexBufferObject);
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBufferObject)
		glBufferData(GLenum(GL_ARRAY_BUFFER), vertices.count * 3 * MemoryLayout<GLfloat>.size, vertices, GLenum(GL_STATIC_DRAW))
		
		glEnableVertexAttribArray(positionAttribute)
		glVertexAttribPointer(positionAttribute, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(3*MemoryLayout<GLfloat>.size), UnsafeRawPointer(bitPattern: 0))
		
		glDrawArrays(mode, 0, GLsizei(vertices.count));
		
		glDeleteBuffers(1, &vertexBufferObject)
	}
	
	private func draw(model: Model, modelMatrix: Matrix, color: Color, mode: GLenum) {
		glUseProgram(shaderProgram)
		
		glUniformMatrix4fv(modelUniform, 1, GLboolean(GL_FALSE), modelMatrix.values)
		
		glUniform3f(vertexColorUniform, color.red, color.green, color.blue)
		
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), model.vertexBufferObject);
		glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), model.elementBufferObject);
		
		glEnableVertexAttribArray(positionAttribute)
		glVertexAttribPointer(positionAttribute, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(6*MemoryLayout<GLfloat>.size), UnsafeRawPointer(bitPattern: 0))
		
		glDrawElements(mode, GLsizei(model.indices.count), GLenum(GL_UNSIGNED_INT), UnsafeRawPointer(bitPattern: 0))
	}
	
	func drawPoints(vertices: Vertices, modelMatrix: Matrix, color: Color, size: GLfloat) {
		glPointSize(size)
		draw(vertices: vertices, modelMatrix: modelMatrix, color: color, mode: GLenum(GL_POINTS))
	}
	
	func drawPoints(model: Model, modelMatrix: Matrix, color: Color, size: GLfloat) {
		glPointSize(size)
		draw(model: model, modelMatrix: modelMatrix, color: color, mode: GLenum(GL_POINTS))
	}
	
	func drawLines(vertices: Vertices, modelMatrix: Matrix, color: Color) {
		draw(vertices: vertices, modelMatrix: modelMatrix, color: color, mode: GLenum(GL_LINES))
	}
	
	func drawLines(model: Model, modelMatrix: Matrix, color: Color) {
		draw(model: model, modelMatrix: modelMatrix, color: color, mode: GLenum(GL_LINES))
	}
	
}
