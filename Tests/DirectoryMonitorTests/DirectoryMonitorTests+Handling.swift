import XCTest
@testable import DirectoryMonitor

extension DirectoryMonitorTests {

    func testCreatingFile() {
        var handlingNewFile: XCTestExpectation? = expectation(description: "Event handler should be called when creating new file.")
        let url = URL(fileURLWithPath: DirectoryMonitorTests.directory)
        let monitor = DirectoryMonitor(at: url)

        monitor.startMonitoring {
            handlingNewFile?.fulfill()
            handlingNewFile = nil // Workaround for API violation caused by multiple calls to expectation.
        }

        createFile()

        monitor.stopMonitoring()

        waitForExpectations(timeout: 1) { XCTAssertNil($0) }
    }

    func testEditingFile() {
        var handlingEditedFile: XCTestExpectation? = expectation(description: "Event handler should be called when editing file.")
        let url = URL(fileURLWithPath: DirectoryMonitorTests.directory)
        let monitor = DirectoryMonitor(at: url)

        monitor.startMonitoring {
            handlingEditedFile?.fulfill()
            handlingEditedFile = nil // Workaround for API violation caused by multiple calls to expectation.
        }

        editFile()

        monitor.stopMonitoring()

        waitForExpectations(timeout: 1) { XCTAssertNil($0) }
    }
    
}
