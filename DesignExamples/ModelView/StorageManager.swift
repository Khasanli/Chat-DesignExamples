//
//  StorageManager.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 06.07.21.
//

import Foundation
import FirebaseStorage


final class StorageManager {
    
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    public func uploadProfilePhoto(with data: Data, filename: String, completion: @escaping (Result<String,Error>) -> Void ) {
        storage.child("images/\(filename)").putData(data, metadata: nil) { metadata, error in
            guard error == nil else {
                print("Failed to upload profile image to storage")
                completion(.failure(StorageErrors.failedToUpload))
                return}
            self.storage.child("images/\(filename)").downloadURL { url, error in
                guard let url = url else {
                    print("Failed to download profile image to storage")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return}
                
                let urlString = url.absoluteString
                print("\(urlString)")
                completion(.success(urlString))
            }
        }
    }
    public func updateProfilePhoto(filename: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        storage.child("images/\(filename)").delete { error in
            guard error == nil else {
                completion(.failure(StorageErrors.failedToDelete))
                return
            }
            completion(.success(true))
        }
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
        case failedToDelete

    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void){
        let reference = storage.child(path)
        reference.downloadURL { url, err in
            guard let url = url, err == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return}
            
            completion(.success(url))
            
        }
    }
    
}
