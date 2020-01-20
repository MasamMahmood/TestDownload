//
//  ViewController.swift
//  TestDownload
//
//  Created by Masam on 20.01.2020.
//  Copyright © 2020 Masam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDelegate {
      
    
    @IBOutlet weak var tableView: UITableView!
    var childView = DownloadView()
    let urlList = [
    ["The Swift Programming Language", "https://swift.org/documentation/"],
    ["Crossdomain.xml", "https://jmsliu.com/crossdomain.xml"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib.init(nibName: "DownloadEntryViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "DownloadEntryViewCell")
        
        let nibChild = UINib.init(nibName: "DownloadView", bundle: nil)
        self.tableView.register(nibChild, forCellReuseIdentifier: "DownloadView")
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadEntryViewCell", for: indexPath) as! DownloadEntryViewCell
        
        var stackHeight = 0
        for i in 1...childView.count()
        {
            let child_view = Bundle.main.loadNibNamed("DownloadView", owner: self, options: nil)?.first as! DownloadView
            child_view.lblProgress.text = "Swift_programimg"
            cell.stackviewOption.addArrangedSubview(child_view)
            stackHeight = stackHeight + 33.0
        }
        cell.stackviewOption.heightAnchor.constraint(equalToConstant: stackHeight).isActive = true
        
        return cell
    }
    

}

