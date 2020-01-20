//
//  DownloadView.swift
//  TestDownload
//
//  Created by Masam on 20.01.2020.
//  Copyright © 2020 Masam. All rights reserved.
//

import UIKit

class DownloadView: UITableViewCell {

    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var downloadLbl: UILabel!
    @IBOutlet weak var pinView: UIView!
    @IBOutlet weak var verticalView: UIView!
    @IBOutlet weak var HoriView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
