//
//  File.swift
//  File
//
//  Created by Shane Whitehead on 2/9/21.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#else
import Cocoa
#endif

public protocol TickEngineDelegate: AnyObject {
	func didTick(engine: TickEngine)
	func didStart(engine: TickEngine)
	func didStop(engine: TickEngine)
}

public protocol TickEngine: AnyObject {
	var delegate: TickEngineDelegate? {get set}

	var isPaused: Bool { get set }
	var isRunning: Bool { get }
	
	func start()
	func stop()
}

#if os(iOS) || os(tvOS) || os(watchOS)
open class DisplayLinkTickEngine: NSObject, TickEngine {

	public weak var delegate: TickEngineDelegate? {
		didSet {
			if delegate == nil {
				stop()
			}
		}
	}
	
	public var isRunning: Bool {
		return displayLink != nil
	}
	
	public var isPaused: Bool = false {
		didSet {
			displayLink?.isPaused = isPaused
		}
	}
	
	internal var displayLink: CADisplayLink?
	
	// This can be changed BETWEEN runs, but won't effect running animators
	public var runLoop: RunLoop = .current
	public var runLoopMode: RunLoop.Mode = .common
	
	open func start() {
		guard displayLink == nil else {
			return
		}
		displayLink = CADisplayLink(target: self, selector: #selector(displayLinkTick(_:)))
		displayLink?.preferredFramesPerSecond = 60
		displayLink?.add(to: runLoop, forMode: runLoopMode)
		displayLink?.isPaused = false

		delegate?.didStart(engine: self)
	}
	
	open func stop() {
		guard let displayLink = displayLink else {
			return
		}
		displayLink.isPaused = true
		displayLink.remove(from: .current, forMode: RunLoop.Mode.default)
		self.displayLink = nil
		
		delegate?.didStop(engine: self)
	}
	
	@objc func displayLinkTick(_ displayLink: CADisplayLink) {
		delegate?.didTick(engine: self)
	}

}
#endif

#if os(macOS)
open class TimerTickerEngine: NSObject, TickEngine {

	public weak var delegate: TickEngineDelegate? {
		didSet {
			if delegate == nil {
				stop()
			}
		}
	}
	
	public var isRunning: Bool {
		return isPaused || timer != nil
	}
	
	public var isPaused: Bool = false {
		didSet {
			if isPaused {
				timer?.invalidate()
				timer = nil
			} else {
				start()
			}
		}
	}

	internal var timer: Timer?
	
	public private(set) var refreshRate: TimeInterval = 0.016
	
	public init(refreshRate: TimeInterval = 0.016) {
		self.refreshRate = refreshRate
	}

	public func start() {
		guard timer == nil else {
			return
		}
		timer = Timer.scheduledTimer(timeInterval: refreshRate, target: self, selector: #selector(didTick(_:)), userInfo: nil, repeats: true)
		
		delegate?.didStart(engine: self)
	}
	
	public func stop() {
		guard let timer = timer else {
			return
		}
		timer.invalidate()
		self.timer = nil
		
		delegate?.didStop(engine: self)
	}
	
	@objc func didTick(_ timer: Timer) {
		delegate?.didTick(engine: self)
	}
}
#endif
