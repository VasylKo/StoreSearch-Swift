//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Vasyl Kotsiuba on 2/5/16.
//  Copyright © 2016 Vasiliy Kotsiuba. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

  //MARK: - Outlets
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var artworkImageView: UIImageView!
  
  //MARK: - Ivars
  
  
  //MARK: - View life cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    let selectedView = UIView(frame: CGRect.zero)
    selectedView.backgroundColor = UIColor.appBluishGreenTinColor()
    selectedBackgroundView = selectedView
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

}
