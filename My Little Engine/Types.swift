//
//  Types.swift
//  My Little Engine
//
//  Created by Jannik Theiß on 09.01.17.
//
//

import OpenGL

typealias Vertex = (x: GLfloat, y: GLfloat, z: GLfloat)
typealias Normal = (x: GLfloat, y: GLfloat, z: GLfloat)
typealias Vertices = [Vertex]
typealias NVertices = [(Vertex, Normal)]

typealias Index = GLuint
typealias Indices = [Index]

typealias Color = (red: GLfloat, green: GLfloat, blue: GLfloat)
