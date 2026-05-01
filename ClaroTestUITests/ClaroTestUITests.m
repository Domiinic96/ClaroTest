#import <XCTest/XCTest.h>

@interface ClaroTestUITests : XCTestCase

@property (nonatomic, strong) XCUIApplication *app;

@end

@implementation ClaroTestUITests

- (void)setUp {
    self.continueAfterFailure = NO;
    
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
}


- (void)testListLoads {
    
    XCUIElement *table = self.app.tables.firstMatch;
    XCTAssertTrue(table.exists);
}


- (void)testSearchContact {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    app.launchArguments = @[@"UITEST_MODE"];
    [app launch];
    
    XCUIElement *text = app.staticTexts[@"Test User"];
    XCTAssertTrue([text waitForExistenceWithTimeout:5]);
    
    XCUIElement *searchField = app.searchFields.firstMatch;
    XCTAssertTrue([searchField waitForExistenceWithTimeout:5]);
    
    [searchField tap];
    [searchField typeText:@"829"];
    
    XCTAssertTrue([text waitForExistenceWithTimeout:5]);
}

- (void)testEmptySearchShowsMessage {
    
    XCUIElement *searchField = self.app.searchFields.firstMatch;
    [searchField tap];
    [searchField typeText:@"zzzzzzz"];
    
    XCUIElement *label = self.app.staticTexts[@"No hay resultados para su búsqueda"];
    XCTAssertTrue(label.exists);
}


- (void)testOpenDetail {
    
    self.app.launchArguments = @[@"UITEST_MODE"];
    [self.app launch];
    
    XCUIElement *cell = self.app.tables.cells.firstMatch;
    
    XCTAssertTrue([cell waitForExistenceWithTimeout:5]);
    
    [cell tap];
    
    XCUIElement *navBar = self.app.navigationBars.firstMatch;
    XCTAssertTrue([navBar waitForExistenceWithTimeout:5]);
}

- (void)testOpenAddContact {
    
    XCUIElement *newButton = self.app.navigationBars.buttons[@"Nuevo"];
    XCTAssertTrue(newButton.exists);
    
    [newButton tap];
    
    XCUIElement *cancelButton = self.app.navigationBars.buttons[@"Cancelar"];
    XCTAssertTrue(cancelButton.exists);
}

#pragma mark - Performance

- (void)testLaunchPerformance {
    [self measureWithMetrics:@[[[XCTApplicationLaunchMetric alloc] init]] block:^{
        [[[XCUIApplication alloc] init] launch];
    }];
}

@end
