//
//  String+Extension.swift
//  JMNetworkKit_Example
//
//  Created by 최정민 on 2022/03/23.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

extension String {
    public func log(where location: String? = nil) {
        print("\n")
        print("-------------------------------------------------------------")
        print(" Message : \(self)")
        if let location = location {
            print(" Where   : \(location)")
        }
        print(" When    : \(Date())")
        print("-------------------------------------------------------------")
        print("\n")
    }
}
