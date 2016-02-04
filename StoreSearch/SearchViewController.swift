//
//  ViewController.swift
//  StoreSearch
//
//  Created by Vasyl Kotsiuba on 2/4/16.
//  Copyright © 2016 Vasiliy Kotsiuba. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

  //MARK: - Outlets
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  //MARK: - Ivars
  var searchResults = [SearchResult]()
  
  //MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
  //costumize table view insets not to overlap serach bar
    tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0) //made up of 20 points for the status bar and 44 points for the Search Bar
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

//MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchResults = [SearchResult]()
    
    if searchBar.text! != "justin bieber" {
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



//MARK: - Table View Delegate
extension SearchViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cellIdentifier = "SearchResultCell"
    
    var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
    
    if cell == nil {
      cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
    }
    
    if searchResults.count == 0 {
      cell.textLabel!.text = "(Nothing found)"
      cell.detailTextLabel!.text = ""
    } else {
      let searchResult = searchResults[indexPath.row]
      cell.textLabel!.text = searchResult.name
      cell.detailTextLabel!.text = searchResult.artistName
    }
    
    
    return cell
  }
}

extension SearchViewController: UITableViewDelegate {
  
}