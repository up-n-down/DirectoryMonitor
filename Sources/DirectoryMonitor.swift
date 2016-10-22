import Foundation

/// A protocol that allows delegates of `DirectoryMonitor` to respond to changes in a directory.
protocol DirectoryMonitorDelegate: class {

    func directoryMonitor(_ directoryMonitor: DirectoryMonitor, directoryDidChangeAt directory: URL)
}

class DirectoryMonitor {

    // MARK: Properties

    /// The `DirectoryMonitor`'s delegate who is responsible for responding to `DirectoryMonitor` updates.
    weak var delegate: DirectoryMonitorDelegate?

    /// A file descriptor for the monitored directory.
    var fileDescriptor: CInt = -1

    /// A dispatch queue used for sending file changes in the directory.
    let queue = DispatchQueue(label: "io.up-n-down.directorymonitor")

    /// A dispatch source to monitor a file descriptor created from the directory.
    var source: DispatchSourceProtocol?

    /// URL for the directory being monitored.
    var url: URL

    // MARK: Initializers

    init(url: URL) {
        self.url = url
        NSLog("Directory Monitor @ \(url)")
    }

    // MARK: Monitoring

    func startMonitoring() {
        // Listen for changes to the directory (if we are not already).
        if source == nil && fileDescriptor == -1 {

            NSLog("Start monitoring \(url) for changes.")

            // Open the directory referenced by URL for monitoring only.
            fileDescriptor = open(url.path, O_EVTONLY)

            // Define a dispatch source monitoring the directory for additions, deletions, and renamings.
            source = DispatchSource.makeFileSystemObjectSource(
                fileDescriptor: fileDescriptor,
                eventMask: .write,
                queue: queue
            )

            // Define the block to call when a file change is detected.
            source?.setEventHandler(handler: {
                // Call out to the `DirectoryMonitorDelegate` so that it can react appropriately to the change.
                self.delegate?.directoryMonitor(self, directoryDidChangeAt: self.url)
            })

            // Define a cancel handler to ensure the directory is closed when the source is cancelled.
            source?.setCancelHandler(handler: {
                close(self.fileDescriptor)

                self.fileDescriptor = -1

                self.source = nil
            })

            // Start monitoring the directory via the source.
            source?.resume()
        }
    }

    func stopMonitoring() {
        // Stop listening for changes to the directory, if the source has been created.
        if source != nil {
            // Stop monitoring the directory via the source.
            source?.cancel()
        }
        
        NSLog("Stop monitoring \(url) for changes.")
    }
}
