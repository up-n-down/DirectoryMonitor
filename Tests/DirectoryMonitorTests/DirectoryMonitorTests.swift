import XCTest
@testable import DirectoryMonitor

class DirectoryMonitorTests: XCTestCase {

    static let directory = NSTemporaryDirectory().appending("io.up-n-down.directorymonitor")
    static let file = directory.appending("/testfile.txt")


    // MARK: - Set up + Tear down
    override func setUp() {
        super.setUp()

        do {
            try FileManager.default.createDirectory(atPath: DirectoryMonitorTests.directory,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch _ {
            print("Unable to create temporary directory for tests.")
        }
    }

    override func tearDown() {
        do {
            try FileManager.default.removeItem(atPath: DirectoryMonitorTests.directory)
        } catch _ {
            print("Unable to remove temporary directory for tests.")
        }

        super.tearDown()
    }


    // MARK: - File Operations

    func createFile() {
        let success = FileManager.default.createFile(atPath: DirectoryMonitorTests.file,
                                                     contents: nil,
                                                     attributes: nil)

        if !success {
            XCTFail("Unable to create file.")
        }
    }

}
