import Foundation

public class DirectoryMonitor {

    public typealias EventHandler = (() -> ())

    // MARK: Properties

    /// A file descriptor for the monitored directory.
    private var fileDescriptor: CInt = -1

    /// A dispatch queue used for sending file changes in the directory.
    private let queue = DispatchQueue(label: "io.up-n-down.directorymonitor")

    /// A dispatch source to monitor a file descriptor created from the directory.
    private var source: DispatchSourceProtocol?

    /// URL for the directory being monitored.
    private var url: URL

    // MARK: Initializers

    public init(at url: URL) {
        self.url = url
    }

    // MARK: Monitoring

    public func startMonitoring(_ handler: @escaping EventHandler) {
        // Listen for changes to the directory (if we are not already).
        if source == nil && fileDescriptor == -1 {

            NSLog("Start monitoring \(url) for changes.")

            // Open the directory referenced by URL for monitoring only.
            fileDescriptor = open(url.path, O_EVTONLY)

            // Define a dispatch source monitoring the directory for additions, deletions, and renamings.
            source = DispatchSource.makeFileSystemObjectSource(
                fileDescriptor: fileDescriptor,
                eventMask: .all,
                queue: queue
            )

            // Define the work item to call when a file change is detected.
            source?.setEventHandler(handler: handler)

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

    public func stopMonitoring() {
        // Stop listening for changes to the directory, if the source has been created.
        if source != nil {
            // Stop monitoring the directory via the source.
            source?.cancel()
        }
        
        NSLog("Stop monitoring \(url) for changes.")
    }

}
