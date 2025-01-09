//
//  TransactionDetailsView_ViewModel.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/3/25.
//

import Foundation
import SwiftData
import SwiftUI

extension TransactionDetailsView {
    @Observable
    class ViewModel {
        var account: Account?
        var recurringTransaction: RecurringTransaction? = nil
        var recurringGroup: RecurringGroup? = nil
        var transactionFiles: [TransactionFile] = []
        var url: URL?
        var transaction: AccountTransaction

        init(transaction: AccountTransaction) {
            self.transaction = transaction
        }

        func loadData(modelContext: ModelContext) {
            let transactionID = transaction.id

            var fetchDescriptor = FetchDescriptor<AccountTransaction>(
                predicate: #Predicate<AccountTransaction> {
                    $0.id == transactionID
                })
            fetchDescriptor.fetchLimit = 1
            fetchDescriptor.relationshipKeyPathsForPrefetching = [\.account]
            fetchDescriptor.relationshipKeyPathsForPrefetching = [
                \.recurringTransaction
            ]

            let query = try! modelContext.fetch(fetchDescriptor)
            self.account = query.first!.account!
            self.recurringTransaction = query.first!.recurringTransaction
            self.recurringGroup =
                query.first!.recurringTransaction?.recurringGroup

            var fetchDescriptor_Files = FetchDescriptor<TransactionFile>(
                predicate: #Predicate<TransactionFile> {
                    $0.transactionId == transactionID
                }

            )
            fetchDescriptor_Files.sortBy = [
                .init(\.createdOnUTC, order: .reverse)
            ]
            self.transactionFiles = try! modelContext.fetch(
                fetchDescriptor_Files)
        }
        func addNewDocument() {}

        func addNewPhoto() {}

        func downloadFileForViewing(file: TransactionFile) {
            do {
                if file.data == nil {
                    debugPrint("Empty file data")
                    return
                }

                let documentsDirectory = FileManager.default.urls(
                    for: .documentDirectory, in: .userDomainMask
                ).first!
                let destinationURL = documentsDirectory.appendingPathComponent(
                    file.filename)
                try file.data?.write(to: destinationURL)
                self.url = destinationURL
            } catch {
                debugPrint("Error saving file: \(error)")
            }
        }

        // Should I handle the downloading via async? If the file is huge it might take a hot second.
        //    func downloadImageFromURL(completion: @escaping (URL?) -> Void) {
        //        let monkeyUrlString = "https://www.etherpunk.com/wp-content/uploads/2020/01/monkey1.png"
        //
        //        guard let url = URL(string: monkeyUrlString) else {
        //            debugPrint("Invalid URL: \(monkeyUrlString)")
        //            completion(nil)
        //            return
        //        }
        //
        //        let task = URLSession.shared.dataTask(with: url) { data, _, error in
        //            guard let data = data, error == nil else {
        //                debugPrint("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
        //                completion(nil)
        //                return
        //            }
        //
        //            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //            let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        //
        //            do {
        //                try data.write(to: destinationURL)
        //                completion(destinationURL)
        //            } catch {
        //                debugPrint("Error saving image data: \(error)")
        //                completion(nil)
        //            }
        //        }
        //
        //        task.resume()
        //    }
    }
}
