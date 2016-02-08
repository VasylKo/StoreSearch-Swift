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
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

//MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    hasSearched = true
    searchBar.resignFirstResponder()
    searchResults = [SearchResult]()
    
    if searchBar.text! != "J" {
      for i in 0...2 {
        let serachResult = SearchResult()
        serachResult.name = String(format: "Fake Result %d for", i)
        serachResult.artistName = searchBar.text!
        searchResults.append(serachResult)
      }
    }
    
    tableView.reloadData()
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