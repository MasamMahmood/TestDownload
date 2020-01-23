//
//  File.swift
//  
//


import UIKit

class DownloadEntryViewCell: UITableViewCell {
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var downloadURLLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var individualProgress: UIProgressView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var stackViewFooter: UIStackView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
       
}

