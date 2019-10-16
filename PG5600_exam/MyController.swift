//
//  MyController.swift
//  PG5600_exam
//
//  Created by Håvard on 16/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import UIKit

class MyController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  @IBAction func doSomething(_ sender: UIButton) {
    if let vc = self.storyboard?.instantiateViewController(identifier: "topList") as MainController? {
      //self.present(vc, animated: true)
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
  }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
