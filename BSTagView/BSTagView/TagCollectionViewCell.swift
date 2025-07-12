//
//  TagCollectionViewCell.swift
//  BSTagView
//
//  Created by Sami on 5/15/20.
//  Copyright © 2020 Hungrynaki.com. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = tagLabel.frame.size.height / 2.0
        self.backgroundColor = .lightGray
        self.tagLabel.textColor = .white
    }
    
    override func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
      let snapshot = super.snapshotView(afterScreenUpdates: afterUpdates)

      snapshot?.layer.masksToBounds = false
      snapshot?.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
      snapshot?.layer.shadowRadius = 5.0
      snapshot?.layer.shadowOpacity = 0.4
      snapshot?.center = center
      
      return snapshot
    }
}
