//
//  App_Utility.swift
//  stompsessions
//
//  Created by Bitcot Inc on 12/19/16.
//  Copyright © 2016 Bitcot Inc. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
//import Mixpanel

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

func addCustomNavigationBar(viewController:UIViewController,height:CGFloat) -> CustomNavigationBar{
    let customNavigation = CustomNavigationBar(frame: CGRect(x: 0, y: 0, width: viewController.view.frame.width, height: height) , target: viewController)
    viewController.view.addSubview(customNavigation)
    return customNavigation
}

public func fetchName(firstName:String, lastName:String?) -> String{
    if lastName != nil && !(lastName?.isEmpty)! {
        return firstName + " " + lastName!
    }
    else{
        return "\(firstName)"
    }
}

func getTimeString(dateTimeString: String) -> String{
    // create dateFormatter with UTC time format
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
    let date = dateFormatter.date(from: dateTimeString)
    
    // change to a readable time format and change to local time zone
    dateFormatter.dateFormat = "HH:mm aa"
    dateFormatter.timeZone = NSTimeZone.local
    let timeStamp = dateFormatter.string(from: date!)
    
    return timeStamp
}

func getDateFromTZString(string:String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
    let date = dateFormatter.date(from: string)
    
    return date!
}


func convertSeconds(totalSeconds: Int) -> (min:Int, sec:Int){
    let seconds = totalSeconds % 60
    let minutes = (totalSeconds / 60)
    return (minutes, seconds)
}

func timeToString(min:Int, sec:Int) -> (min:String, sec:String) {
    let minString = String(format: "%03d", min)
    let secString = String(format: "%02d", sec)
    return (minString, secString)
}

func generateThumbImage(url : URL) -> UIImage{
    let asset : AVAsset = AVAsset.init(url: url)
    let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
    assetImgGenerate.appliesPreferredTrackTransform = true
    let time        : CMTime = CMTimeMake(1, 30)
    var img:CGImage!
    do{
        img =  try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
    }catch{
        
    }
    let frameImg    : UIImage = UIImage(cgImage: img)
    return frameImg
}


func fetchLastComponentFrom(url:String) -> String{
    let arr = url.components(separatedBy: "/")
    return arr.last!
}

//func loadUserIntoMixPanel(){
//    let mixPanel = MixpanelEvent.sharedInstance
//    let user = LoggedInUser.sharedInstance
//    mixPanel.crreateUserId(userId: "\(user.userID!)")
//    let properties = ["email":user.email!, "first_name":user.firstName!, "last_name":user.lastName ?? ""]
//    mixPanel.setUser(properties: properties)
//}

func downloadedFrom(url: URL, completionBlock:@escaping (UIImage) -> Void) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage(data: data)
            else { return }
        DispatchQueue.main.async() { () -> Void in
            completionBlock(image)
        }
        }.resume()
}

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

extension UITextView {
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

open class CollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?.map { $0.representedElementKind == nil ? layoutAttributesForItem(at: $0.indexPath)! : $0 }
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes,
            let collectionView = self.collectionView else {
                // should never happen
                return nil
        }
        
        let sectionInset = evaluatedSectionInsetForSection(at: indexPath.section)
        
        guard indexPath.item != 0 else {
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        
        guard let previousFrame = layoutAttributesForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section))?.frame else {
            // should never happen
            return nil
        }
        
        // if the current frame, once left aligned to the left and stretched to the full collection view
        // widht intersects the previous frame then they are on the same line
        guard previousFrame.intersects(CGRect(x: sectionInset.left, y: currentItemAttributes.frame.origin.y, width: collectionView.frame.width - sectionInset.left - sectionInset.right, height: currentItemAttributes.frame.size.height)) else {
            // make sure the first item on a line is left aligned
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        
        currentItemAttributes.frame.origin.x = previousFrame.origin.x + previousFrame.size.width + evaluatedMinimumInteritemSpacingForSection(at: indexPath.section)
        return currentItemAttributes
    }
    
    func evaluatedMinimumInteritemSpacingForSection(at section: NSInteger) -> CGFloat {
        return (collectionView?.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
    }
    
    func evaluatedSectionInsetForSection(at index: NSInteger) -> UIEdgeInsets {
        return (collectionView?.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView!, layout: self, insetForSectionAt: index) ?? sectionInset
    }
}

extension UICollectionViewLayoutAttributes {
    func leftAlignFrame(withSectionInset sectionInset: UIEdgeInsets) {
        frame.origin.x = sectionInset.left
    }
}

extension Dictionary {
    
    var json: JSONDictionary? {
        do {
           // let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
           // return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? JSONDictionary {
                // use dictFromJSON
                return dictFromJSON
            }else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
   
    
    func printJson() {
        print(json)
    }
    
}

