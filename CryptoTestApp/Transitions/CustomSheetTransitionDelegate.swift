//
//  CustomSheetTransitionDelegate.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 31.07.2022.
//

import Foundation
import UIKit

final class CustomSheetTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private let presentationControllerFactory: CustomSheetPresentationControllerFactory
    private var presentationController: CustomSheetPresentationController?
    
    init(presentationControllerFactory: CustomSheetPresentationControllerFactory) {
        self.presentationControllerFactory = presentationControllerFactory
        super.init()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        initializePresentationController(forPresented: presented, presenting: presenting, source: source)
    }
    
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        <#code#>
//    }
//    
//    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        <#code#>
//    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        initializePresentationController(forPresented: presented, presenting: presenting, source: source)
    }
    
    private func initializePresentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> CustomSheetPresentationController {
        
        if let presentationController = presentationController {
            return presentationController
        }
        
        let controller = presentationControllerFactory.makeCustomSheetPresentationController(presentedViewController: presented, presentingViewController: presenting)
        
        presentationController = controller
        
        return controller
    }
    
}


protocol CustomSheetPresentationControllerFactory {
    func makeCustomSheetPresentationController(presentedViewController: UIViewController, presentingViewController: UIViewController?) -> CustomSheetPresentationController
}




