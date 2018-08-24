//
//  DurationAnimator.swift
//  Animator
//
//  Created by Shane Whitehead on 24/8/18.
//  Copyright © 2018 KaiZen. All rights reserved.
//

import Foundation
import UIKit

// MARK: DurationAnimation
// An animation with a specific time frame to run in
public protocol DurationAnimatorDelegate {
	func didTick(animation: DurationAnimator, progress: Double)
	func didComplete(animation: DurationAnimator, completed: Bool)
}

public class DurationAnimator: Animator {
	
	public var delegate: DurationAnimatorDelegate?
	
	internal var duration: TimeInterval // How long the animation should play for
	internal var startedAt: Date? // When the animation was started
	
	internal var timingFunction: CAMediaTimingFunction?
	
	internal var rawProgress: Double {
		guard let startedAt = startedAt else {
			return 0.0
		}
		let runningTime = Date().timeIntervalSince(startedAt)
		return runningTime / duration
	}
	
	internal var progress: Double {
		let value = rawProgress
		guard let timingFunction = timingFunction else {
			return value
		}
		return timingFunction.value(atTime: value)
	}
	
	public init(duration: TimeInterval, timingFunction: CAMediaTimingFunction? = nil) {
		self.duration = duration
		self.timingFunction = timingFunction
		super.init()
	}
	
	override public func tick() {
		guard let startedAt = startedAt else {
			return
		}
		defer {
			if rawProgress >= 1.0 {
				stop()
			}
		}
		let progress = self.progress
		delegate?.didTick(animation: self, progress: progress)
	}
	
	override func didStart() {
		startedAt = Date()
	}
	
	override func didStop() {
		delegate?.didComplete(animation: self, completed: rawProgress >= 1.0)
		startedAt = nil
	}
	
}
