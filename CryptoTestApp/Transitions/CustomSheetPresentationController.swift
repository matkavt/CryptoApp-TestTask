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
        presentedViewController.view.layer.cornerRadius = 15
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
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        updatePresentedView()
        updateShadowView()
    }
    
    private func updatePresentedView() {
        guard let presentedView = presentedView else {
            return
        }
        
        let oldFrame = presentedView.frame
        let newFrame = calculateFrameForPresentedView()
        
        if !oldFrame.equalTo(newFrame) {
            presentedView.frame = newFrame
        }
        
    }
    
    private func updateShadowView() {
        guard let containerView = containerView else {
            return
        }
        
        guard let shadeView = shadeView else {
            return
        }
        
        let oldFrame = shadeView.frame
        let newFrame = containerView.bounds
        
        if !oldFrame.equalTo(newFrame) {
            shadeView.frame = newFrame
        }
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

extension CustomSheetPresentationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceViewController = transitionContext.viewController(forKey: .from),
              let destinationViewController = transitionContext.viewController(forKey: .to),
              let sourceView = sourceViewController.view,
              let destinationView = destinationViewController.view else {
                  return
              }
        
        let isPresenting = destinationViewController.isBeingPresented
        let presentedView = isPresenting ? destinationView : sourceView
        let containerView = transitionContext.containerView
        
        if isPresenting {
            containerView.addSubview(destinationView)
            destinationView.frame = containerView.bounds
        }
        
        sourceView.layoutIfNeeded()
        destinationView.layoutIfNeeded()
        
        let frameInContainer = frameOfPresentedViewInContainerView
        let offScreenSize = CGRect(x: 0, y: containerView.bounds.height, width: sourceView.frame.width, height: sourceView.frame.height)
        
        presentedView.frame = isPresenting ? offScreenSize : frameInContainer
        shadeView?.alpha = isPresenting ? 0 : 1
        
        let animations = {
            presentedView.frame = isPresenting ? frameInContainer : offScreenSize
            self.shadeView?.alpha = isPresenting ? 1 : 0
            
        }
        
        let completion = {(completed: Bool) in
            transitionContext.completeTransition(completed && !transitionContext.transitionWasCancelled)
        }
        
        let options: UIView.AnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseInOut
        let transitionDuration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, delay: 0, options: options, animations: animations, completion: completion)
    }
    
    
}

// Доверюсь тебе, тут я не очень шарю
