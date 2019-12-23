//
//  ResetDurationAnimator.swift
//  OTAAnimationTest
//
//  Created by Shane Whitehead on 22/12/19.
//  Copyright © 2019 Shane Whitehead. All rights reserved.
//

import Foundation

open class ReverseDurationAnimator: DurationAnimator {
	
	internal var isReversed: Bool = false
	
	override var rawProgress: Double {
		let actualProgress = super.rawProgress
		guard isReversed else { return actualProgress }
		
		let reversed = min(1.0, max(0.0001, 1.0 - actualProgress))
		return reversed
	}
	
	public init(duration: TimeInterval, ticker: DurationTicker? = nil, then: AnimationCompleted? = nil) {
		super.init(duration: duration, timingFunction: Curve.easeInEaseOut, repeats: true, ticker: ticker, then: then)
	}
	
	override func afterTick() {
		if super.rawProgress >= 1.0 {
			isReversed = !isReversed
			restart()
		}
	}
}
