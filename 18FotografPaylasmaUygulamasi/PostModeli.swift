//
//  PostModeli.swift
//  18FotografPaylasmaUygulamasi
//
//  Created by maytemur on 31.01.2023.
//

import Foundation

//böylece kendime custom bir sınıf oluşturmuş oldum işler şimdi daha kolay olacak
class PostModeli{
    var email : String
    var yorum : String
    var gorselUrl : String
    
    init (email : String, yorum : String, gorselUrl : String){
        
        self.email = email
        self.yorum = yorum
        self.gorselUrl = gorselUrl
    }
    
}
