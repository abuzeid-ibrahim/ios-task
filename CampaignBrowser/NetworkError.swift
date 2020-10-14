//
//  NetworkError.swift
//  CampaignBrowser
//
//  Created by abuzeid on 14.10.20.
//  Copyright © 2020 Westwing GmbH. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case noConnection

    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "There was an error. Please check your internet connection and try again."
        }
    }

    var code: Int {
        switch self {
        case .noConnection:
            return NSURLErrorNotConnectedToInternet
        }
    }
}

extension NetworkError {
    static func == (lhs: Error, rhs: NetworkError) -> Bool {
        return lhs._code == rhs.code
    }
}

