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

  func configureForSearchResult(searchResult: SearchResult) {
    nameLabel.text = searchResult.name
    
    if searchResult.artistName.isEmpty {
      artistNameLabel.text = "Unknown"
    } else {
      artistNameLabel.text = String(format: "%@ (%@)", searchResult.artistName, kindForDisplay(searchResult.kind))
    }
  }
  
  //MARK: - Helper
  func kindForDisplay(kind: String) -> String {
    
    switch kind {
    case "album": return "Album"
    case "audiobook": return "Audio Book"
    case "book": return "Book"
    case "ebook": return "E-Book"
    case "feature-movie": return "Movie"
    case "music-video": return "Music Video"
    case "podcast": return "Podcast"
    case "software": return "App"
    case "song": return "Song"
    case "tv-episode": return "TV Episode"
    default: return kind
    }
  }


}
