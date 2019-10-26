//
//  Extensions.swift
//  PG5600_exam
//
//  Created by Håvard on 26/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import Foundation

extension Int {
  var msToFormattedMinSec: String {
    let minutes = (self / 60000);
    let seconds = ((self % 60000) / 1000);
    let shouldIncludeNull = seconds < 10 ? "0" : "";
    return "\(minutes):\(shouldIncludeNull)\(seconds)"
  }
}
