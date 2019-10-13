//
//  MainController.swift
//  PG5600_exam
//
//  Created by Håvard on 13/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import UIKit

class MainController: UIViewController {
  
  var lovedMusicItems: [LovedItem] = []
  
  override func viewDidLoad() {
    super.viewDidLoad();
    
    NetworkHandler().makeRequestWith(
      url: "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album",
      completed: {(response: [String: [LovedItem]]) in
        guard let lovedArray = response["loved"] else {
          return;
        }
        self.lovedMusicItems = lovedArray;
      },
      failed: {(failRes) in print(failRes)
    })
  }
  

}
