//
//  UsersViewController 2.h
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


#import "UsersViewController.h"
#import <SDWebImage/SDWebImage.h>
#import "ClaroTest-Swift.h"
//#import "Contact.h"


@interface UsersViewController () <UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray<Contact *> *users;
@property (nonatomic, strong) NSArray<Contact *> *filteredUsers;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) ContactRepository *repo;


@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Constants.users;
    
    ContactStorage *storage = [[ContactStorage alloc] init];
    self.repo = [[ContactRepository alloc]initWithStorage:storage];
    
    NSArray<Contact *> *savedContacts = [_repo getContacts];
    
    self.users = [savedContacts mutableCopy];
    self.filteredUsers = self.users;
    
    [self.tableView registerClass:UITableViewCell.class
           forCellReuseIdentifier:Constants.cell];
    self.tableView.rowHeight = 60;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = Constants.search_contact;
    
    self.definesPresentationContext = YES;
    self.navigationItem.searchController = self.searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:Constants.newTitle
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(openAddUser)];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:Constants.delete
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(deleteAllUsers)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[NSProcessInfo processInfo].arguments containsObject:@"UITEST_MODE"]) {
           
           Contact *c = [Contact new];
           c.name = @"Test";
           c.lastName = @"User";
           c.phone = @"8291234567";
           c.imageUrl = @"https://picsum.photos/200";
           
           self.users = [@[c] mutableCopy];
           self.filteredUsers = self.users;
       } else {
           NSArray<Contact *> *savedContacts = [self.repo getContacts];
           self.users = [savedContacts mutableCopy];
           self.filteredUsers = self.users;
       }
    [self.tableView reloadData];
    [self updateEmptyState];
}

- (void)deleteAllUsers {
    
    [UIView transitionWithView:self.tableView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        
        [self.repo deleteAll];
        
        [self.users removeAllObjects];
        self.filteredUsers = self.users;
        
        [self.tableView reloadData];
        [self updateEmptyState];
        
    } completion:nil];
}

#pragma mark - Open SwiftUI

- (void)openAddUser {
    UIViewController *vc = [SwiftUIWrapper createAddUser];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchController.isActive ? self.filteredUsers.count : self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:Constants.cell forIndexPath:indexPath];

    Contact *user = self.searchController.isActive
        ? self.filteredUsers[indexPath.row]
        : self.users[indexPath.row];

    UIImageView *imgView = [cell.contentView viewWithTag:1001];

    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
        imgView.tag = 1001;

        imgView.layer.cornerRadius = 6;
        imgView.layer.borderWidth = 1;
        imgView.layer.borderColor = UIColor.lightGrayColor.CGColor;

        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;

        [cell.contentView addSubview:imgView];
    }

    UIImage *placeholder = [UIImage systemImageNamed:Constants.cell_placeholder_imge];
    NSURL *url = [NSURL URLWithString:user.imageUrl];

    [imgView sd_setImageWithURL:url
               placeholderImage:placeholder
                        options:SDWebImageRetryFailed];

    NSString *fullName = [NSString stringWithFormat:@"%@ %@", user.name ?: @"", user.lastName ?: @""];

    UILabel *nameLabel = [cell.contentView viewWithTag:2001];
    UILabel *phoneLabel = [cell.contentView viewWithTag:2002];

    if (!nameLabel) {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 250, 20)];
        nameLabel.tag = 2001;
        nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        [cell.contentView addSubview:nameLabel];
    }

    if (!phoneLabel) {
        phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 32, 250, 18)];
        phoneLabel.tag = 2002;
        phoneLabel.font = [UIFont systemFontOfSize:13];
        phoneLabel.textColor = UIColor.darkGrayColor;
        [cell.contentView addSubview:phoneLabel];
    }
    cell.isAccessibilityElement = YES;
    cell.accessibilityIdentifier = @"contact_cell";

    nameLabel.text = fullName;
    phoneLabel.text = user.phone;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - Table Selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Contact *user = self.searchController.isActive
    ? self.filteredUsers[indexPath.row]
    : self.users[indexPath.row];
    
    Contact *contact = [[Contact alloc] init];
    contact.name = user.name;
    contact.lastName = user.lastName;
    contact.phone = user.phone;
    contact.imageUrl = user.imageUrl;
    
    UIViewController *vc =
    [SwiftUIWrapper createDetailViewWithContact:contact];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Contact *contact = self.searchController.isActive
        ? self.filteredUsers[indexPath.row]
        : self.users[indexPath.row];
        
        [self.repo deleteContact:contact];
        
        [self.users removeObject:contact];
        self.filteredUsers = self.users;
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [self updateEmptyState];
    }
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchText = searchController.searchBar.text.lowercaseString;
    
    if (searchText.length == 0) {
        self.filteredUsers = self.users;
    } else {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Contact *user, NSDictionary *bindings) {
            
            NSString *name = user.name ?: @"";
            NSString *lastName = user.lastName ?: @"";
            NSString *phone = user.phone ?: @"";
            
            return ([name.lowercaseString containsString:searchText] ||
                    [lastName.lowercaseString containsString:searchText] ||
                    [phone.lowercaseString containsString:searchText]);
        }];
        
        self.filteredUsers = [self.users filteredArrayUsingPredicate:predicate];
    }
    
    [self.tableView reloadData];
    [self updateEmptyState];
}

- (void)updateEmptyState {

    BOOL isSearching = self.searchController.isActive;
    
    BOOL hasNoSearchResults = isSearching && self.filteredUsers.count == 0;
    BOOL hasNoData = !isSearching && self.users.count == 0;

    if (hasNoSearchResults || hasNoData) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.tableView.bounds];
        
        label.text = hasNoSearchResults
            ? Constants.no_results
            : Constants.no_contacts;
        
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColor.grayColor;
        label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        
        self.tableView.backgroundView = label;
        
    } else {
        self.tableView.backgroundView = nil;
    }
}

@end
