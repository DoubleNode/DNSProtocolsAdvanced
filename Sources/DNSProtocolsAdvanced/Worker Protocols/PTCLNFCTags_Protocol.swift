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
import DNSProtocols
import Foundation

public enum PTCLNFCTagsError: Error
{
    case unknown(domain: String, file: String, line: String, method: String)
    case notSupported(domain: String, file: String, line: String, method: String)
    case systemError(error: Error, domain: String, file: String, line: String, method: String)
    case timeout(domain: String, file: String, line: String, method: String)
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
        case .unknown(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .notSupported(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notSupported.rawValue,
                                userInfo: userInfo)
        case .systemError(let error, let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "Error": error, "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.systemError.rawValue,
                                userInfo: userInfo)
        case .timeout(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.timeout.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("NFC-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .notSupported:
            return NSLocalizedString("NFC-Not Supported", comment: "")
                + " (\(Self.domain):\(Self.Code.notSupported.rawValue))"
        case .systemError(let error, _, _, _, _):
            return String(format: NSLocalizedString("NFC-System Error: %@", comment: ""), error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.systemError.rawValue))"
        case .timeout:
            return NSLocalizedString("NFC-Reader Timeout", comment: "")
                + " (\(Self.domain):\(Self.Code.timeout.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .notSupported(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .systemError(_, let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .timeout(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
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
