import XCTest
@testable import DirectoryMonitor

class DirectoryMonitorTests: XCTestCase {

    func testInitializer() {
        XCTAssertNotNil(DirectoryMonitor(URL: URL(fileURLWithPath: "~")))
    }

}
