//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Vasyl Kotsiuba on 2/4/16.
//  Copyright © 2016 Vasiliy Kotsiuba. All rights reserved.
//

import Foundation

class SearchResult {
  var name = ""
  var artistName = ""
  var artworkURL60 = ""
  var artworkURL100 = ""
  var storeURL = ""
  var kind = ""
  var currency = ""
  var price = 0.0
  var genre = ""
  
  //MARK: - Helper
  func kindForDisplay() -> String {
    
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