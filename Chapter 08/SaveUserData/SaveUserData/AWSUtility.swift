//
//  AWSHelper.swift
//  SaveUserData
//

import UIKit
import Foundation
import AWSS3
import ClientRuntime
import AWSClientRuntime

//import NIO
import Network

class AWSUtility {
    
    let bucket = "userimagesawsutility"
    
    
    init() {
        
    }
    
    func getS3BucketNames() async throws -> [String] {
        
        // Get an S3Client to the access Amazon S3.
        let s3Client = try S3Client(region: "us-east-1")
            
        let s3Output = try await s3Client.listBuckets(
            input: ListBucketsInput()
        )
        
        // Getting the bucket names.
        var bucketNames: [String] = []

        guard let buckets = s3Output.buckets else {
            return bucketNames
        }
        for bucket in buckets {
            if let bucketName = bucket.name {
                print("Bucket Name: \(bucketName)")
                bucketNames.append(bucketName)
            }
        }

        return bucketNames
    }
    
    
    
    /// Upload an image to an S3 bucket.
    /// - Parameters:
    ///   - bucket: bucket name
    ///   - key: unique key for the image
    ///   - data: Image data
    func uploadImage(key: String, withData data: Data) async throws {
        let client = try S3Client(region: "us-east-1")
        let dataStream = ByteStream.data(data)
        
        let input = PutObjectInput(
            acl: .publicRead,
            body: .byteStream(dataStream),
            bucket: bucket,
            contentLength: Int64(data.count),
            key: key
        )
        
        _ = try await client.putObject(input: input)
    }
    
    func getImage(with key: String) async throws -> UIImage? {
        
        let data = try await readFile(key: key)
        let image = UIImage(data: data)
        
        return image
    }


    func readFile(key: String) async throws -> Data {
        let s3Client = try S3Client(region: "us-east-1")
        let s3Input = GetObjectInput(
            bucket: bucket,
            key: key
        )
        let output = try await s3Client.getObject(input: s3Input)
        
        guard let body = output.body,
              let data = try await body.readData() else {
            return "".data(using: .utf8)!
        }
        
        return data
    }

    
    
//    func getBucketNames() async throws -> [String] {
//        // Get an S3Client with which to access Amazon S3.
//        let client = try S3Client(region: "us-east-1")
//        let config: S3Client.S3ClientConfiguration
//        do {
//
//          
//            
//        
//        } catch {
//            print("There is error")
//            exit(1)
//        }
//       
//        
//        
//        let output = try await client.listBuckets(
//            input: ListBucketsInput()
//        )
//        
//        // Get the bucket names.
//        var bucketNames: [String] = []
//
//        guard let buckets = output.buckets else {
//            return bucketNames
//        }
//        for bucket in buckets {
//            bucketNames.append(bucket.name ?? "<unknown>")
//        }
//
//        return bucketNames
//    }
//    
//    
    //let client = S3Client
    
    
//
//        
//    func uploadImage(_ image: UIImage, sender: UIViewController, completion: @escaping (String?) -> ()) {
//        
//        // check internet connection
//
//        guard let imageData = image.jpegData(compressionQuality: 1) else {
//            completion(nil)
//            return
//        }
//        
//        let uuid = UUID().uuidString
//        let fileName = "\(uuid).jpeg"
//        
//        let putObjectRequest = S3.PutObjectRequest(acl: .publicRead,
//                                                   body: .data(imageData),
//                                                   bucket: bucket,
//                                                   contentLength: Int64(imageData.count),
//                                                   key: fileName)
//        
//        
//        // Put an Object
////        let putObjectRequest = S3.PutObjectRequest(acl: .publicRead,
////                                                   body: .string(imageData.base64EncodedString()),
////                                                   bucket: bucket,
////                                                   contentLength: Int64(imageData.count),
////                                                   key: fileName)
//        
//       
//       // let client = S3(client: client, region: .useast1)
////        client.putObject(putObjectRequest).whenComplete { result in
////            switch result {
////            case .failure(let error):
////                print("Error uploading image: \(error)")
////                completion(nil)
////            case .success:
////                completion(fileName)
////                print("Image uploaded successfully")
////            }
////        }
//        

   // }
    
}
