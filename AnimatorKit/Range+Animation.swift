//
//  Range+Animation.swift
//  Animator
//
//  Created by Shane Whitehead on 24/8/18.
//  Copyright © 2018 KaiZen. All rights reserved.
//

import Foundation
import UIKit


internal func double(min: Double, max: Double, at point: Double, reversed: Bool = false) -> Double {
	let from = reversed ? max : min
	let to = reversed ? min : max
	
	let distant = to - from
	return (distant * point) + from
}

internal func double(in range: Range<Double>, at point: Double, reversed: Bool = false) -> Double {
	return double(min: range.lowerBound, max: range.upperBound, at: point, reversed: reversed)
}

internal func double(in range: ClosedRange<Double>, at point: Double, reversed: Bool = false) -> Double {
	return double(min: range.lowerBound, max: range.upperBound, at: point, reversed: reversed)
}

// MARK: Animatable range helpers
// These extensions provide a useful place to perform some "animation" calculations
// They can be used to calculate the current value between two points based on
// a given progression point
public extension Range where Bound == Double {
	public func value(at point: Double, reversed: Bool = false) -> Double {
		return double(in: self, at: point, reversed: reversed)
	}
}

public extension ClosedRange where Bound == Double {
	public func value(at point: Double, reversed: Bool = false) -> Double {
		return double(in: self, at: point, reversed: reversed)
	}
}

internal func int(min: Int, max: Int, at point: Double, reversed: Bool = false) -> Int {
	let from = reversed ? max : min
	let to = reversed ? min : max
	
	let distant = to - from
	return Int(round((Double(distant) * point))) + from}

internal func int(in range: Range<Int>, at point: Double, reversed: Bool = false) -> Int {
	return int(min: range.lowerBound, max: range.upperBound, at: point, reversed: reversed)
}

internal func int(in range: ClosedRange<Int>, at point: Double, reversed: Bool = false) -> Int {
	return int(min: range.lowerBound, max: range.upperBound, at: point, reversed: reversed)
}

public extension Range where Bound == Int {
	func value(at point: Double, reversed: Bool = false) -> Int {
		return int(in: self, at: point, reversed: reversed)
	}
}

public extension ClosedRange where Bound == Int {
	public func value(at point: Double, reversed: Bool = false) -> Int {
		return int(in: self, at: point, reversed: reversed)
	}
}
