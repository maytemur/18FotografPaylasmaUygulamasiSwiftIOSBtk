//
//  yukleViewController.swift
//  18FotografPaylasmaUygulamasi
//
//  Created by maytemur on 19.01.2023.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage




class yukleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var gorselResim: UIImageView!
    
    @IBOutlet weak var yorumTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        gorselResim.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        gorselResim.addGestureRecognizer(imageGesture)
        
    }
    
    @objc func gorselSec(){
        let secPicker = UIImagePickerController()
        secPicker.delegate = self
        secPicker.sourceType = .photoLibrary
       
        present(secPicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        gorselResim.image = info[.originalImage] as? UIImage
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func yukleClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        
        let storageReference = storage.reference()
        //firebase storage root kısmındayız
        let mediaFolder = storageReference.child("media")
        
        if let data = gorselResim.image?.jpegData(compressionQuality: 0.5){
            
            //let imageReference = mediaFolder.child("image.jpg")
            //her seferinde aynı image.jpg yaratırsak üzerine yazıyor bunun yerine her seferinde UUID sınıfından orjinal bir string ataması yapacağız.
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { StorageMetadata, hata in
                //data koyduğumuz için asenkron ve completion geri döndüren putData'yı seçiyoruz
                
                if hata != nil {
                    //print(hata?.localizedDescription ?? "hata!")
                    //bunun yerine aşağıda hataGoster fonksiyonu yazdık
                    self.hataMesajiGoster(title: "Hata", message: hata?.localizedDescription ?? "Hata aldınız tekrar deneyin")
                }else{
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            //print(imageUrl ?? "hata var")
                            //burada yüklenen url'yi alabilmek çok önemli çünkü ben upload ederken bir diğeri download edecek bu url bize lazım
                            
                            //url linkini alabiliyoruz artık bunu firebase'e kayıt ediyoruz
                            if let imageUrl = imageUrl{
                                
                                let firestoreDatabase = Firestore.firestore()
                                
                                let firestorePost = ["gorselurl" : imageUrl,"yorum" : self.yorumTF.text!,"email" : Auth.auth().currentUser!.email,"tarih" : FieldValue.serverTimestamp()] as [String : Any]
                                
                                firestoreDatabase.collection("postIOSCollection").addDocument(data: firestorePost) { hata in
                                    if hata != nil {
                                        self.hataMesajiGoster(title: "Hata", message: hata?.localizedDescription ?? "Hata aldınız tekrar deneyiniz")
                                    } else{
                                        //hata yok ok
                                        //gerekli alanları sıfırlayıp tab'ı başlangıca 0'ıncı indexe gönderiyoruz
                                        self.gorselResim.image = UIImage(named: "gorselsec")
                                        self.yorumTF.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func hataMesajiGoster(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
