//
//  VariableDurationAnimator.swift
//  OTAAnimationTest
//
//  Created by Shane Whitehead on 24/12/19.
//  Copyright © 2019 Shane Whitehead. All rights reserved.
//

import Foundation

open class VariableDurationAnimator: DurationAnimator {
	
	public var isPaused: Bool {
		set {
			if newValue && !isRunning {
				start()
				return
			}
			displayLink?.isPaused = newValue
		}
		
		get {
			displayLink?.isPaused ?? false
		}
	}

	public override init(duration: TimeInterval, timingFunction: Curve? = nil, repeats: Bool = false, ticker: DurationTicker? = nil, then: AnimationCompleted? = nil) {
		super.init(duration: duration, timingFunction: timingFunction, repeats: repeats, ticker: ticker, then: then)
	}
	
	override func didStart() {
		guard startedAt == nil else { return }
		startedAt = Date()
	}
	
	public func adjust(duration: TimeInterval, progress: Double) {
		let wasRunning = isRunning
		if wasRunning {
			displayLink?.isPaused = true
		}
		
		// Set the desired duration
		self.duration = duration
		// Calculate the amount of time used
		let used = duration * progress

		// Adjust the the anchor time
		startedAt = Date().addingTimeInterval(-used)

		guard wasRunning else { return }
		displayLink?.isPaused = false
	}

}
