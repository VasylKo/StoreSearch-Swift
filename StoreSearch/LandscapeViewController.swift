//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Vasiliy Kotsiuba on 12/02/16.
//  Copyright © 2016 Vasiliy Kotsiuba. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: - Ivars
    var searchResults = [SearchResult]()
    private var firstTime = true
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        Remember how, if you don’t add make constraints of your own, Interface Builder will give the views automatic constraints?
        Well, those automatic constraints get in the way if you’re going to do your own layout. That’s why you need to remove these unwanted constraints
        You also do translatesAutoresizingMaskIntoConstraints = true. That allows you to position and size your views manually by changing their frame property.
        When Auto Layout is enabled, you’re not supposed to change the frame yourself – you can only indirectly move views into position by creating constraints. Modifying the frame by hand will cause conflicts with the existing constraints and bring all sorts of trouble
        
        Note: Auto Layout doesn’t really get disabled, but with the “translates autoresizing mask” option set to true, UIKit will convert your manual layout code into the proper constraints behind the scenes. That’s also why you removed the automatic constraints because they will conflict with the new ones, causing your app to crash.
        */
        //Disable Auto Layout
        view.removeConstraints(view.constraints)
        view.translatesAutoresizingMaskIntoConstraints = true
        
        pageControl.removeConstraints(pageControl.constraints)
        pageControl.translatesAutoresizingMaskIntoConstraints = true
        
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        pageControl.frame = CGRect(x: 0, y: view.frame.size.height - pageControl.frame.size.height, width: view.frame.size.width, height: pageControl.frame.size.height)
        
        if firstTime {
            firstTime = false
            tileButtons(searchResults)
        }
    }
    
    deinit {
        print("deinit \(self)")
    }
    
    // MARK: - Private methods
    private func tileButtons(searchResults: [SearchResult]) {
        var columnsPerPage = 5
        var rowsPerPage = 3
        var itemWidth: CGFloat = 96
        var itemHeight: CGFloat = 88
        var marginX: CGFloat = 0
        var marginY: CGFloat = 20
        
        let scrollViewWidth = scrollView.bounds.size.width
        
        switch scrollViewWidth {
        case 568:
            columnsPerPage = 6
            itemWidth = 94
            marginX = 2
        
        case 667:
            columnsPerPage = 7
            itemWidth = 95
            itemHeight = 98
            marginX = 1
            marginY = 29
        
        case 736:
            columnsPerPage = 8
            rowsPerPage = 4
            itemWidth = 92
        
        default:
            break
        }
        
        // TODO: more to come here
        let buttonWidth: CGFloat = 82
        let buttonHeight: CGFloat = 82
        let paddingHorz = (itemWidth - buttonWidth)/2
        let paddingVert = (itemHeight - buttonHeight)/2
        
        var row = 0
        var column = 0
        var x = marginX
        var index = 0
        
        for searchResult in searchResults {
            
            let button = UIButton(type: .Custom)
            button.backgroundColor = UIColor.lightGrayColor()
            button.setTitle("\(index)", forState: .Normal)
            index++
            //button.setBackgroundImage(UIImage(named: "LandscapeButton"), forState: .Normal)
            
            button.frame = CGRect(
            x: x + paddingHorz,
            y: marginY + CGFloat(row)*itemHeight + paddingVert,
            width: buttonWidth, height: buttonHeight)
            
            scrollView.addSubview(button)
            
            //downloadImageForSearchResult(searchResult, andPlaceOnButton: button)
            
            ++row
            if row == rowsPerPage {
                row = 0; x += itemWidth; ++column
                
                if column == columnsPerPage {
                column = 0; x += marginX * 2
                }
            }
        }
        
        
        let buttonsPerPage = columnsPerPage * rowsPerPage
        let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
        
        scrollView.contentSize = CGSize(width: CGFloat(numPages)*scrollViewWidth, height: scrollView.bounds.size.height)
        
        print("Number of pages: \(numPages)")
        
        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
