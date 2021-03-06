

//Content View Controller holds the images in the page view controllers used to view images
import UIKit

class ContentViewController: UIViewController, UIScrollViewDelegate
{
    var imageView: UIImageView!
    var pageIndex: Int!
    var titleIndex: String!
    var imageFile: String!
    fileprivate var scrollViewDidScrollOrZoom = false
    
    var dotChange = false
    var fromResult = true
    var scrollView = UIScrollView()
    var navHeight = CGFloat(0)
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Base height on where origin is
        
        if (fromResult)
        {
            navHeight = self.navigationController!.navigationBar.frame.height
        }
        else
        {
            navHeight = (self.parent as! PageViewController).navHeight
        }
        //Get image
        if let img = imageFile
        {
            //Get from file
            var parsedImageName = img.components(separatedBy: ".")
            let newImageName: String = parsedImageName[0] as String
            let path = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + newImageName, ofType: "jpg")
            var image = UIImage()
            if (path != nil)
            {
                image = UIImage(contentsOfFile: path!)!
            }
            imageView = UIImageView(image: image)
            imageView.contentMode = UIViewContentMode.center
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            
            //If portrait, have image fill width
            if UIDevice.current.orientation == .portrait
            {
                imageView.frame.origin.x = 0
                imageView.frame.origin.y = (UIScreen.main.bounds.height - navHeight / 2 ) - imageView.frame.height/2
            }
            //If landscape, have it fill height
            else
            {
                imageView.frame.origin.x = (UIScreen.main.bounds.width / 2 ) - imageView.frame.width/2
                imageView.frame.origin.y = 0
                
            }
            

            scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            scrollView.decelerationRate = UIScrollViewDecelerationRateFast
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            self.view.addSubview(scrollView)
            scrollView.contentMode = UIViewContentMode.center
            scrollView.addSubview(self.imageView)
            scrollView.minimumZoomScale = 1
            
            scrollView.maximumZoomScale =  2.0
            scrollView.zoomScale = 1
            scrollView.delegate = self
            scrollView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            scrollView.contentSize = imageView.frame.size
            setZoom()
            centerScrollViewContents()
            
        }
        
    }
    //Zooms out picture so it fits on screen
    func setZoom()
    {
        scrollView.maximumZoomScale = 1
        scrollView.minimumZoomScale = 1
        scrollView.zoomScale = 1
        let boundsSize = self.view.bounds.size
        let imageSize = imageView.image!.size
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        var minScale = min(xScale, yScale)
        
        let maxScale = 2.0
        if xScale >= 1 && yScale >= 1
        {
            minScale = 1.0
        }
        imageView.frame.origin.x = (scrollView.bounds.width/2) - (imageView.frame.width*xScale)/2
        imageView.frame.origin.y = (scrollView.bounds.height/2) - (imageView.frame.height*yScale)/2
        scrollView.maximumZoomScale = CGFloat(maxScale)
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    deinit
    {
        imageView.removeFromSuperview()
        imageView = nil
        
    }
    //Re-layout pictures and UI on orientation change
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        imageView.removeFromSuperview()
        imageView = nil
        
        if let img = imageFile
        {
            var parsedImageName = img.components(separatedBy: ".")
            let newImageName: String = parsedImageName[0] as String
            let path = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + newImageName, ofType: "jpg")
            var image = UIImage()
            if (path != nil)
            {
                image = UIImage(contentsOfFile: path!)!
            }
            imageView = UIImageView(image: image)
            
            
            imageView.contentMode = UIViewContentMode.center
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            var navY = CGFloat(0)
            if UIDevice.current.orientation == .portrait
            {   if fromResult
            {
                navY = navHeight + 30
                }
                else
            {
                navY = navHeight + 30
                }
                imageView.frame.origin.x = 0
                imageView.frame.origin.y = (UIScreen.main.bounds.height - navHeight / 2 ) - imageView.frame.height/2
            }
            else
            {
                navY = navHeight - 20
                imageView.frame.origin.x = (UIScreen.main.bounds.width / 2 ) - imageView.frame.width/2
                imageView.frame.origin.y = 0
                
            }
            
            scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            scrollView.addSubview(self.imageView)
            scrollView.delegate = self
            scrollView.contentSize = imageView.frame.size
            setZoom()
            if fromResult
            {   var y = CGFloat(0)
                if UIDevice.current.orientation == .portrait
                {
                    y = (UIScreen.main.bounds.height-self.navigationController!.navigationBar.frame.height - 45)
                }
                else
                {
                    y = (UIScreen.main.bounds.height-self.navigationController!.navigationBar.frame.height - 30)
                }
                    
                
                
                (self.parent!.parent as! SlideshowViewController).UI.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height:30)
                (self.parent!.parent as! SlideshowViewController).dotHolder.frame.origin.x = (self.view.frame.width/2) - (self.parent!.parent as! SlideshowViewController).dotHolder.frame.width/2
                
            }
            else
            {   var y = CGFloat(0)
                if UIDevice.current.orientation == .portrait
                {
                    y = (UIScreen.main.bounds.height-self.navigationController!.navigationBar.frame.height - 60)
                }
                else
                {
                    y = (UIScreen.main.bounds.height-self.navigationController!.navigationBar.frame.height - 45)
                }
                (self.parent!.parent as! BrowseSlideshowViewController).UI.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height:50)
                (self.parent!.parent as! BrowseSlideshowViewController).dotHolder.frame.origin.x = (self.view.frame.width/2) - (self.parent!.parent as! BrowseSlideshowViewController).dotHolder.frame.width/2
                (self.parent!.parent as! BrowseSlideshowViewController).label2.frame.origin.x = self.view.frame.width-60
                
            }
            
            centerScrollViewContents()
            // Do any additional setup after loading the view.
            
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return imageView
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        scrollViewDidScrollOrZoom = true
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        scrollViewDidScrollOrZoom = true
        centerScrollViewContents()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        //Change current dot when view dissappears
        if fromResult
        {   let vc = (self.parent as! ResultPageViewController)
            vc.dotArray[pageIndex].backgroundColor = UIColor(red: 50/255, green: 82/255, blue: 50/255, alpha: 1.0)
        }
        else
        {   let vc = (self.parent as! PageViewController)
            
            if (vc.dotChange == false)
            {
                var forward = true
                
                if (vc.photoIndex < pageIndex)
                {
                    forward = false
                }
                
                if forward
                {
                    if !(vc.startIndex-1 < 0)
                    {vc.dotArray[vc.startIndex-1].backgroundColor = UIColor(red: 50/255, green: 82/255, blue: 50/255, alpha: 1.0)}
                }
                else
                {
                    if !(vc.startIndex+1 >= vc.dotArray.count)
                    {vc.dotArray[vc.startIndex+1].backgroundColor = UIColor(red: 50/255, green: 82/255, blue: 50/255, alpha: 1.0)}
                    
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Make sure highlighted dot is correct when view appears
        if (fromResult)
        {
            let vc = (self.parent as! ResultPageViewController)
            vc.dotArray[pageIndex].backgroundColor = UIColor(red: 226/255, green: 230/255, blue: 226/255, alpha: 1.0)
        }
        else
        {   let vc = (self.parent as! PageViewController)
            
            vc.dotChange = false
            var forward = true
            var inplace = false
            if vc.photoIndex > pageIndex
            {
                forward = false
            }
            if vc.photoIndex == pageIndex
            {
                inplace = true
            }
            vc.photoIndex = pageIndex
            if (!inplace)
            {   let dots = (vc.parent as! BrowseSlideshowViewController).dotHolder
                if forward
                {
                    vc.startIndex += 1
                    if vc.startIndex >= vc.speciesList[vc.speciesIndex].pictures!.count
                    {   vc.dotChange = true
                        vc.speciesIndex += 1
                        vc.startIndex = 0
                        vc.species = vc.speciesList[vc.speciesIndex]
                        (vc.parent as! BrowseSlideshowViewController).label.text = vc.species.name
                        
                        vc.dotArray.removeAll(keepingCapacity: false)
                        for d in dots.subviews
                        {
                            d.removeFromSuperview()
                        }
                        let width = ((vc.species.pictures!.count) - 1)*20 + 14
                        dots.frame = CGRect(x: 0, y: 0, width: width, height: 30)
                        dots.frame.origin.x = (self.view.frame.width/2) - dots.frame.width/2
                        var xc = 0
                        for x in 0...vc.species.pictures!.count-1
                        {
                            let dot = UIView()
                            //dot.tag = x
                            if (x == 0)
                            {dot.backgroundColor = UIColor(red: 226/255, green: 230/255, blue: 226/255, alpha: 1.0)}
                            else
                            {dot.backgroundColor = UIColor(red: 50/255, green: 82/255, blue: 50/255, alpha: 1.0)}
                            dot.frame = CGRect(x: xc, y: 2, width: 14, height: 14)
                            dot.layer.cornerRadius = dot.frame.size.width/2
                            dot.clipsToBounds = true
                            xc += 20
                            vc.dotArray.append(dot)
                            dots.addSubview(dot)
                            
                        }
                        
                        
                    }
                    else
                    {
                        
                        
                        vc.dotArray[vc.startIndex].backgroundColor = UIColor(red: 226/255, green: 230/255, blue: 226/255, alpha: 1.0)
                    }
                }
                else
                {
                    vc.startIndex -= 1
                    if vc.startIndex < 0
                    {   vc.dotChange = true
                        vc.speciesIndex -= 1
                        
                        vc.species = vc.speciesList[vc.speciesIndex]
                        (vc.parent as! BrowseSlideshowViewController).label.text = vc.species.name
                        
                        vc.startIndex = vc.species.pictures!.count-1
                        vc.dotArray.removeAll(keepingCapacity: false)
                        for s in dots.subviews
                        {
                            s.removeFromSuperview()
                        }
                        let width = ((vc.species.pictures!.count) - 1)*20 + 14
                        dots.frame = CGRect(x: 0, y: 0, width: width, height: 30)
                        dots.frame.origin.x = (self.view.frame.width/2) - dots.frame.width/2
                        var xc = 0
                        for x in 0...vc.species.pictures!.count-1
                        {
                            let dot = UIView()
                            if (x == vc.startIndex)
                            {dot.backgroundColor = UIColor(red: 226/255, green: 230/255, blue: 226/255, alpha: 1.0)}
                            else
                            {dot.backgroundColor = UIColor(red: 50/255, green: 82/255, blue: 50/255, alpha: 1.0)}
                            dot.frame = CGRect(x: xc, y: 2, width: 14, height: 14)
                            dot.layer.cornerRadius = dot.frame.size.width/2
                            dot.clipsToBounds = true
                            xc += 20
                            dots.addSubview(dot)
                            vc.dotArray.append(dot)
                        }
                    }
                    else
                    {
                        vc.dotArray[vc.startIndex].backgroundColor = UIColor(red: 226/255, green: 230/255, blue: 226/255, alpha: 1.0)
                    }
                    
                }
            }
            
        }
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
    //Center image in screen
    func centerScrollViewContents()
    {
        let contentsFrame = imageView.frame
        var cFrame = imageView.frame
        if (contentsFrame.size.width<=UIScreen.main.bounds.width)
        {  
            cFrame.origin.x = (self.view.frame.width - contentsFrame.size.width) / 2.0
        }
        if (contentsFrame.size.height <= UIScreen.main.bounds.height)
        {
            cFrame.origin.y = (UIScreen.main.bounds.height - navHeight - contentsFrame.size.height) / 2.0
        }
        
        imageView.frame = cFrame
        if scrollView.zoomScale > scrollView.minimumZoomScale
        {
            scrollView.isScrollEnabled = true
        }
        else
        {
            scrollView.isScrollEnabled = false
        }
    }
    
    
}

