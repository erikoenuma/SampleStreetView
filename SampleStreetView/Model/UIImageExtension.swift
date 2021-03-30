//
//  UIImageExtension.swift
//  SampleStreetView
//
//  Created by 肥沼英里 on 2021/03/31.
//

import Foundation
import UIKit

extension UIImage{
    
    func resize(size: CGSize)->UIImage{
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        else {return UIImage()}
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
