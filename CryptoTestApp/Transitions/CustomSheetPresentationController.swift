//
//  CustomSheetPresentationController.swift
//  CryptoTestApp
//
//  Created by Ludmila Rezunic on 31.07.2022.
//

import Foundation
import UIKit

final class CustomSheetPresentationController: UIPresentationController {
    
    private enum State {
        case dismissed
        case presenting
        case presented
        case dismissing
    }
    
    private var state: State = .dismissed
    private var shadeView: UIView?
    private let dismissalHandler: CustomSheetDismissalController
    
    
    init(
           presentedViewController: UIViewController,
           presentingViewController: UIViewController?,
           dismissalHandler: CustomSheetDismissalController
       ) {
           self.dismissalHandler = dismissalHandler
           super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
       }
    
    override func presentationTransitionWillBegin() {
        state = .presenting
                
        guard presentedViewController.isViewLoaded else { return }

        presentedViewController.view.clipsToBounds = true
        presentedViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedViewController.view.layer.cornerRadius = 10
        addShade()

    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed {
            state = .presented
        } else {
            state = .dismissed
        }
    }
    
    override func dismissalTransitionWillBegin() {
        state = .dismissing
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            removeShade()
            state = .dismissed
        } else {
            state = .presented
        }
    }
 
    override var shouldPresentInFullscreen: Bool {
        false
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        calculateFrameForPresentedView()
    }
    
    private func calculateFrameForPresentedView() -> CGRect{
        guard let containerView = containerView else {
            return .zero
        }
        
        let preferredHeight = presentedViewController.preferredContentSize.height
        let maxHeight = containerView.bounds.height
        let height = min(preferredHeight, maxHeight)
        
        return .init(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
    }
    
    private func addShade() {
        guard let containerView = containerView else {
            return
        }
        
        let shadeView = UIView()
        containerView.addSubview(shadeView)
        shadeView.frame = containerView.bounds
        shadeView.backgroundColor = .black.withAlphaComponent(0.35)
        self.shadeView = shadeView
    }
    
    private func removeShade() {
        shadeView?.removeFromSuperview()
        shadeView = nil
    }
    
    private func dismissIfPossible() -> Bool {
        let canDismiss = state == .presented
        
        if canDismiss {
            dismissalHandler.performDismissal(animated: true)
        }
        
        return canDismiss
    }

    
}


