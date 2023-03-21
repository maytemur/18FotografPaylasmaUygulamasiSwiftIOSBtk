//
//  FeedCellTableView.swift
//  18FotografPaylasmaUygulamasi
//
//  Created by maytemur on 26.01.2023.
//

import UIKit

class FeedCellTableView: UITableViewCell {
    
    //bu class'ı özel olarak UITableViewCell olarak oluşturduk ve tebleview cell'in clasıı olarak atadık. Table view'e cocoa touch class oluşturup atadığımız gibi yalnız burda uıview controller değil uıtablecell olduğu için view did load falan yok başka metodlar var
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var postimageView: UIImageView!
    @IBOutlet weak var postyorumText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
