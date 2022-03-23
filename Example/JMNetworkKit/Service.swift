//
//  Service.swift
//  JMNetworkKit_Example
//
//  Created by 최정민 on 2022/03/23.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import JMNetworkKit

class Service {
    var currentModel = Model(currentDateTime: Date())
    
    func fetchNow(onCompleted: @escaping (Model) -> Void) {
        guard let url = URL(string: "http://worldclockapi.com/api/json/utc/now") else { return }
        
        NetworkManager.shared.sendRequest(url: url, response: UtcTimeModel.self) { [weak self] result in
            switch result {
            case .success(let response) :
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"

                guard let now = formatter.date(from: response.currentDateTime) else { return }

                let model = Model(currentDateTime: now)
                self?.currentModel = model

                onCompleted(model)
            case .failure(let error) :
                "\(error)".log(where: "Service/fetchNow")
            }
        }
    }

    func moveDay(day: Int) {
        guard let movedDay = Calendar.current.date(byAdding: .day, value: day, to: currentModel.currentDateTime) else { return }
        currentModel.currentDateTime = movedDay
    }
}
