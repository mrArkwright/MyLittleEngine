//
//  Shader.swift
//  My Little Engine
//
//  Created by Jannik Theiß on 07.01.17.
//
//

import OpenGL

class Shader {
	
	let shader: GLuint
	
	init?(path: String, type: GLenum) {
		
		guard let src = try? String(contentsOfFile: path, encoding: .utf8) else {
			Swift.print("Couldn't load shader: \(path)\n")
			return nil
		}
		
		shader = glCreateShader(type)
		glShaderSource(shader, 1, [src._bridgeToObjectiveC().utf8String], nil)
		glCompileShader(shader)
		
		var isCompiled: GLint = 0;
		glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &isCompiled);
		
		if (isCompiled == GL_FALSE) {
			var length: GLint = 0;
			glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &length);
			
			let errorLog = unsafeBitCast(malloc(Int(length) * MemoryLayout<GLchar>.size), to:UnsafeMutablePointer<GLchar>.self)
			glGetShaderInfoLog(shader, length, &length, errorLog)
			
			Swift.print(String(cString: errorLog)) // TODO: proper logging
			
			free(errorLog)
			
			glDeleteShader(shader)
			
			return nil
		}
	}
	
	deinit {
		glDeleteShader(shader)
	}
}
