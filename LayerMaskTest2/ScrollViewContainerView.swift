//
//  ScrollViewControllerView.swift
//  LayerMaskTest2
//
//  Created by Benjamin Patch on 1/7/16.
//  Copyright © 2016 PatchWork. All rights reserved.
//

import UIKit


class ScrollViewContainerView: UIView {
    
    enum Layout: Int {
        case topRightBottomLeft = 0
    }
    
    //////////////////////////////
    //////////////////////////////
    // MARK: Variables
    //////////////////////////////
    //////////////////////////////
    
    private var shapeLayer = CAShapeLayer()
    var layout: Layout = .topRightBottomLeft {
        didSet {
            setNeedsLayout()
        }
    }
    var scrollView: UIScrollView!

    
    //////////////////////////////
    //////////////////////////////
    // MARK: Functions
    //////////////////////////////
    //////////////////////////////
    
    init(frame: CGRect, layout: Layout = .topRightBottomLeft) {
        self.layout = layout
        super.init(frame: frame)
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 9.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShape()
    }
    
    private func updateShape() {
        
        // Disable core animation actions to prevent changes to the shape layer animating implicitly
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if bounds.size != shapeLayer.bounds.size {
            // Bounds size has changed, completely update the shape
            
            shapeLayer.frame = CGRect(origin: self.scrollView.getContentOffSet, size: self.bounds.size)
            shapeLayer.path = pathForLayout(layout).CGPath
            layer.mask = shapeLayer
            
        } else {
            // Bounds size has NOT changed, just update origin of shape path to
            // match content offset - makes it appear stationary as we scroll
            
            var shapeFrame = shapeLayer.frame
            shapeFrame.origin = self.scrollView.getContentOffSet
            shapeLayer.frame = shapeFrame
            
        }
        
        CATransaction.commit()
    }
    
    private func pathForLayout(layout: Layout) -> UIBezierPath {
        
        let path = UIBezierPath()
        let layerHeight = self.scrollView.frame.height
        let layerWidth = self.scrollView.frame.width
        
        switch layout {
            
        case .topRightBottomLeft:
            path.moveToPoint(CGPointMake(0, layerHeight))
            path.addLineToPoint(CGPointMake(layerWidth, layerHeight))
            path.addLineToPoint(CGPointMake(layerWidth, 0))
            path.addLineToPoint(CGPointMake(0, layerHeight))
            path.closePath()
            
        }
        
        return path
        
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        // Specify if a touch should be considered valid
        return CGPathContainsPoint(shapeLayer.path, nil, layer.convertPoint(point, fromLayer: shapeLayer), false)
    }
    
    
    //////////////////////////////
    //////////////////////////////
    // MARK: Outlets
    //////////////////////////////
    //////////////////////////////
    
    //    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var imageView: UIImageView!
    
    
    //////////////////////////////
    //////////////////////////////
    // MARK: Actions
    //////////////////////////////
    //////////////////////////////
    
    
    
    
    
    
    
}




//extension scrollViewContainerView: UIScrollViewDelegate {
//    
//    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
//    
//}












