//
//  SearchTableViewCell.swift
//  BusinessCard
//
//  Created by AxiZ on 2020/01/27.
//  Copyright © 2020 AxiZ. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var textName1: UILabel!
    @IBOutlet weak var textName2: UILabel!
    @IBOutlet weak var textCompany: UILabel!
    @IBOutlet weak var textDepartment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setView(info: Information) {
        textName1.text = info.name1
        textName2.text = info.name2
        textCompany.text = info.company
        textDepartment.text = info.department
        
        showImage(imgString: info.imageValue, imgTest: imgCard)
    }
    
    func showImage(imgString: String?, imgTest: UIImageView) {
        if (imgString == nil || imgString == "") {
            imgTest.image = nil
            return
        }
        // base64 から Data型へ
        let byteData = imgString!.data(using: String.Encoding.utf8)! as Data
        let data = Data(base64Encoded: byteData)
        let image = UIImage(data: data!)
        imgTest.image = image
        imgTest.layer.cornerRadius = imgTest.bounds.height/2
        imgTest.layer.masksToBounds = true
        imgTest.clipsToBounds = true
    }
}
