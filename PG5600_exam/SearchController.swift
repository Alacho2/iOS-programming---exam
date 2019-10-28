//
//  SearchController.swift
//  PG5600_exam
//
//  Created by Håvard on 17/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

  @IBOutlet weak var searchField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("You are in search")
    
    searchField.addTarget(self, action: #selector(textFieldChanged(textField:)), for: .editingChanged)
    searchTheApi(query: "Thriller");
  }
  
  @objc func textFieldChanged(textField: UITextField){
    if let textInput = textField.text, textInput.count > 6 {
      //Fire off a search network request. Offer button that can also search, if text is too short
      
      //print(textInput);
    }
  }
  
  func searchTheApi(query: String){
    NetworkHandler().makeRequestWith(url: "https://theaudiodb.com/api/v1/json/195223/searchalbum.php?a=\(query)",
      completed: {(response: [String: [AlbumDetail]]) in
        guard let albumArr = response["album"] else {
          return;
        }
        
        print("Got a response", albumArr)
        },
      failed: {(failRes) in print("Something terrible went wrong")}
  )}
  
}
