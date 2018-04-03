//
//  Extensions.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 02/04/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit

extension UITextView: UITextViewDelegate {
    
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
    }
    
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.white
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(message: String, title: String = "", completion: @escaping (()->())) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default){
            UIAlertAction in
            completion()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIColor {
    
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted).lowercased()
        var int = UInt32()
        Scanner(string: hexString).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hexString.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
}

extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String, completion: @escaping(()->())) {
        
        let activityIndicator = UIActivityIndicatorView()

        self.superview?.addSubview(activityIndicator)
        activityIndicator.frame = self.frame
        activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                activityIndicator.stopAnimating()
                print(error!.localizedDescription)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                activityIndicator.stopAnimating()
                let image = UIImage(data: data!)
                self.image = image
                completion()
            })
            
        }).resume()
    }
}

extension UIButton {
    public func imageFromServerURL(urlString: String, completion: @escaping(()->())) {
        
        let activityIndicator = UIActivityIndicatorView()
        
        self.superview?.addSubview(activityIndicator)
        activityIndicator.frame = self.frame
        activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                activityIndicator.stopAnimating()
                print(error!.localizedDescription)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                activityIndicator.stopAnimating()
                self.setImage(UIImage(data: data!), for: .normal)
                completion()
            })
            
        }).resume()
    }
}

