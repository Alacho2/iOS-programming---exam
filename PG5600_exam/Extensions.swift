//
//  Extensions.swift
//  PG5600_exam
//
//  Created by Håvard on 26/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import Foundation
import UIKit

extension Int {
  var msToFormattedMinSec: String {
    let minutes = (self / 60000);
    let seconds = ((self % 60000) / 1000);
    let shouldIncludeNull = seconds < 10 ? "0" : "";
    return "\(minutes):\(shouldIncludeNull)\(seconds)"
  }
}

extension UICollectionView {
  
  func setEmptyMessage(message: String) {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
    label.text = message;
    label.textColor = .black;
    label.numberOfLines = 0;
    label.textAlignment = .center;
    label.sizeToFit()
    
    self.backgroundView = label
  }
  
  func reset() {
    self.backgroundView = nil;
  }
  
}

extension UITableView {
  
  func setEmptyMessage(message: String) {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
    label.text = message;
    label.textColor = .black;
    label.numberOfLines = 0;
    label.textAlignment = .center;
    label.sizeToFit()
    
    self.backgroundView = label
  }
  
  func reset() {
    self.backgroundView = nil;
  }
  
}
