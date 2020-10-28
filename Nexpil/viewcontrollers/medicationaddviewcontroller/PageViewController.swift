//
//  PageViewController.swift
//  PageControl
//
//  Created by Andrew Seeley on 2/2/17.
//  Copyright © 2017 Seemu. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    
    var pageControl = UIPageControl()
    
    // MARK: UIPageViewControllerDataSource
    var previousPage = 0
    lazy var orderedViewControllers: [UIViewController] = {
        return [
            self.newVc(viewController: "FirstMedicationAddViewController"),            
                self.newVc(viewController: "ThirdMedicationAddViewController"),
                self.newVc(viewController: "FourthMedicationAddViewController"),
                self.newVc(viewController: "SiriMedicationViewController"),
                self.newVc(viewController: "EightMedicationAddViewController"),
                /*
                self.newVc(viewController: "TakePrescriptionViewController"),
                self.newVc(viewController: "SeventhMedicationAddViewController"),
                self.newVc(viewController: "FifthMedicationAddViewController"),
                self.newVc(viewController: "SecondMedicationAddViewController"),
                self.newVc(viewController: "EightMedicationAddViewController"),
                self.newVc(viewController: "NinethMedicationAddViewController"),
                */
                self.newVc(viewController: "MedicationResultViewController"),
                self.newVc(viewController: "AddMedicationListViewController"),
                self.newVc(viewController: "SignUpViewController"),
                
                ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = nil
        self.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(PageViewController.enableSwipe), name: NSNotification.Name(rawValue: "enableSwipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PageViewController.disableSwipe), name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
        
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
        
        configurePageControl()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func disableSwipe(){
        self.dataSource = nil
    }
    
    @objc func enableSwipe(){
        self.dataSource = self
    }
    
    func gotoPage()
    {
       self.setViewControllers([self.orderedViewControllers[self.pageControl.currentPage]], direction: .forward, animated: false, completion: nil)        
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 1
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.1) //*/UIColor.white
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.currentPageIndicatorTintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.2) //*/UIColor.black
        //self.view.addSubview(pageControl)
    }
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    
    // MARK: Delegate methords
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            //return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            //return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
             return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func closePageViewController()
    {
        //self.pageControl.currentPage = 0
        //self.setViewControllers([orderedViewControllers[self.pageControl.currentPage]], direction: .forward, animated: true, completion: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }

}
