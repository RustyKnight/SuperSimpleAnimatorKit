//
//  CGFloat+Animation+Range.swift
//  AnimatorKit
//
//  Created by Shane Whitehead on 1/12/18.
//  Copyright © 2018 KaiZen. All rights reserved.
//

import Foundation


internal func cgfloat(min: CGFloat, max: CGFloat, at point: Double, reversed: Bool = false) -> CGFloat {
  let from = reversed ? max : min
  let to = reversed ? min : max
  
  let distant = to - from
  return (distant * CGFloat(point)) + from
}

internal func cgfloat(in range: Range<CGFloat>, at point: Double, reversed: Bool = false) -> CGFloat {
  return cgfloat(min: range.lowerBound, max: range.upperBound, at: point, reversed: reversed)
}

internal func cgfloat(in range: ClosedRange<CGFloat>, at point: Double, reversed: Bool = false) -> CGFloat {
  return cgfloat(min: range.lowerBound, max: range.upperBound, at: point, reversed: reversed)
}

public extension Range where Bound == CGFloat {
  func value(at point: Double, reversed: Bool = false) -> CGFloat {
    return cgfloat(in: self, at: point, reversed: reversed)
  }
}

public extension ClosedRange where Bound == CGFloat {
  public func value(at point: Double, reversed: Bool = false) -> CGFloat {
    return cgfloat(in: self, at: point, reversed: reversed)
  }
}
