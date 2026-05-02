#import <XCTest/XCTest.h>
#import "UsersViewController.h"
#import "Contact.h"

@interface UsersViewController (Test)
@property (nonatomic, strong) NSMutableArray<Contact *> *users;
@property (nonatomic, strong) NSArray<Contact *> *filteredUsers;
@property (nonatomic, strong) UISearchController *searchController;
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;
- (void)updateEmptyState;
@end

@interface UsersViewControllerTests : XCTestCase

@property (nonatomic, strong) UsersViewController *vc;

@end

@implementation UsersViewControllerTests

- (void)setUp {
    [super setUp];
    
    self.vc = [[UsersViewController alloc] init];
    [self.vc loadViewIfNeeded];
    
    Contact *c1 = [Contact new];
    c1.name = @"Luis";
    c1.lastName = @"Santana";
    c1.phone = @"8291234567";
    
    Contact *c2 = [Contact new];
    c2.name = @"Maria";
    c2.lastName = @"Lopez";
    c2.phone = @"8099999999";
    
    self.vc.users = [@[c1, c2] mutableCopy];
    self.vc.filteredUsers = self.vc.users;
    
    self.vc.searchController = [[UISearchController alloc] init];
}

#pragma mark - Search

- (void)testSearchFiltersByName {
    
    self.vc.searchController.active = YES;
    self.vc.searchController.searchBar.text = @"luis";
    
    [self.vc updateSearchResultsForSearchController:self.vc.searchController];
    
    XCTAssertEqual(self.vc.filteredUsers.count, 1);
}

#pragma mark - Empty State

- (void)testEmptyStateWhenNoData {
    
    self.vc.users = [NSMutableArray array];
    self.vc.filteredUsers = self.vc.users;
    
    [self.vc updateEmptyState];
    
    XCTAssertNotNil(self.vc.tableView.backgroundView);
}

#pragma mark - Delete

- (void)testDeleteUser {
    
    Contact *toDelete = self.vc.users.firstObject;
    
    [self.vc.users removeObject:toDelete];
    self.vc.filteredUsers = self.vc.users;
    
    XCTAssertEqual(self.vc.users.count, 1);
}

- (void)testDeleteUserViaDelegate {
    
    NSInteger initialCount = self.vc.users.count;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.vc tableView:self.vc.tableView
commitEditingStyle:UITableViewCellEditingStyleDelete
forRowAtIndexPath:indexPath];
    
    XCTAssertEqual(self.vc.users.count, initialCount - 1);
}

- (void)testSearchFiltersByPhone {
    
    self.vc.searchController.active = YES;
    self.vc.searchController.searchBar.text = @"809";
    
    [self.vc updateSearchResultsForSearchController:self.vc.searchController];
    
    XCTAssertEqual(self.vc.filteredUsers.count, 1);
    
    Contact *result = self.vc.filteredUsers.firstObject;
    XCTAssertEqualObjects(result.phone, @"8099999999");
}

@end
