//
//  ayarlarViewController.swift
//  18FotografPaylasmaUygulamasi
//
//  Created by maytemur on 19.01.2023.
//

import UIKit
import Firebase

class ayarlarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cikisYapClicked(_ sender: Any) {
       
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "anaEkranVC", sender: nil)
            
        } catch  {
            print("hata")
        }
        
        
  }
    
}
