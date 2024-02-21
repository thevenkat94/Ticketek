//
//  ApiService.swift
//  Ticketek
//
//  Created by Venkata Prabhu on 21/10/23.
//  Copyright © 2023 Venkata Prabhu. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit
import Network

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatusChanged")
}

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    private let monitor = NWPathMonitor()

    private(set) var isConnected = false
    private(set) var isExpensive = false
    private(set) var currentConnectionType: NWInterface.InterfaceType?

    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status != .unsatisfied
            self.isExpensive = path.isExpensive
            self.currentConnectionType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}


class ApiService {
    
    //MARK: - Get image data
    func getImageDataFrom(url:URL, completion: @escaping ((Data) -> Void)) {
        if NetworkMonitor.shared.isConnected {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                // Handle Error
                if let error = error {
                    print("DataTask error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    // Handle Empty data
                    print("Empty Data")
                    return
                }
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }.resume()
        } else {
            DispatchQueue.main.async {
                UIApplication.shared.windows.first?.rootViewController?.view.makeToast("No internet connection")
            }
        }
    }
}
