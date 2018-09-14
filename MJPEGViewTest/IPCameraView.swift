//
//  IPCameraView.swift
//  MJPEGViewTest
//
//  Created by 曾勝億 on 2018/9/13.
//  Copyright © 2018年 曾勝億. All rights reserved.
//

import UIKit



class IPCameraView: UIImageView, URLSessionTaskDelegate,URLSessionDataDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var endMarkerData: NSData
    var startMarkerData: NSData
    var receivedData: NSMutableData
    var dataTask: URLSessionDataTask

   
    required init?(coder aDecoder: NSCoder) {
        self.startMarkerData = NSData(bytes: [0xFF, 0xD8] as [UInt8], length: 2)
        self.endMarkerData = NSData(bytes: [0xFF, 0xD9] as [UInt8], length: 2)
        
        
        
        self.receivedData = NSMutableData()
        
        
        
        self.dataTask = URLSessionDataTask()
        
       super.init(coder: aDecoder)
        
      
    }
    
    
   
    
   
    
    deinit{
        self.dataTask.cancel()
    }
    
    func startWithURL(url:URL){
        NSLog( "startWithURL" )
        
     
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        
        
        let request = URLRequest(url: url   )
        
        self.dataTask = session.dataTask(with: request)
        
        
       
        
        
        // Initialization code
        
        self.dataTask.resume()
        
        let bounds = self.bounds
        self.frame = bounds
        self.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func pause() {
        self.dataTask.cancel()
    }
    
    func stop(){
        self.pause()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.receivedData.append(data)
        
        NSLog( "Did receive data" )
        NSLog( "Length: %d", self.receivedData.length )
        var startRange:NSRange = self.receivedData.range(of: self.startMarkerData as Data, options: .backwards, in: NSMakeRange(0, self.receivedData.length))
        var endRange:NSRange = self.receivedData.range(of: self.endMarkerData as Data, options: .backwards, in: NSMakeRange(0, self.receivedData.length))
        
        //            NSRange endRange = [_receivedData rangeOfData:_endMarkerData
        //                options:0
        //                range:NSMakeRange(0, _receivedData.length)];
        var startLocation: Int = startRange.location
        var endLocation: Int = endRange.location + endRange.length
        NSLog( "EndLocation: %d", endLocation)
        //long long endLocation = endRange.location + endRange.length;
        
        if startRange.location != NSNotFound &&  endRange.location != NSNotFound{
            
            var imageData = self.receivedData.subdata(with: NSMakeRange(startLocation, endLocation))
            var receivedImage = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = receivedImage
            }
            
            
            
            
            NSLog( "Length: %d", imageData.count )
            
            self.receivedData = NSMutableData(data: self.receivedData.subdata(with: NSMakeRange(endLocation, self.receivedData.length - endLocation)))
            
        }
    }
    
   
        

}
