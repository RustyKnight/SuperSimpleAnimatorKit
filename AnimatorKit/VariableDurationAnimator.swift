//
//  VariableDurationAnimator.swift
//  OTAAnimationTest
//
//  Created by Shane Whitehead on 24/12/19.
//  Copyright © 2019 Shane Whitehead. All rights reserved.
//

import Foundation

open class VariableDurationAnimator: DurationAnimator {
	
	let estimatedDuration: TimeInterval

	public override init(duration: TimeInterval, timingFunction: Curve? = nil, repeats: Bool = false, ticker: DurationTicker? = nil, then: AnimationCompleted? = nil) {
		estimatedDuration = duration
		super.init(duration: duration, timingFunction: timingFunction, repeats: repeats, ticker: ticker, then: then)
	}

	/*
	This will adjust the overall duration of the animator
	based on the estimated duration so that it matches the sepecified
	progression.
	
	It will also adjust the running time so the animator matches the specified
	progress
	*/
	public func adjustDuration(forProgress progress: Double) {
		let diff = estimatedTime(at: progress) - duration
		duration = estimatedDuration - diff
		
		let target = duration * progress
		startedAt = Date().addingTimeInterval(-target)
	}
	
	func estimatedTime(at point: Double) -> TimeInterval {
		return estimatedDuration * point
	}

}
