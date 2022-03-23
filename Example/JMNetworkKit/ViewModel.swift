//
//  ViewModel.swift
//  JMNetworkKit_Example
//
//  Created by 최정민 on 2022/03/23.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

class ViewModel {
    var onUpdated: () -> Void = {}
    var dateTimeString: String = "Loading.."
    {
        didSet {
            onUpdated()
        }
    }
    let service = Service()

    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        return formatter.string(from: date)
    }
    
    func reload() {
        service.fetchNow { [weak self] model in
            guard let self = self else { return }
            let dateString = self.dateToString(date: model.currentDateTime)
            self.dateTimeString = dateString
        }
    }

    func moveDay(day: Int) {
        self.service.moveDay(day: day)
        self.dateTimeString = self.dateToString(date: self.service.currentModel.currentDateTime)
    }
    
}
