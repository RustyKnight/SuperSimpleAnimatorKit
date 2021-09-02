//
//  Anmator.swift
//  Animator
//
//  Created by Shane Whitehead on 24/8/18.
//  Copyright © 2018 KaiZen. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#else
import Cocoa
#endif

// MARK: Base animation
open class Animator: TickEngineDelegate {
	
	// Is it worth while making this optional?
	internal var tickEngine: TickEngine
	
	public init(tickEngine: TickEngine? = nil) {
		if let tickEngine = tickEngine {
			self.tickEngine = tickEngine
			tickEngine.delegate = self
		} else {
			#if os(macOS)
			self.tickEngine = TimerTickerEngine()
			#else
			self.tickEngine = DisplayLinkTickEngine()
			#endif
		}
		self.tickEngine.delegate = self
	}

	public var isRunning: Bool {
		return tickEngine.isRunning
	}
	
	open func start() {
		tickEngine.start()
	}
	
	internal func didStart() {
	}
	
	open func stop() {
		tickEngine.stop()
	}
	
	internal func didStop() {
	}
	
	// Extension point
	open func tick() {
		fatalError("Animation.tick not yey implemented")
	}
	
	public func didTick(engine: TickEngine) {
		tick()
	}
	
	public func didStart(engine: TickEngine) {
		didStart()
	}
	
	public func didStop(engine: TickEngine) {
		didStop()
	}

}

// MARK: Timing Function extensions
extension CAMediaTimingFunction {
	
	//static let easeInEaseOut = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
	
	public func getControlPoint(index: UInt) -> (x: CGFloat, y: CGFloat)? {
		switch index {
		case 0...3:
			let controlPoint = UnsafeMutablePointer<Float>.allocate(capacity: 2)
			self.getControlPoint(at: Int(index), values: controlPoint)
			let x: Float = controlPoint[0]
			let y: Float = controlPoint[1]
			controlPoint.deallocate()
			return (CGFloat(x), CGFloat(y))
		default:
			return nil
		}
	}
	
	public var controlPoints: [CGPoint] {
		var controlPoints = [CGPoint]()
		for index in 0..<4 {
			let controlPoint = UnsafeMutablePointer<Float>.allocate(capacity: 2)
			self.getControlPoint(at: Int(index), values: controlPoint)
			let x: Float = controlPoint[0]
			let y: Float = controlPoint[1]
			controlPoint.deallocate()
			controlPoints.append(CGPoint(x: CGFloat(x), y: CGFloat(y)))
		}
		return controlPoints
	}
	
	func value(atTime x: Double) -> Double {
		let cp = self.controlPoints
		// Look for t value that corresponds to provided x
		let a = Double(-cp[0].x+3*cp[1].x-3*cp[2].x+cp[3].x)
		let b = Double(3*cp[0].x-6*cp[1].x+3*cp[2].x)
		let c = Double(-3*cp[0].x+3*cp[1].x)
		let d = Double(cp[0].x)-x
		let t = rootOfCubic(a, b, c, d, x)
		
		// Return corresponding y value
		let y = cubicFunctionValue(Double(-cp[0].y+3*cp[1].y-3*cp[2].y+cp[3].y),
															 Double(3*cp[0].y-6*cp[1].y+3*cp[2].y),
															 Double(-3*cp[0].y+3*cp[1].y),
															 Double(cp[0].y), t)
		
		return y
	}
	
	private func rootOfCubic(_ a: Double, _ b: Double, _ c: Double, _ d: Double, _ startPoint: Double) -> Double {
		// We use 0 as start point as the root will be in the interval [0,1]
		var x = startPoint
		var lastX: Double = 1
		let kMaximumSteps = 10
		let kApproximationTolerance = 0.00000001
		
		// Approximate a root by using the Newton-Raphson method
		var y = 0
		while (y <= kMaximumSteps && fabs(lastX - x) > kApproximationTolerance) {
			lastX = x
			x = x - (cubicFunctionValue(a, b, c, d, x) / cubicDerivativeValue(a, b, c, d, x))
			y += 1
		}
		return x
	}
	
	private func cubicFunctionValue(_ a: Double, _ b: Double, _ c: Double, _ d: Double, _ x: Double) -> Double {
		return (a*x*x*x)+(b*x*x)+(c*x)+d
	}
	
	private func cubicDerivativeValue(_ a: Double, _ b: Double, _ c: Double, _ d: Double, _ x: Double) -> Double {
		/// Derivation of the cubic (a*x*x*x)+(b*x*x)+(c*x)+d
		return (3*a*x*x)+(2*b*x)+c
	}
}
