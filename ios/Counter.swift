//
//  Counter.swift
//  uPortMobile
//
//  Created by Ryan Robison on 2/17/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

@objc(Counter)
class Counter: NSObject {
  
  private var count = 0
  @objc
  func increment() {
    count += 1
    print("count is \(count)")
    NSLog("count is %S", count)
  }
  
  @objc
  func getCount(_ callback: RCTResponseSenderBlock) {
    callback([count])
  }
  
  @objc   // only returns static data - won't update after startup
  func constantsToExport() -> [AnyHashable : Any]! {
    return [
      "number": 123.9,
      "string": "foo",
      "boolean": true,
      "array": [1, 22.2, "33"],
      "object": ["a": 1, "b": 2]
    ]
  }
  
  @objc
  static func requiresMainQueueSetup() -> Bool {
//    return false  // initialize on a background thread
    return true   // initialize on the main thread
  }
  
}
