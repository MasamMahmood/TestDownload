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
    var Appdata : [Appointment]?
    
    let urlList = [
    ["The Swift Programming Language", "https://swift.org/documentation/"],
    ["Crossdomain.xml", "https://jmsliu.com/crossdomain.xml"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib.init(nibName: "DownloadEntryViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "DownloadEntryViewCell")
        pullData()

    }
    
    func pullData(){
        
        if let url = Bundle.main.url(forResource: "Appointment", withExtension: "json") {
            do {
                
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                self.Appdata = jsonData.appointments
                self.tableView.reloadData()
            } catch {
                print("error:\(error)")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return urlList.count
        return Appdata?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadEntryViewCell", for: indexPath) as! DownloadEntryViewCell
        let dic = Appdata?[indexPath.row]
        var stackHeight:CGFloat = 0.0
//        for i in 1...urlList.count
//        {
//            let child_view = Bundle.main.loadNibNamed("FooterView", owner: self, options: nil)?.first as! FooterView
//            cell.stackViewFooter.addArrangedSubview(child_view)
//            stackHeight = stackHeight + 60.0
//        }
        
        for i in Appdata ?? [] {
            let child_view = Bundle.main.loadNibNamed("FooterView", owner: self, options: nil)?.first as! FooterView
            child_view.projName.text = dic?.projectName
            cell.stackViewFooter.addArrangedSubview(child_view)
            stackHeight = stackHeight + 35.0
            
        }
       // cell.stackViewFooter.heightAnchor.constraint(equalToConstant: stackHeight).isActive = true
        return cell
    }
}

