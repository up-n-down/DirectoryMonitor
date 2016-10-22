import XCTest
@testable import DirectoryMonitor

class DirectoryMonitorTests: XCTestCase {

    let directory = NSTemporaryDirectory().appending("io.up-n-down.directorymonitor")

    // MARK: - Set up + Tear down
    override func setUp() {
        super.setUp()

        do {
            try FileManager.default.createDirectory(atPath: directory,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch _ {
            print("Unable to create temporary directory for tests.")
        }
    }

    override func tearDown() {
        do {
            try FileManager.default.removeItem(atPath: directory)
        } catch _ {
            print("Unable to remove temporary directory for tests.")
        }

        super.tearDown()
    }

    // MARK: - Tests

    func testInitializer() {
        XCTAssertNotNil(DirectoryMonitor(URL: URL(fileURLWithPath: directory)))
    }

    func testDelegate() {
        let url = URL(fileURLWithPath: directory)
        let monitor = DirectoryMonitor(URL: url)
        monitor.delegate = self
        monitor.startMonitoring()

        createFile()

        monitor.stopMonitoring()
    }

    // MARK: - File Operations

    private func createFile() {
        let success = FileManager.default.createFile(atPath: directory.appending("/testfile.txt"),
                                                     contents: nil,
                                                     attributes: nil)

        if !success {
            XCTFail("Unable to create file.")
        }
    }

}

// MARK: - Directory Monitor Delegate

extension DirectoryMonitorTests: DirectoryMonitorDelegate {

    func directoryMonitor(_ directoryMonitor: DirectoryMonitor, directoryDidChangeAt directory: URL) {
        print("Directory did change.")
    }
    
}
