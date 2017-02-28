//
//  ShowCatchViewController.swift
//  My catch
//
//  Created by Andreas Tangen on 27.02.2017.
//  Copyright © 2017 Alt mitt. All rights reserved.
//

import UIKit
import Foundation

class ShowCatchViewController: UIViewController, UIScrollViewDelegate {
    var catchObject: Catch? = nil
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myPageControl: UIPageControl!
    
    var kScrollObjHeight: CGFloat = 200.0
    var kScrollObjWidth: CGFloat = 300.0
    var kNumImages = 0
    var scrollViewUsed = false
    
    @IBAction func clickedBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateContents()
    }
    
    @IBAction func changePage(_ sender: Any) {
        scrollViewUsed = false
        let myPage = myPageControl.currentPage
        var myFrame = imageScrollView.frame
        myFrame.origin.x = myFrame.size.width * CGFloat(myPage)
        myFrame.origin.y = 0
        imageScrollView.scrollRectToVisible(myFrame, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollViewUsed else { return }
        
        let xOrigin = imageScrollView.contentOffset.x
        let width = imageScrollView.bounds.size.width
        myPageControl.currentPage = Int(round(xOrigin / width))
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewUsed = true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewUsed = true
    }
    
    func updateContents() {
        imageScrollView.indicatorStyle = .white
        imageScrollView.isPagingEnabled = true
        
        var curXLoc: CGFloat = 0
        kScrollObjWidth = imageScrollView.frame.width
        kScrollObjHeight = imageScrollView.frame.height
        
        if let catchObject: Catch = catchObject {
            print("This is an actual catchObject!")
            kNumImages = catchObject.imageLinks.count
            if (catchObject.quantity > 1) {
                titleLabel.text = "\(catchObject.quantity) \(catchObject.speciesName)"
            } else {
                titleLabel.text = catchObject.speciesName
            }
        }
        else {
            titleLabel.text = "";
        }
        
        for i in 0..<kNumImages {
            let image = catchObject!.getImage(index: i)
            let imageView = UIImageView(image: image)
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            
            var imageFrame: CGRect = imageView.frame
            imageFrame.size.height = kScrollObjHeight
            imageFrame.size.width = kScrollObjWidth
            imageFrame.origin = CGPoint(x: curXLoc, y: 0)
            imageView.frame = imageFrame
            
            curXLoc += kScrollObjWidth
            imageScrollView.addSubview(imageView)
        }
        
        imageScrollView.contentSize = CGSize(width: (CGFloat(kNumImages) * kScrollObjWidth), height: kScrollObjHeight)
        
        myPageControl.numberOfPages = kNumImages
        myPageControl.currentPage = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditCatch") {
            print("Going to edit the catch")
            if let target = segue.destination as? EditCatchViewController {
                if let catchObject = catchObject {
                    print("Editing '\(catchObject.speciesName)' \(catchObject.id)/\(catchObject.localCatchId)")
                    target.catchObject = catchObject
                }
            }
        }
    }
}
