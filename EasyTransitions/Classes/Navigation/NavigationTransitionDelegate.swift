//
//  NavigationTransitionDelegate.swift
//  EasyTransitions
//
//  Created by Marcos Griselli on 08/04/2018.
//

import Foundation
import UIKit

open class NavigationTransitionDelegate: NSObject {

    private var animators = [UINavigationController.Operation: NavigationTransitionAnimator]()
    private let interactiveController = TransitionInteractiveController()
    
    open func wire(viewController: UIViewController,
                   with pan: Pan,
                   beginWhen: @escaping ((UIGestureRecognizer) -> Bool) = { _ in true }) {
        interactiveController.wireTo(viewController: viewController, with: pan)
        interactiveController.navigationAction = {
            viewController.navigationController?.popViewController(animated: true)
        }
        interactiveController.shouldBeginTransition = beginWhen
    }
    
    open func set(animator: NavigationTransitionAnimator,
                  for operation: UINavigationController.Operation) {
        animators[operation] = animator
    }

    open func removeAnimator(for operation: UINavigationController.Operation) {
        animators.removeValue(forKey: operation)
    }
}

extension NavigationTransitionDelegate: UINavigationControllerDelegate {
    
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = animators[operation] else {
            return nil
        }
        return NavigationTransitionConfigurator(transitionAnimator: animator)
    }
    
    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveController.interactionInProgress ? interactiveController : nil
    }
}
