import XCTest
@testable import DirectoryMonitor

extension DirectoryMonitorTests {

    func testInitializer() {
        XCTAssertNotNil(DirectoryMonitor(URL: URL(fileURLWithPath: DirectoryMonitorTests.directory)))
    }

}
