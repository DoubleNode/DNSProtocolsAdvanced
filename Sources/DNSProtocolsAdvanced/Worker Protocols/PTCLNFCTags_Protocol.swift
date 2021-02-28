//
//  PTCLNFCTags_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsAdvanced
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

#if !os(macOS)
import CoreNFC
#endif
import DNSCoreThreading
import DNSError
import DNSProtocols
import Foundation

public enum PTCLNFCTagsError: Error
{
    case unknown(_ codeLocation: DNSCodeLocation)
    case notSupported(_ codeLocation: DNSCodeLocation)
    case systemError(error: Error, _ codeLocation: DNSCodeLocation)
    case timeout(_ codeLocation: DNSCodeLocation)
}

extension PTCLNFCTagsError: DNSError {
    public static let domain = "NFC"
    public enum Code: Int
    {
        case unknown = 1001
        case notSupported = 1002
        case systemError = 1003
        case timeout = 1004
    }
    
    public var nsError: NSError! {
        switch self {
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .notSupported(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notSupported.rawValue,
                                userInfo: userInfo)
        case .systemError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.systemError.rawValue,
                                userInfo: userInfo)
        case .timeout(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.timeout.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return NSLocalizedString("NFC-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .notSupported:
            return NSLocalizedString("NFC-Not Supported", comment: "")
                + " (\(Self.domain):\(Self.Code.notSupported.rawValue))"
        case .systemError(let error, _):
            return String(format: NSLocalizedString("NFC-System Error: %@", comment: ""), error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.systemError.rawValue))"
        case .timeout:
            return NSLocalizedString("NFC-Reader Timeout", comment: "")
                + " (\(Self.domain):\(Self.Code.timeout.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notSupported(let codeLocation),
             .systemError(_, let codeLocation),
             .timeout(let codeLocation):
            return codeLocation.failureReason
        }
    }
}

// (object: Any?, error: Error?)
public typealias PTCLNFCTagsBlockVoidArrayNFCNDEFMessageDNSError = ([NFCNDEFMessage], DNSError?) -> Void

public protocol PTCLNFCTags_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLNFCTags_Protocol? { get }
    
    init()
    init(nextWorker: PTCLNFCTags_Protocol)
    
    // MARK: - Business Logic / Single Item CRUD
    func doScanTags(for key: String,
                    with progress: PTCLProgressBlock?,
                    and block: PTCLNFCTagsBlockVoidArrayNFCNDEFMessageDNSError?) throws
}
