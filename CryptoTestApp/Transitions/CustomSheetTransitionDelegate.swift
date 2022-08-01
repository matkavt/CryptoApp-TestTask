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
    
    init(presentationControllerFactory: CustomSheetPresentationControllerFactory) {
        self.presentationControllerFactory = presentationControllerFactory
        super.init()
    }
    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        <#code#>
//    }
//    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        <#code#>
//    }
//    
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        <#code#>
//    }
//    
//    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        <#code#>
//    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        presentationControllerFactory.makeCustomSheetPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
}

protocol CustomSheetPresentationControllerFactory {
    func makeCustomSheetPresentationController(presentedViewController: UIViewController, presentingViewController: UIViewController?) -> CustomSheetPresentationController
}




