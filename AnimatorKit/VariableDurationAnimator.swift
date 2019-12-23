//
//  VariableDurationAnimator.swift
//  OTAAnimationTest
//
//  Created by Shane Whitehead on 24/12/19.
//  Copyright © 2019 Shane Whitehead. All rights reserved.
//

import Foundation

open class VariableDurationAnimator: DurationAnimator {

	public override init(duration: TimeInterval, timingFunction: Curve? = nil, repeats: Bool = false, ticker: DurationTicker? = nil, then: AnimationCompleted? = nil) {
		super.init(duration: duration, timingFunction: timingFunction, repeats: repeats, ticker: ticker, then: then)
	}

	open func adjust(progress: Double) {
		let target = duration * progress
		startedAt = Date().addingTimeInterval(-target)
	}

}
