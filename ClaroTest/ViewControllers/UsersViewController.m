//
//  UsersViewController 2.h
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


#import "UsersViewController.h"
#import <SDWebImage/SDWebImage.h>
#import "ClaroTest-Swift.h"
#import "Contact.h"


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
    
    NSArray<Contact *> *savedContacts = [self.repo getContacts];
    
    self.users = [savedContacts mutableCopy];
    self.filteredUsers = self.users;
    
    [self.tableView reloadData];
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
    
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.phone;
    
    UIImageView *imgView = [cell.contentView viewWithTag:1001];
    
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 40, 40)];
        imgView.tag = 1001;
        
        imgView.layer.cornerRadius = 20;
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        [cell.contentView addSubview:imgView];
    }
    
    UIImage *placeholder = [UIImage systemImageNamed:Constants.cell_placeholder_imge];
    NSURL *url = [NSURL URLWithString:user.imageUrl];
    
    [imgView sd_setImageWithURL:url
               placeholderImage:placeholder
                        options:SDWebImageRetryFailed];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = UIColor.grayColor;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
            NSString *imageUrl = user.imageUrl ?: @"";
            
            return ([name.lowercaseString containsString:searchText] ||
                    [lastName.lowercaseString containsString:searchText] ||
                    [phone.lowercaseString containsString:searchText] ||
                    [imageUrl.lowercaseString containsString:searchText]);
        }];
        
        self.filteredUsers = [self.users filteredArrayUsingPredicate:predicate];
    }
    
    [self.tableView reloadData];
}

@end
