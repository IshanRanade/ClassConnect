//
//  TransitionManager.swift
//  ClassConnectSwift
//
//  Created by Ishan Ranade on 12/25/14.
//  Copyright (c) 2014 Ishan Sanjay Ranade. All rights reserved.
//

import UIKit

class TransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning {
   
    private var presenting:Bool = true
    private var interactive = false;
    private var enterPanGesture: UIScreenEdgePanGestureRecognizer!
    
    var sourceViewController: UIViewController! {
        didSet {
            self.enterPanGesture = UIScreenEdgePanGestureRecognizer()
            self.enterPanGesture.addTarget(self, action:"handleOnstagePan:")
            self.enterPanGesture.edges = UIRectEdge.Left
            self.sourceViewController.view.addGestureRecognizer(self.enterPanGesture)
        }
    }
    
    //These are the UIViewControllerTransitionDelegate methods
    //This method is the actual animation
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        //Get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        
        
        
        
        /*This is for a simple swiping in and out transition animation */
        //Set up from 2D transforms that we'll use in the animation
        let offScreenRight = CGAffineTransformMakeTranslation(container.frame.width, 0)
        let offScreenLeft = CGAffineTransformMakeTranslation(-container.frame.width, 0)
        
        //Prepare the toView for the transition
        toView?.transform = self.presenting ? offScreenRight : offScreenLeft
        //fromView?.transform = self.presenting ? offScreenLeft : offScreenRight
        
        
        
        /*/*This if for a rotating in and out transition animation */
        // set up from 2D transforms that we'll use in the animation
        let π : CGFloat = 3.14159265359
        
        let offScreenRotateIn = CGAffineTransformMakeRotation(-π/2)
        let offScreenRotateOut = CGAffineTransformMakeRotation(π/2)
        
        // set the start location of toView depending if we're presenting or not
        toView?.transform = self.presenting ? offScreenRotateIn : offScreenRotateOut
        
        // set the anchor point so that rotations happen from the top-left corner
        toView?.layer.anchorPoint = CGPoint(x:0, y:0)
        fromView?.layer.anchorPoint = CGPoint(x:0, y:0)
        
        // updating the anchor point also moves the position to we have to move the center position to the top-left to compensate
        toView?.layer.position = CGPoint(x:0, y:0)
        fromView?.layer.position = CGPoint(x:0, y:0)*/
        
        
        
        
        //Add the both views to our view controller
        container.addSubview(toView!)
        container.addSubview(fromView!)
        
        //Get the duration of the animation
        let duration = self.transitionDuration(transitionContext)
        
        //Perform the animation
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
                // slide fromView off either the left or right edge of the screen
                // depending if we're presenting or dismissing this view
                fromView?.transform = self.presenting ? offScreenLeft : offScreenRight
                toView?.transform = CGAffineTransformIdentity
            }, completion: { finished in
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
        })
    }
    
    //This method determines how long the transition animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.2
    }
    
    //This method returns the animataor when presenting a viewcontroller
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.presenting = true
        return self
    }
    
    //This method returns the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.presenting = false
        return self
    }
    
    
    //These methods are for the UIViewControllerInteractiveTransitioning
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // if our interactive flag is true, return the transition manager object
        // otherwise return nil
        return self.interactive ? self : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
    
    func handleOnstagePan(pan: UIPanGestureRecognizer){
        // how much distance have we panned in reference to the parent view?
        let translation = pan.translationInView(pan.view!)
        
        // do some math to translate this to a percentage based value
        let d =  translation.x / CGRectGetWidth(pan.view!.bounds) * 0.5
        
        // now lets deal with different states that the gesture recognizer sends
        switch (pan.state) {
            
        case UIGestureRecognizerState.Began:
            // set our interactive flag to true
            self.interactive = true
            
            // trigger the start of the transition
            self.sourceViewController.performSegueWithIdentifier("presentAddClassView", sender: self)
            break
            
        case UIGestureRecognizerState.Changed:
            
            // update progress of the transition
            self.updateInteractiveTransition(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            
            // return flag to false and finish the transition
            self.interactive = false
            self.finishInteractiveTransition()
        }
    }
}