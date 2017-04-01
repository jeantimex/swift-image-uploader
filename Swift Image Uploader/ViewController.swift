//
//  ViewController.swift
//  Swift Image Uploader
//
//  Created by Yong Su on 3/31/17.
//  Copyright © 2017 jeantimex. All rights reserved.
//

import UIKit
import Alamofire
import Cartography

class ViewController: UIViewController {
    
    var imageView1: UIImageView = UIImageView()
    var imageView2: UIImageView = UIImageView()
    
    lazy var submitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Submit", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(onSubmitButtonClicked(sender:)), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(submitButton)
        
        imageView1.image = UIImage(named: "yosemite1")
        imageView2.image = UIImage(named: "yosemite2")
        
        imageView1.contentMode = .scaleAspectFill
        imageView2.contentMode = .scaleAspectFill
        
        imageView1.clipsToBounds = true
        imageView2.clipsToBounds = true
        
        self.view.addSubview(imageView1)
        self.view.addSubview(imageView2)
        
        constrain(submitButton, view) { submitButton, view in
            submitButton.width == 80
            submitButton.height == 30
            submitButton.centerX == view.centerX
            submitButton.centerY == view.centerY
        }
        
        constrain(imageView1, view) { imageView, view in
            imageView.width == 100
            imageView.height == 100
            imageView.centerX == view.centerX - 60
            imageView.centerY == view.top + 150
        }
        
        constrain(imageView2, view) { imageView, view in
            imageView.width == 100
            imageView.height == 100
            imageView.centerX == view.centerX + 60
            imageView.centerY == view.top + 150
        }
    }
    
    func onSubmitButtonClicked(sender: UIButton) {
        let imageData1 = UIImageJPEGRepresentation(imageView1.image!, 0.5)!
        let imageData2 = UIImageJPEGRepresentation(imageView2.image!, 0.5)!
        
        let params: [String : AnyObject] = [:]
        
        Alamofire.upload(multipartFormData: { formData in
            formData.append(imageData1, withName: "file", fileName: "image1.jpg", mimeType: "image/jpeg")
            formData.append(imageData2, withName: "file", fileName: "image2.jpg", mimeType: "image/jpeg")
            
            for (key, value) in params {
                if let data = value.data(using: String.Encoding.utf8.rawValue) {
                    formData.append(data, withName: key)
                }
            }
        },
        to: "http://localhost:5000",
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload
                    .validate()
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            print("responseObject: \(value)")
                        case .failure(let responseError):
                            print("responseError: \(responseError)")
                        }
                }
            case .failure(let encodingError):
                print("encodingError: \(encodingError)")
            }
        })
    }

}
