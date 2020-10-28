//
//  LandingScreenViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/22/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class LandingScreenViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: NPPageControl!
    var cards:[WelcomeCard] = []
    @IBAction func signInButtonTapped(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginScreenViewController") as! LoginScreenViewController
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: false, completion: nil)
    }
    
    @IBAction func newUserButtonTapped(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingOneViewController") as! OnboardingOneViewController
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated: false, completion: nil)
    }
    

        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        DataUtils.setSkipButton(time: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        cards = createCards()
        //setupSlideScrollView(with: cards)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        pageControl.defersCurrentPageDisplay = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //let cards = createCards()
        setupSlideScrollView(with: cards)
        
        DataUtils.setSkipButton(time: false)
        DataUtils.setEmail(email: "")
        DataUtils.setPatientFullName(patientfullname: "")
        DataUtils.setPassword(password: "")
    }
    
    
    func createCards() -> [WelcomeCard] {
        let card1 = WelcomeCard()
        
        card1.titleText = {
            let text = NSMutableAttributedString(string: "Your Health Matters.")
            text.addAttributes([.foregroundColor : NPColorScheme.purple.color], range: NSRange(location: text.string.count - 1, length: 1))
            return text
        }()
        
        card1.descriptionText = NSMutableAttributedString(string: "We believe that managing your health should be easy.")
        
        card1.image = UIImage(named: "Group 3557")
        
        let card2 = WelcomeCard()
        
        card2.titleText = {
            let text = NSMutableAttributedString(string: "Certified and Protected.")
            text.addAttributes([.foregroundColor : NPColorScheme.purple.color], range: NSRange(location: text.string.count - 1, length: 1))
            return text
            }()
        /*
        card2.descriptionText = {
            
            let text = NSMutableAttributedString(string: "Personal data should be shared with people you decide to share it with. Learn More")
            let range = text.string.range(of: "Learn More")!
            let nsrange = NSRange(range, in: text.string)
            text.addAttributes([.link : NSURL(string: "http://nexpil.com")!], range: nsrange)
            return text
            
            
        }()
        */
        card2.descriptionText = NSMutableAttributedString(string: "Personal data should only be shared with people you decide to share it with.")
        card2.image = UIImage(named: "Group 3558")
        card2.topAncher.constant = -20
        let card3 = WelcomeCard()
        
        card3.titleText = {
            let text = NSMutableAttributedString(string: "A Human Connection.")
            text.addAttributes([.foregroundColor : NPColorScheme.purple.color], range: NSRange(location: text.string.count - 1, length: 1))
            return text
        }()
        card3.descriptionText = NSMutableAttributedString(string: "Life is better when we are connected to those we care about.")
        
        card3.image = UIImage(named: "Group 3559")
        
        let card4 = WelcomeCard()
        
        card4.titleText = {
            let text = NSMutableAttributedString(string: "Test it out\nYourself.")
            text.addAttributes([.foregroundColor : NPColorScheme.purple.color], range: NSRange(location: text.string.count - 1, length: 1))
            return text
        }()
        card4.descriptionText = NSMutableAttributedString(string: "Click the New User button below to sign up and see how nexpil can help you")
        
        card4.image = UIImage(named: "Group 3560")
        
        return [card1, card2, card3, card4]
    }
    
    func setupSlideScrollView(with cards : [WelcomeCard]) {
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(cards.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< cards.count {
            cards[i].frame = CGRect(x: scrollView.frame.width * CGFloat(i) + 20, y: 5, width: scrollView.frame.width - 40, height: scrollView.frame.height - 20)
            
            scrollView.addSubview(cards[i])
        }
        pageControl.numberOfPages = cards.count
        pageControl.currentPage = 0
    }
}

extension LandingScreenViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x/scrollView.frame.width))
        pageControl.currentPage = pageIndex
    }
}
