//
//  TopItemCellTableViewCell.swift
//  PG5600_exam
//
//  Created by Håvard on 17/10/2019.
//  Copyright © 2019 Håvard. All rights reserved.
//

import UIKit

class TopItemCell: UICollectionViewCell {
  
  @IBOutlet weak var albumTitle: UILabel!
  @IBOutlet weak var albumImage: UIImageView!
  /*@IBOutlet weak var albumTitle: UILabel!
  @IBOutlet weak var albumArt: UIImageView!
  @IBOutlet weak var albumArtist: UILabel!
  @IBOutlet weak var heart: UIButton!  */
  
  var isClicked = false;
  
  /*@IBAction func favoriseAlbum(_ sender: UIButton) {
    
    //Should handle logic for favorizing tracks
    if(!isClicked) {
      heart.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: .normal);
      isClicked = true;
      heart.tintColor = .systemRed;
    } else {
      heart.setBackgroundImage(UIImage(systemName: "suit.heart"), for: .normal)
      isClicked = false;
      heart.tintColor = .opaqueSeparator;
    }
  } */
  
}
