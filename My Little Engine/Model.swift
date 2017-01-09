//
//  Model.swift
//  My Little Engine
//
//  Created by Jannik Theiß on 31.12.16.
//
//

import OpenGL

class Model {
	
	let vertices: NVertices
	let indices: Indices
	
	let vertexBufferObject: GLuint
	let elementBufferObject: GLuint
	
	init(withVertices _vertices: NVertices, indices _indices: Indices) {
		vertices = _vertices
		indices = _indices
		
		var _vertexBufferObject = GLuint()
		glGenBuffers(1, &_vertexBufferObject)
		vertexBufferObject = _vertexBufferObject
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBufferObject)
		glBufferData(GLenum(GL_ARRAY_BUFFER), vertices.count * 6 * MemoryLayout<GLfloat>.size, vertices, GLenum(GL_STATIC_DRAW))
		
		var _elementBufferObject = GLuint()
		glGenBuffers(1, &_elementBufferObject)
		elementBufferObject = _elementBufferObject
		glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), elementBufferObject)
		glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.count * MemoryLayout<GLuint>.size, indices, GLenum(GL_STATIC_DRAW))
	}
	
	// TODO: optimize for indexed buffering
	// TODO: handle parse errors and unsupported wavefront features
	convenience init(wavefrontFile path: String) {
		var vertices: Vertices = []
		var normals: Vertices = []
		var nVertices: NVertices = []
		var indices: Indices = []
		
		let fileContent = try! String(contentsOfFile: path, encoding: .utf8)
		fileContent.enumerateLines { line, _ in
			
			let words = line.characters.split(separator: " ").map(String.init)
			
			if words.count > 0 {
				switch words[0] {
					
				case "v":
					let vertex = (GLfloat(words[1])!, GLfloat(words[2])!, GLfloat(words[3])!)
					vertices.append(vertex)
					
				case "vn":
					let normal = (GLfloat(words[1])!, GLfloat(words[2])!, GLfloat(words[3])!)
					normals.append(normal)
					
				case "f":
					for i in 1...3 {
						let nVertexIndices = words[i].characters.split(separator: "/", omittingEmptySubsequences: false).map(String.init)
						
						var vertex: Vertex
						var normal: Normal
						
						vertex = vertices[Int(nVertexIndices[0])! - 1]
						normal = normals[Int(nVertexIndices[2])! - 1]
						
						indices.append(Index(nVertices.count))
						nVertices.append((vertex, normal))
					}
					
				default: break
				}
			}
		}
		
		self.init(withVertices: nVertices, indices: indices)
	}
	
	deinit {
		glDeleteBuffers(1, [vertexBufferObject])
		glDeleteBuffers(1, [elementBufferObject])
	}
	
}
