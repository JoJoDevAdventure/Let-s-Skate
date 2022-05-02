//
//  StorageError.swift
//  Let's Skate
//
//  Created by Youssef Bhl on 02/05/2022.
//

import Foundation

enum StorageError : Error, CaseIterable{
    case FIRStorageErrorCodeUnknown
    case FIRStorageErrorCodeObjectNotFound
    case FIRStorageErrorCodeBucketNotFound
    case FIRStorageErrorCodeProjectNotFound
    case FIRStorageErrorCodeQuotaExceeded
    case FIRStorageErrorCodeUnauthenticated
    case FIRStorageErrorCodeUnauthorized
    case FIRStorageErrorCodeRetryLimitExceeded
    case FIRStorageErrorCodeNonMatchingChecksum
    case FIRStorageErrorCodeCanceled
    case FIRStorageErrorCodeDownloadSizeExceeded
}
