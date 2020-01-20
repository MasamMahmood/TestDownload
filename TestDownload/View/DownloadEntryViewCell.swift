//
//  File.swift
//  
//


import UIKit

class ExpandingTableViewCellContent {
    var footerLabel: String?
    var footerProgressLbl: String?
    var footerVw: Bool
    var expanded: Bool
    
    init(footerLabel: String, footerProgressLbl: String, footerVw: Bool) {
        self.footerLabel = footerLabel
        self.footerProgressLbl = footerProgressLbl
        self.footerVw = footerVw
        self.expanded = true
    }
    
}

class DownloadEntryViewCell: UITableViewCell {
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var downloadURLLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var individualProgress: UIProgressView!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var h1View: UIView!
    @IBOutlet weak var v1View: UIView!
    @IBOutlet weak var footerLbl1: UILabel!
    @IBOutlet weak var footerProgressLabel: UILabel!
    @IBOutlet weak var footerPrg1: UIProgressView!
    @IBOutlet weak var PinView1: UIView!
    @IBOutlet weak var stackviewOption: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func set(content: ExpandingTableViewCellContent) {
        
        //self.footerLbl1.text = content.expanded ? content.footerLabel: ""
        //self.footerProgressLabel.text = content.expanded ? content.footerProgressLbl : ""
        self.footerView.isHidden = content.expanded ? content.footerVw : false
    }
}

