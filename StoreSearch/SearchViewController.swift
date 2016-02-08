//
//  ViewController.swift
//  StoreSearch
//
//  Created by Vasyl Kotsiuba on 2/4/16.
//  Copyright © 2016 Vasiliy Kotsiuba. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

  struct TableViewCellIdentifiers {
    static let searchResultCell = "SearchResultCell"
    static let nothingFoundCell = "NothingFoundCell"
  }
  
  //MARK: - Outlets
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  //MARK: - Ivars
  var searchResults = [SearchResult]()
  var hasSearched = false
  
  //MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
  //costumize table view insets not to overlap serach bar
    tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0) //made up of 20 points for the status bar and 44 points for the Search Bar
    
    //Load search results cell nib
    var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
    tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
    
    cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
    
    tableView.rowHeight = 80
    
    //keyboard will be immediately visible when you start the app so the user can start typing right away
    searchBar.becomeFirstResponder()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - Network request
  func urlWithSearchText(searchText: String) -> NSURL {
    let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    let urlString = String(format: "https://itunes.apple.com/search?term=%@", escapedSearchText)
    let url = NSURL(string: urlString)
    return url!
  }
  
  func performStoreRequestWithURL(url: NSURL) -> String? {
    do {
      return try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
    } catch {
      print("Download Error: \(error)")
      return nil
    }
  }
  
  func showNetworkError() {
    let alert = UIAlertController(title: "Whoops...", message: "There was an error reading from the iTunes Store. Please try again.", preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert.addAction(action)
    presentViewController(alert, animated: true, completion: nil)
  }
  
  //MARK: - JSON Managmnet
  func parseJSON(jsonString: String) -> [String : AnyObject]? {
    guard let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
      else { return nil }
    
    do {
        return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String : AnyObject]
    } catch {
       print("JSON Error: \(error)")
      return nil
    }
  }
  
}

//MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    if !searchBar.text!.isEmpty {
      searchBar.resignFirstResponder()
      hasSearched = true
      searchResults = [SearchResult]()
      
      let url = urlWithSearchText(searchBar.text!)
      print("URL: '\(url)'")
      if let jsonString = performStoreRequestWithURL(url) {
        if let dictionary = parseJSON(jsonString) {
          print("Dictionary \(dictionary)")
        
          tableView.reloadData()
          return
        }
      }
    
      showNetworkError()
    }
  }
  
  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    return .TopAttached
  }
}



//MARK: - Table View Data Source Delegate
extension SearchViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if !hasSearched {
      return 0
    } else if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if searchResults.count == 0 {
      return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath)
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
      
      let searchResult = searchResults[indexPath.row]
      cell.nameLabel.text = searchResult.name
      cell.artistNameLabel.text = searchResult.artistName
      
      return cell
    }
    
  }
}

//MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
  tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    if searchResults.count == 0 {
      return nil
    } else {
      return indexPath
    }
  }
}