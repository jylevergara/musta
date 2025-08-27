import XCTest
@testable import musta

final class LanguageManagerTests: XCTestCase {
    var languageManager: LanguageManager!
    
    override func setUpWithError() throws {
        languageManager = LanguageManager()
    }
    
    override func tearDownWithError() throws {
        languageManager = nil
    }
    
    func testLanguageManagerInitialization() throws {
        XCTAssertNotNil(languageManager)
        XCTAssertFalse(languageManager.isLoading)
    }
    
    func testLoadLanguages() throws {
        languageManager.loadLanguages()
        
        // Wait a bit for async loading
        let expectation = XCTestExpectation(description: "Languages loaded")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertFalse(languageManager.languages.isEmpty)
    }
}
