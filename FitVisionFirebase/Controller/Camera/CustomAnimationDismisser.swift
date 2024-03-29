//
//  CustomAnimationDismisser.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/3/17.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class CustomAnimationDismisser: NSObject,UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let fromeView = transitionContext.view(forKey: .from) else { return }
        containerView.addSubview(toView)
        
        let startingFrame = CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        toView.frame = startingFrame
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            fromeView.frame = CGRect(x: -fromeView.frame.width, y: 0, width: fromeView.frame.width, height: fromeView.frame.height)
            
        }) { (_) in
            transitionContext.completeTransition(true)
        }
        
        
    }
    
    
    
}
