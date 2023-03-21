//
//  akisViewController.swift
//  18FotografPaylasmaUygulamasi
//
//  Created by maytemur on 19.01.2023.
//
//derste anlatıldığı gibi pod ile değil firebase sdk ları swift package manaager ile yükledim çünkü pod xcode 13.3 ve yukarısını istiyordu ,siteye göre Swift package manager da 13.3 ve yukarısını istiyordu ama yüklendi fakat çok yavaş çalışıyor firebase upload çok yavaş vs daha sonra istenirse buna bakılabilir!


import UIKit
import Firebase
import SDWebImage

class akisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    //bunu model içinde de yapabiliriz ama şimdilik dizi olarak burda ekleyeceğiz
    //3 tane dizimiz olsun alanlar için
    /*
    var emailDizisi = [String]()
    var yorumDizisi = [String]()
    var gorselDizisi = [String]()
    */
    
    var postDizisi = [PostModeli]()
    
    var postEmail=""
    var postYorum=""
    var postGorselUrl=""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseVerileriAl()
        
    }
    
    func firebaseVerileriAl(){
        let firestoreDatabase = Firestore.firestore()
        
//        firestoreDatabase.collection("postIOSCollection").addSnapshotListener { snapshot, hataOldu in
      //firebase addsnapshotlistener eklemeden önce sql gibi where veya order kalıbını kullanabiliriz bununla tarih'e göre sıralamayı ekledik
        
        firestoreDatabase.collection("postIOSCollection").order(by: "tarih", descending: true).addSnapshotListener { snapshot, hataOldu in
            
            if hataOldu != nil {
                print(hataOldu?.localizedDescription)
            }else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    //her seferinde tekrar ekleyerek listeyi katlamasın diye baştan loop'a girmeden dizileri bir sıfırlıyoruz
                    
                    /*self.emailDizisi.removeAll(keepingCapacity: false)
                    self.yorumDizisi.removeAll(keepingCapacity: false)
                    self.gorselDizisi.removeAll(keepingCapacity: false)
                    */
                    self.postDizisi.removeAll(keepingCapacity: false)
                    
                    //bunları bu şekilde yapmak yerine model olarak sınıfını yaratarak çok daha verimli çalışabiliriz bu zorunlu değil ama yapılırsa iyi olur bu model içinde email,yorum ve gorsel dizisi olacak
                    
                    
                    
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        //print(documentId)
                        
                     
                        
                        if let gorselURl = document.get("gorselurl") as? String{
                            //self.gorselDizisi.append(gorselURl)
                            
                            self.postGorselUrl=gorselURl
                        }
                        
                        if let yorum = document.get("yorum") as? String{
                            //self.yorumDizisi.append(yorum)
                            
                            self.postYorum=yorum
                        }
                        
                        if let email = document.get("email") as? String {
                            
                            //self.emailDizisi.append(email)
                            
                            self.postEmail=email
                        }
                        //tarihi göstermeyeceğimiz için burda almadık ama tarihe göre sıralama yapacağız
                        
                        //aldığımız değerleri model dizisine ekleyelim
                        let post = PostModeli(email: self.postEmail, yorum: self.postYorum,  gorselUrl: self.postGorselUrl)
                        self.postDizisi.append(post)
                        
                    }
                    //for loop bitti artık yeni veri geldiği için burda tekrar yüklüyoruz
                    
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        //artık geleni biliyoruz
//        return emailDizisi.count
        return postDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //feed cell table view için identifier verdik : FeedCellTableViewID isminde
        
        let feedcell = tableView.dequeueReusableCell(withIdentifier: "FeedCellTableViewID", for: indexPath) as! FeedCellTableView
        
//        feedcell.emailText.text = "mustafa@gmail.com"
//        feedcell.emailText.text = emailDizisi[indexPath.row]
        feedcell.emailText.text = postDizisi[indexPath.row].email
        
//        feedcell.postyorumText.text = "benim yorum"
//        feedcell.postyorumText.text = yorumDizisi[indexPath.row]
        feedcell.postyorumText.text = postDizisi[indexPath.row].yorum
        //gorselleri SDwebimage kütüphanesi ile asenkron olarak indiriyoruz başka kütüphanede kullanılanılabilir
        //google'da async image download swift library yazmamız yeterli!
        
//        feedcell.postimageView.image = UIImage(named: "gorselsec")
//        feedcell.postimageView.sd_setImage(with: URL(string: self.gorselDizisi[indexPath.row]))
        feedcell.postimageView.sd_setImage(with: URL(string: self.postDizisi[indexPath.row].gorselUrl))
        
        return feedcell
        
    }
    
    
}
