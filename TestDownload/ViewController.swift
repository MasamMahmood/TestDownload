//
//  ViewController.swift
//  TestDownload
//
//  Created by Masam on 20.01.2020.
//  Copyright © 2020 Masam. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDelegate {
      
    
    @IBOutlet weak var tableView: UITableView!
    var Appdata : [Appointment]?
    var AppDetailData : AppointmentDetail?
    var selectedIndex : Int! = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib.init(nibName: "DownloadEntryViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "DownloadEntryViewCell")
        pullData()

    }
    
    // MARK: - Data Services. 
    func pullData(){
        
        if let url = Bundle.main.url(forResource: "Appointment", withExtension: "json") {
            do {
                
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                self.Appdata = jsonData.appointments
                
                for i in Appdata! {
                    self.detailData(AppId: i.id ?? 0)
                }
                self.tableView.reloadData()
            } catch {
                print("error:\(error)")
            }
        }
        
    }
    
    func detailData(AppId: Int){
        
        if let url = Bundle.main.url(forResource: "AppointmentDetail", withExtension: "json") {
            do {
                
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(AppointmentDetail.self, from: data)
                self.AppDetailData = jsonData
                
                for param in AppDetailData?.sectionList ?? [] {
                    for item in param.items! {
                        
                        if item.actionType == 2 {
                            let filename = item.actionUrl ?? ""
                            self.downloadPDFTask(pdfURL: item.actionUrl ?? "")
                        }
                    }
                }

            } catch {
                print("error:\(error)")
            }
        }
        
    }
    
    func downloadPDFTask(pdfURL: String) {
                 
            self.downloadFile(url: pdfURL, filetype: ".pdf", callback: { success, response in

            if !success || response == nil {
                return false
            }
            return true
        })
        
    }
    
    // MARK:- Download Alamofire Function
    
    @objc public func downloadFile(url:String, filetype: String, callback:@escaping (_ success:Bool, _ result:Any?)->(Bool)) -> Void {
        var destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        if filetype.elementsEqual(".pdf"){
            destination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let downloadFileName = url
                let fileURL = documentsURL.appendingPathComponent("\(downloadFileName).pdf")
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
        }

        Alamofire.download(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                
                print(progress)
                print(progress.fractionCompleted)
                
            }).response(completionHandler: { (DefaultDownloadResponse) in
                callback(DefaultDownloadResponse.response?.statusCode == 200, DefaultDownloadResponse.destinationURL?.path)
                print(DefaultDownloadResponse)
                
            })
    }

    
    // MARK: - TableView Delegates
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == selectedIndex{
            selectedIndex = -1
            
        }else{
            selectedIndex = indexPath.row
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex
        {
            return UITableView.automaticDimension
        }else{
            return 71
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1 //Appdata?.count  ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadEntryViewCell", for: indexPath) as! DownloadEntryViewCell
        let dic = Appdata?[indexPath.row]
        var stackHeight:CGFloat = 0.0
        
        for i in Appdata ?? [] {
            let child_view = Bundle.main.loadNibNamed("FooterView", owner: self, options: nil)?.first as! FooterView
            child_view.projName.text = "\(i.projectName ?? "")" + "  " + "\(i.subTitle ?? "")"
            cell.stackViewFooter.addArrangedSubview(child_view)
            stackHeight = stackHeight + 60.0
            
        }
        cell.stackViewFooter.heightAnchor.constraint(equalToConstant: stackHeight).isActive = true
        return cell
    }
    
    
}

