//
//  NotePageViewController.swift
//  MLVMP- IOS Dylan and Jasper
//
//  Created by MIke Scott on 1/22/16.
//  Copyright (c) 2016 Dylan Landry. All rights reserved.
//


import UIKit
//Used to display info in the form of slidable page, when viewing certain types of algae
class NotePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    var pageTitles = NSArray(array: [String]())
    var tag = ""
    func viewControllerAtIndex(_ index: Int) -> NoteContentViewController
    {
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count))
        {
            return NoteContentViewController()
        }
        
        let v: NoteContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "NoteContentViewController") as! NoteContentViewController
        v.pageIndex = index
        
        return v
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageTitles = ["0", "1", "2", "3", "4"]
       
        self.dataSource = self
        self.delegate = self
        let startVC = self.viewControllerAtIndex(0) as NoteContentViewController
        let viewControllers = NSArray(object: startVC)
        
        self.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        
        let homeButton = UIBarButtonItem(title: "Back", style: .plain , target: self, action: #selector(NotePageViewController.Back))
        self.navigationItem.setLeftBarButton(homeButton, animated: false)
        // Do any additional setup after loading the view.
        
        
    }
    
    func Back()
    {   self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Page View Controller Data Source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! NoteContentViewController
        var index = vc.pageIndex as Int
        if (index == 0 || index == NSNotFound)
        {
            return nil
            
        }
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let vc = viewController as! NoteContentViewController
        var index = vc.pageIndex as Int
        if (index == NSNotFound)
        {
            return nil
        }
        index += 1
        if (index == self.pageTitles.count)
        {
            return nil
        }
        return self.viewControllerAtIndex(index)
        
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
}