import XCTest
@testable import DirectoryMonitor

extension DirectoryMonitorTests {

    func testInitializer() {
        let url = URL(fileURLWithPath: DirectoryMonitorTests.directory)
        let monitor = DirectoryMonitor(at: url) { print("Directory did change.") }

        XCTAssertNotNil(monitor)
    }

}
