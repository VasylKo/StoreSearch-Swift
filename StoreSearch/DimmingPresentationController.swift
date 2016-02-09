//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Vasyl Kotsiuba on 2/8/16.
//  Copyright © 2016 Vasiliy Kotsiuba. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
  override func shouldRemovePresentersView() -> Bool {
    return false
  }
}
