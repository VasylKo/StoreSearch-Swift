//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Vasyl Kotsiuba on 2/8/16.
//  Copyright © 2016 Vasiliy Kotsiuba. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    enum AnimationStyle {
        case Slide
        case Fade
    }
    
    //MARK: - Outlets
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!

    //MARK: - Ivars
    var searchResult: SearchResult!

    lazy var currencyFormatter:NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.currencyCode = self.searchResult.currency
        return formatter
    }()
  
    var downloadTask: NSURLSessionDownloadTask?
    var dismissAnimationStyle = AnimationStyle.Fade
  
  //MARK: - View life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.clearColor()
    view.tintColor = UIColor.appBluishGreenTinColor()
    
    popupView.layer.cornerRadius = 10
    
    //Add Gesture recognizer
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("close:"))
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
    
    let downSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("close:"))
    downSwipeGestureRecognizer.direction = .Down
    view.addGestureRecognizer(downSwipeGestureRecognizer)
    
    let upSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("close:"))
    upSwipeGestureRecognizer.direction = .Up
    view.addGestureRecognizer(upSwipeGestureRecognizer)
    
    
    if searchResult != nil {
      updateUI()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    modalPresentationStyle = .Custom
    transitioningDelegate = self
  }
  
  deinit {
    print("deinit \(self)")
    downloadTask?.cancel()
  }
  
  //MARK: - Actions
  @IBAction func close(sender: UIButton) {
    dismissAnimationStyle = .Slide
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func openInStore() {
    if let url = NSURL(string: searchResult.storeURL) {
      UIApplication.sharedApplication().openURL(url)
    }
  }
  
  //MARK: - UI
  func updateUI() {
    nameLabel.text = searchResult.name
        
    if searchResult.artistName.isEmpty {
      artistNameLabel.text =  NSLocalizedString("Unknown", comment: "No artist found label")
    } else {
      artistNameLabel.text = searchResult.artistName
    }
    
    kindLabel.text = searchResult.kindForDisplay()
    genreLabel.text = searchResult.genre
    
    let priceText: String
    if searchResult.price == 0 {
      priceText = "Free"
    } else if let text = currencyFormatter.stringFromNumber(searchResult.price) {
      priceText = text
    } else {
      priceText = ""
    }
    
    priceButton.setTitle(priceText, forState: .Normal)
    
    if let url = NSURL(string: searchResult.artworkURL100) {
      downloadTask = artworkImageView.loadImageWithURL(url)
    }
  }
  
}

//MARK: - UIViewControllerTransitioningDelegate
extension DetailViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    return DimmingPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissAnimationStyle {
        case .Slide:
            return SlideOutAnimationController()
        case .Fade:
            return FadeOutAnimationController()
        }
        
    }
    
}

//MARK: - UIGestureRecognizerDelegate
extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}