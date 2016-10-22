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
    let directoryMonitorQueue = DispatchQueue(label: "io.up-n-down.directorymonitor")

    /// A dispatch source to monitor a file descriptor created from the directory.
    var directoryMonitorSource: DispatchSourceProtocol?

    /// URL for the directory being monitored.
    var URL: URL

    // MARK: Initializers

    init(URL: URL) {
        self.URL = URL
        NSLog("Directory Monitor @ \(URL)")
    }

    // MARK: Monitoring

    func startMonitoring() {
        // Listen for changes to the directory (if we are not already).
        if directoryMonitorSource == nil && fileDescriptor == -1 {

            NSLog("Start monitoring \(URL) for changes.")

            // Open the directory referenced by URL for monitoring only.
            fileDescriptor = open(URL.path, O_EVTONLY)

            // Define a dispatch source monitoring the directory for additions, deletions, and renamings.
            directoryMonitorSource = DispatchSource.makeFileSystemObjectSource(
                fileDescriptor: fileDescriptor,
                eventMask: .write,
                queue: directoryMonitorQueue
            )

            // Define the block to call when a file change is detected.
            directoryMonitorSource?.setEventHandler(handler: {
                // Call out to the `DirectoryMonitorDelegate` so that it can react appropriately to the change.
                self.delegate?.directoryMonitor(self, directoryDidChangeAt: self.URL)
            })

            // Define a cancel handler to ensure the directory is closed when the source is cancelled.
            directoryMonitorSource?.setCancelHandler(handler: {
                close(self.fileDescriptor)

                self.fileDescriptor = -1

                self.directoryMonitorSource = nil
            })

            // Start monitoring the directory via the source.
            directoryMonitorSource?.resume()
        }
    }

    func stopMonitoring() {
        // Stop listening for changes to the directory, if the source has been created.
        if directoryMonitorSource != nil {
            // Stop monitoring the directory via the source.
            directoryMonitorSource?.cancel()
        }
        
        NSLog("Stop monitoring \(URL) for changes.")
    }
}
