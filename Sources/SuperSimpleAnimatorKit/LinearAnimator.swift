//
//  LinearAnimator.swift
//  Animator
//
//  Created by Shane Whitehead on 24/8/18.
//  Copyright © 2018 KaiZen. All rights reserved.
//

import Foundation

public typealias LinearTicker = (LinearAnimator) -> Void

// MARK: LinearAnimation
// The intention of this class is to provide a "untimed" animation cycle,
// meaning that it will just keep on ticking, it has no duration.  Probably
// good for things like timers or animation cycles which don't know how
// long they need to keep running for
public protocol LinearAnimatorDelegate {
	func didTick(animation: LinearAnimator)
}

public class LinearAnimator: Animator {
	
	public var delegate: LinearAnimatorDelegate?
	
	internal var ticker: LinearTicker?
	
	public init(ticker: LinearTicker? = nil, tickEngine: TickEngine? = nil) {
		self.ticker = ticker
		super.init(tickEngine: tickEngine)
	}
	
	// Extension point
	override public func tick() {
		if let ticker = ticker {
			ticker(self)
		}
		delegate?.didTick(animation: self)
	}
	
}
