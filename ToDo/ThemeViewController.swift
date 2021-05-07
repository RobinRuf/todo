//
//  ThemeViewController.swift
//  ToDo
//
//  Created by Robin Ruf on 29.12.20.
//

import UIKit

class ThemeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var switchTheme: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeImageView.image = UIImage(named: "Theme 2")
        
        if switchTheme.selectedSegmentIndex == 0 {
            switchTheme.selectedSegmentTintColor = UIColor.systemRed
        } else if switchTheme.selectedSegmentIndex == 1 {
            switchTheme.selectedSegmentTintColor = UIColor.systemBlue
        }
    }
    
    @IBAction func switchTheme_tapped(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0:
            themeImageView.image = UIImage(named: "Theme 2")
            switchTheme.selectedSegmentTintColor = UIColor.systemRed
            saveColors()
        case 1:
            themeImageView.image = UIImage(named: "Theme 1")
            switchTheme.selectedSegmentTintColor = UIColor.systemBlue
            saveColors()
        default:
            break
        }
    }
    
    func saveColors() {
        
        if switchTheme.selectedSegmentIndex == 0 { // Rotes Theme
            cellBackgroundColor = UIColor.systemRed
            tabBarTintColor = UIColor.systemRed
            switchControlTintColor = UIColor.systemRed
            
            // Tabbar farbe ändern
            guard let tabbar = self.tabBarController?.tabBar else {return} // Tabbar abspeichern in konstante tabbar - muss so gemacht werden, da "tabBarController" vom Typ OPTIONAL ist
            tabbar.tintColor = UIColor.systemRed
            
        } else if switchTheme.selectedSegmentIndex == 1 {
            cellBackgroundColor = UIColor.systemBlue
            tabBarTintColor = UIColor.systemBlue
            switchControlTintColor = UIColor.systemBlue
            
            // Tabbar farbe ändern
            guard let tabbar = self.tabBarController?.tabBar else {return}
            tabbar.tintColor = UIColor.systemBlue
        }
    }
    
}
