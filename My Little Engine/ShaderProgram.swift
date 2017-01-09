//
//  ShaderProgram.swift
//  My Little Engine
//
//  Created by Jannik Theiß on 29.12.16.
//
//

import OpenGL

class ShaderProgram {
	
	let shaderProgram: GLuint
	
	let modelUniform: GLint
	let viewUniform: GLint
	let projectionUniform: GLint
	let vertexColorUniform: GLint
	
	let positionAttribute: GLuint
	
	init?(pathBase: String) {
		
		guard let vertexShader = Shader(path: pathBase + "Vertex.glsl", type: GLenum(GL_VERTEX_SHADER)) else {
			Swift.print("Error compiling vertex shader.\n")
			return nil
		}
		
		guard let fragmentShader = Shader(path: pathBase + "Fragment.glsl", type: GLenum(GL_FRAGMENT_SHADER)) else {
			Swift.print("Error compiling fragment shader.\n")
			return nil
		}
		
		// link shaders
		shaderProgram = glCreateProgram()
		glAttachShader(shaderProgram, vertexShader.shader)
		glAttachShader(shaderProgram, fragmentShader.shader)
		glLinkProgram(shaderProgram)
		
		// get attribute and uniform locations
		modelUniform = GLint(glGetUniformLocation(shaderProgram, "model"))
		viewUniform = GLint(glGetUniformLocation(shaderProgram, "view"))
		projectionUniform = GLint(glGetUniformLocation(shaderProgram, "projection"))
		vertexColorUniform = GLint(glGetUniformLocation(shaderProgram, "vertexColor"))
		
		positionAttribute = GLuint(glGetAttribLocation(shaderProgram, "position"))
	}
	
	func setProjectionMatrix(_ projectionMatrix: Matrix) {
		glUseProgram(shaderProgram)
		glUniformMatrix4fv(projectionUniform, 1, GLboolean(GL_FALSE), projectionMatrix.values)
	}
	
	func setViewMatrix(_ viewMatrix: Matrix) {
		glUseProgram(shaderProgram)
		glUniformMatrix4fv(viewUniform, 1, GLboolean(GL_FALSE), viewMatrix.values)
	}
	
}
