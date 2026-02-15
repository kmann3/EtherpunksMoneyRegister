//
//  QuickLookPreviewController.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 4/3/25.
//

import Cocoa
import Quartz

class QuickLookPreviewController: NSObject, QLPreviewPanelDataSource, QLPreviewPanelDelegate {
    var previewItemURL: URL?

    @MainActor
    func showPreview(for data: Data, fileName: String) {
        do {
            let tempDir = FileManager.default.temporaryDirectory
            let uniqueFileName = UUID().uuidString + "-" + fileName
            let tempURL = tempDir.appendingPathComponent(uniqueFileName)

            try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true, attributes: nil)

            print("tempDir: \(tempDir.path)")
            print("fileName: \(fileName)")
            print("tempURL: \(tempURL)")

            try data.write(to: tempURL)

            previewItemURL = tempURL

            QLPreviewPanel.shared().dataSource = self

            if QLPreviewPanel.sharedPreviewPanelExists() {
                QLPreviewPanel.shared().reloadData()
            }

            QLPreviewPanel.shared().makeKeyAndOrderFront(nil)
        } catch {
            print("Failed to write data to file: \(error)")
        }
    }

    func previewPanelDidClose(_ panel: QLPreviewPanel!) {
        print("Attempting to delete temp file")
        if let url = previewItemURL {
            do {
                try FileManager.default.removeItem(at: url)
                print("Deleted temporary file: \(url.path)")
            } catch {
                print("Error deleting temporary file: \(error)")
            }
        }

        previewItemURL = nil
    }

    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return previewItemURL == nil ? 0 : 1
    }

    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        return previewItemURL as QLPreviewItem?
    }
}
