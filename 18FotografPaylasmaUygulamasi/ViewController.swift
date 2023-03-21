//
//  ViewController.swift
//  18FotografPaylasmaUygulamasi
//
//  Created by maytemur on 18.01.2023.
//

import UIKit
import Firebase
import CoreMedia

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var sifreTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func girisYapClicked(_ sender: Any) {
        
        //performSegue(withIdentifier: "toMyPage", sender: nil)
        if emailTF.text != "" && sifreTF.text != "" {
            Auth.auth().signIn(withEmail: emailTF.text!, password: sifreTF.text!) { onaylamaSonucu, error in
                //normalde bunu yapabilmek için çok uzun backend'ler yazmamız gerekiyor php veya node ile vs ama burda firebase sdk'leri sayesinde burada çok kolay bir şekilde yapabiliyoruz
                if  error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata aldınız , tekrar deneyin")
                } else {
                    self.performSegue(withIdentifier: "toMyPage", sender: nil)
                }
            }
        } else{
            self.hataMesaji(titleInput: "Hata", messageInput: "Email ve Parola Giriniz")
        }
        
        
    }
    
    
    @IBAction func kayitOlClicked(_ sender: Any) {
        if emailTF.text != "" && sifreTF.text != "" {
            //kayıt olma işlemi
            Auth.auth().createUser(withEmail: emailTF.text!, password: sifreTF.text!) { onaylamaSonucu, error in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error!.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toMyPage", sender: nil)
                }
            }
        } else {
            hataMesaji(titleInput: "Hata!", messageInput: "Kullanıcı Adı ve Şifre Giriniz!")
        }
    }
    
    func hataMesaji(titleInput: String, messageInput: String ){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

