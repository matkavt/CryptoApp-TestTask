//
//  CustomBottomSheetNavigationController.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 02.08.2022.
//

import Foundation
import UIKit

final class CustomSheetNavigationController: UINavigationController {
    
    private var canAnimatePreferredContentSize = false
    
    private func updateContentSize() {
        preferredContentSize = CGSize(width: view.bounds.width, height: topViewController?.preferredContentSize.height ?? 0)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let vcs =  super.popToRootViewController(animated: animated)
        
        let updates = { [self] in
        
            updateContentSize()
        }
        
        UIView.animate(withDuration: 0.25, animations: updates)

        return vcs
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        guard let viewController = container as? UIViewController,
              viewController === topViewController else {
                  return
              }
        
        let updates = { [self] in
            updateContentSize()
            view.layoutIfNeeded()
        }
        
        if canAnimatePreferredContentSize {
            UIView.animate(withDuration: 0.25, animations: updates)
        } else {
            updates()
        }
        
        canAnimatePreferredContentSize = true
    
    }
}
