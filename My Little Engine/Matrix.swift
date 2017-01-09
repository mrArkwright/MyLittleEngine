//
//  Matrix.swift
//  My Little Engine
//
//  Created by Jannik Theiß on 30.12.16.
//
//

import OpenGL

class Matrix: CustomStringConvertible {
	private (set) var values: [GLfloat]
	
	subscript(row: Int, column: Int) -> GLfloat {
		get {
			return values[column*4 + row]
		}
		set {
			values[column*4 + row] = newValue
		}
	}
	
	var description: String {
		return "\(self[0,0]), \(self[0,1]), \(self[0,2]), \(self[0,3])\n" +
		       "\(self[1,0]), \(self[1,1]), \(self[1,2]), \(self[1,3])\n" +
		       "\(self[2,0]), \(self[2,1]), \(self[2,2]), \(self[2,3])\n" +
		       "\(self[3,0]), \(self[3,1]), \(self[3,2]), \(self[3,3])\n"
	}
	
	// -------------------------------- initializers --------------------------------
	init() {
		values = [GLfloat](repeating: 0.0, count: 4 * 4)
		
		self[0,0] = 1.0
		self[1,1] = 1.0
		self[2,2] = 1.0
		self[3,3] = 1.0
	}
	
	init(withMatrix matrix: Matrix) {
		values = matrix.values
	}
	
	convenience init(withScale factor: GLfloat) {
		self.init()
		
		self[0,0] = factor
		self[1,1] = factor
		self[2,2] = factor
	}
	
	convenience init(withXRotation angle: GLfloat) {
		self.init()
		
		let sina = sin(angle)
		let cosa = cos(angle)
		
		self[1,1] = cosa
		self[1,2] = -sina
		self[2,1] = sina
		self[2,2] = cosa
	}
	
	convenience init(withYRotation angle: GLfloat) {
		self.init()
		
		let sina = sin(angle)
		let cosa = cos(angle)
		
		self[0,0] = cosa
		self[0,2] = sina
		self[2,0] = -sina
		self[2,2] = cosa
	}
	
	convenience init(WithTranslationX x: GLfloat, y: GLfloat, z: GLfloat) {
		self.init()
		
		self[0,3] = x;
		self[1,3] = y;
		self[2,3] = z;
	}
	
	convenience init(withPerspectiveFovy fovy: GLfloat, aspect: GLfloat, zNear: GLfloat, zFar: GLfloat) {
		self.init()
		
		let f = cos(fovy / 2.0) / sin(fovy / 2.0)
		
		self[0,0] = f / aspect
		self[1,1] = f
		self[2,2] = (zFar + zNear) / (zNear - zFar)
		self[2,3] = 2.0 * zFar * zNear / (zNear - zFar)
		self[3,2] = -1.0
		self[3,3] = 0.0
	}
	
	// -------------------------------- modifier --------------------------------
	func leftMultiply(with mult: Matrix) {
		let old = Matrix(withMatrix: self) // TODO: avoid copying
		
		for r in 0...3 {
			for c in 0...3 {
				self[r,c] = mult[r,0]*old[0,c] + mult[r,1]*old[1,c] + mult[r,2]*old[2,c] + mult[r,3]*old[3,c]
			}
		}
	}
	
	func scale(factor: GLfloat) {
		let scale = Matrix(withScale: factor)
		self.leftMultiply(with: scale)
	}
	
	func rotateX(angle: GLfloat) {
		let xRotation = Matrix(withXRotation: angle)
		self.leftMultiply(with: xRotation)
	}
	
	func rotateY(angle: GLfloat) {
		let yRotation = Matrix(withYRotation: angle)
		self.leftMultiply(with: yRotation)
	}
	
	func translate(x: GLfloat, y: GLfloat, z: GLfloat) {
		let translation = Matrix(WithTranslationX: x, y: y, z: z)
		self.leftMultiply(with: translation)
	}
}
