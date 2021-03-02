//
//  Reachability.swift
//  News
//
//  Created by Daniel Nunez on 01-03-21.
//
import Alamofire

public class Reachability {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToNetwork: Bool {
        return sharedInstance.isReachable
    }
}
