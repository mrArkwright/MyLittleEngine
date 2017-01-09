//
//  EngineOpenGLView.swift
//  My Little Engine
//
//  Created by Jannik Theiß on 25.12.16.
//
//

import Cocoa
import GLKit

class EngineOpenGLView: NSOpenGLView {
	
	var displayLink: CVDisplayLink?
	
	var scene: Scene!
	
	required init?(coder: NSCoder) {
		
		super.init(coder: coder)
		
		let pixelFormatAttributes:[NSOpenGLPixelFormatAttribute] = [
			UInt32(NSOpenGLPFAOpenGLProfile), UInt32(NSOpenGLProfileVersion3_2Core),
			UInt32(NSOpenGLPFAColorSize)    , 24                                    ,
			UInt32(NSOpenGLPFAAlphaSize)    , 8                                     ,
			UInt32(NSOpenGLPFADepthSize)    , 16                                    ,
			UInt32(NSOpenGLPFASamples)      , 16                                    , // anti aliasing
			UInt32(NSOpenGLPFASampleBuffers), 1                                     , // anti aliasing
			UInt32(NSOpenGLPFAMultisample)  ,                                         // anti aliasing
			UInt32(NSOpenGLPFADoubleBuffer) ,
			UInt32(NSOpenGLPFAAccelerated)  ,
			UInt32(NSOpenGLPFANoRecovery)   ,
			UInt32(0)
		]
		
		let pixelFormat = NSOpenGLPixelFormat(attributes: pixelFormatAttributes)!
		self.pixelFormat = pixelFormat
		
		let context = NSOpenGLContext(format: pixelFormat, share: nil)
		self.openGLContext = context
		
		self.openGLContext?.setValues([1], for: NSOpenGLCPSwapInterval)

		openGLContext!.makeCurrentContext()
		
		let shaderDirectory = Bundle.main.resourcePath! + "/Shaders"		
		guard let _scene = Scene(shaderDirectory: shaderDirectory) else {
			return nil
		}
		scene = _scene
	}
	
	override func prepareOpenGL() {
		
		func displayLinkOutputCallback(displayLink: CVDisplayLink, _ inNow: UnsafePointer<CVTimeStamp>, _ inOutputTime: UnsafePointer<CVTimeStamp>, _ flagsIn: CVOptionFlags, _ flagsOut: UnsafeMutablePointer<CVOptionFlags>, _ displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn {
			
			unsafeBitCast(displayLinkContext, to: EngineOpenGLView.self).renderFrame()
			
			return kCVReturnSuccess
		}
		
		CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
		CVDisplayLinkSetOutputCallback(displayLink!, displayLinkOutputCallback, unsafeBitCast(self, to: UnsafeMutableRawPointer.self))
		CVDisplayLinkStart(displayLink!)
		
	}
	
	func renderFrame() {
		
		let context = self.openGLContext!
		
		context.makeCurrentContext()
		CGLLockContext(context.cglContextObj!)
		
		let time = Float(1.00 * CACurrentMediaTime())
		
		scene.clear()
		drawScene(time: time)
		
		if (showDebug) {
			scene.drawAxes()
			scene.drawLightPosition()
		}
		
		CGLFlushDrawable(context.cglContextObj!)
		CGLUnlockContext(context.cglContextObj!)
	}
	
	var showDebug: Bool = false {
		didSet {
			scene.setWiredMode(showDebug)
		}
	}
	
	func setBackgroundTransparency(_ transparency: Bool) {
		let value: Int32 = transparency ? 0 : 1
		openGLContext!.setValues([value], for: NSOpenGLCPSurfaceOpacity)
	}
	
	// override in subclass to draw scene
	func drawScene(time: Float) {
	}
	
	func screenshot() -> NSImage {
		let width = Int(self.visibleRect.width)
		let height = Int(self.visibleRect.height)
		
		let flippedBuffer = unsafeBitCast(malloc(width * height * 4)!, to: UnsafeMutablePointer<UInt32>.self)
		let buffer = unsafeBitCast(malloc(width * height * 4)!, to: UnsafeMutablePointer<UInt32>.self)
		
		glReadPixels(0, 0, GLsizei(width), GLsizei(height), GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), flippedBuffer)
		
		for y in 0...(height - 1) {
			for x in 0...(width - 1) {
				buffer[y * width + x] = flippedBuffer[(height - 1 - y) * width + x]
			}
		}
		
		free(flippedBuffer)
		
		let provider = CGDataProvider(dataInfo: UnsafeMutableRawPointer(bitPattern: 0), data: buffer, size: width * height * 4) { _, data, _ in
			free(unsafeBitCast(data, to: UnsafeMutableRawPointer.self))
		}
		
		let colorSpace = self.window!.colorSpace!.cgColorSpace!
		let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue)
		let cgImage = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: 4*width, space: colorSpace, bitmapInfo: bitmapInfo, provider: provider!, decode: nil, shouldInterpolate: false, intent: .defaultIntent)!
		
		let imageBitmapRep = NSBitmapImageRep(cgImage: cgImage)
		let sRGBImageBitmapRep = imageBitmapRep.converting(to: NSColorSpace.sRGB, renderingIntent: .default)!
		
		let image = NSImage(size: NSSize(width: width, height: height))
		image.addRepresentation(sRGBImageBitmapRep)
		
		return image
	}

	
	deinit {
		if let displayLink = self.displayLink {
			CVDisplayLinkStop(displayLink)
		}
	}
	
}
