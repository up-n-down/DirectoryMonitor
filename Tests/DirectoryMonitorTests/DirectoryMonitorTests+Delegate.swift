import XCTest
@testable import DirectoryMonitor

extension DirectoryMonitorTests {

    func testDelegate() {
        let url = URL(fileURLWithPath: DirectoryMonitorTests.directory)
        let monitor = DirectoryMonitor(URL: url)
        monitor.delegate = self
        monitor.startMonitoring()

        createFile()

        monitor.stopMonitoring()
    }
    
}

// MARK: - Directory Monitor Delegate

extension DirectoryMonitorTests: DirectoryMonitorDelegate {

    func directoryMonitor(_ directoryMonitor: DirectoryMonitor, directoryDidChangeAt directory: URL) {
        print("Directory did change.")
    }

}
