import Alamofire

public enum ALDownloadState: Int {
    case None = 0  // 闲置状态
    case Download = 1  // 开始下载
    case Resume = 2 // 暂停下载
    case Cancel = 3 // 取消下载
    case Wait = 4 // 等待下载
    case Completed = 5 // 完成下载
    
}

typealias ALDownloadStateBlock = (_ state: ALDownloadState)-> Void
typealias ALDownloadProgressBlock = (_ progress: Progress)-> Void
typealias ALDownloadResponseBlock = (_ response: DefaultDownloadResponse)-> Void

class ALDownloadInfo {
    
    public let downloadurl: String
    
    public let projName: String
    
    /**  下载请求  */
    var downloadRequest: DownloadRequest?
    /**  取消下载时的数据  */
    var cancelledData: Data?
    /**  下载管理者  */
    public let manager: SessionManager
    /**  文件下载路径  */
    //    public let destinationPath: String?
    /**  下载状态改变时调用  */
    var stateChangeBlock: ALDownloadStateBlock?
    /**  返回下载进度  */
    var progressChangeBlock: ALDownloadProgressBlock?
    var responsChangeBlock: ALDownloadResponseBlock?
    
    var state: ALDownloadState? = ALDownloadState.None {
        willSet{
            if let stateBlock = self.stateChangeBlock,let newState = newValue {
                DispatchQueue.main.async {stateBlock(newState)}
            }
        }
        didSet{}
    }
    
    private var progress: Progress? {
        willSet{
            if let progressBlock = self.progressChangeBlock,let newProgress = newValue {
                DispatchQueue.main.async {progressBlock(newProgress)}
            }
        }
        didSet{}
    }
    
    private var respons: DefaultDownloadResponse? {
        willSet{
            if let responsBlock = self.responsChangeBlock,let newProgress = newValue {
                DispatchQueue.main.async {responsBlock(newProgress)}
            }
        }
        didSet{}
    }
    
    init(url: String, name: String) {
        self.downloadurl = url
        self.projName = name
        let configuration = URLSessionConfiguration.default
        //请求超时
        configuration.timeoutIntervalForRequest = 5
        /** 最大同时下载数 ---- iOS对于同一个IP服务器的并发最大默认为4，OS X为6 */
        configuration.httpMaximumConnectionsPerHost = 10
        self.manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    @discardableResult
    func download(destinationPath: String? = nil) -> Self {
        if let resumeData = cancelledData {
            let destination = createDestination(url: downloadurl, destinationPath: destinationPath)
            
            downloadRequest = manager.download(resumingWith: resumeData, to: destination).response(completionHandler: { [weak self] (defresponse) in
                self?.cancelledData = defresponse.resumeData
            }).downloadProgress(closure: { (progress) in
                self.progress = progress
            }).response(completionHandler: { (defaultResponse) in
                print("localUrl: \(defaultResponse)")
                self.respons = defaultResponse
            })
        }else{
            let destination = createDestination(url: downloadurl, destinationPath: destinationPath)
            downloadRequest = manager.download(downloadurl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, to: destination).response(completionHandler: { [weak self] (defresponse) in
                self?.cancelledData = defresponse.resumeData
            }).downloadProgress(closure: { (progress) in
                self.progress = progress
            }).response(completionHandler: { (defaultResponse) in
                print("localUrl: \(defaultResponse)")
                self.respons = defaultResponse
            })
            
        }
        self.state = ALDownloadState.Download
        return self
    }
    
    func resume() {
        downloadRequest?.cancel(createResumeData: true)
        state = ALDownloadState.Resume
    }
    
    func cancel() {
        downloadRequest?.cancel()
        state = ALDownloadState.Cancel
    }
    
    /**  挂起 */
    func hangup() {
        downloadRequest?.cancel()
        state = ALDownloadState.Wait
    }
    
    
    func remove() {
        downloadRequest?.cancel()
        state = ALDownloadState.None
    }
    
    @discardableResult
    func downloadProgress(_ progress: ALDownloadProgressBlock?) -> Self  {
        progressChangeBlock = progress
        return self
    }
    
    @discardableResult
    func downloadResponse(_ response: ALDownloadResponseBlock?) -> Self {
        responsChangeBlock = response
        return self
    }
    
    /**  创建文件下载完成的储存位置
     *    destinationPath = nil 时会在Documents下创建ALDownloadedFolder文件夹
     */
    func createDestination(url: String,destinationPath: String?) -> DownloadRequest.DownloadFileDestination {
        
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = destinationPath == nil ? documentsURL.appendingPathComponent(ALDownloadedFolderName, isDirectory: true).appendingPathComponent(response.suggestedFilename!) : URL(fileURLWithPath: destinationPath!)
            
            self.state = ALDownloadState.Completed
//            ALDownloadNoteCenter.post(name: Notification.Name.Info.DidComplete, object: self, userInfo: ["url": url])
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        return destination
    }
    
}

//var destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
//if filetype.elementsEqual(".pdf"){
//    destination = { _, _ in
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let downloadFileName = url
//        let fileURL = documentsURL.appendingPathComponent("\(downloadFileName).pdf")
//        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//    }
//}
