//
//  MainViewController.m
//  ChatDemo-UI
//
//  Created by dujiepeng on 14-4-18.
//  Copyright (c) 2014年 djp. All rights reserved.
//

#import "MainViewController.h"
#import "ChatListViewController.h"
#import "ContactsViewController.h"
#import "UIViewController+HUD.h"
#import "MBProgressHUD+Add.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "EaseMob.h"

@interface MainViewController ()<UITabBarDelegate>
{
    UIBarButtonItem *_logoutItem;
    
    ChatListViewController *_chatListVC;
    ContactsViewController *_contactsVC;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"消息列表";
    _logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    [self.navigationItem setLeftBarButtonItem:_logoutItem];
    
    _chatListVC = [[ChatListViewController alloc] initWithNibName:nil bundle:nil];
    _chatListVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息列表" image:[UIImage imageNamed:@"Messages"] tag:0];
    _chatListVC.tabBarItem.tag = 0;
    _contactsVC = [[ContactsViewController alloc] initWithNibName:nil bundle:nil];
    _contactsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"好友列表" image:[UIImage imageNamed:@"Contacts"] tag:1];
    _contactsVC.tabBarItem.tag = 1;
    self.viewControllers = @[_chatListVC,_contactsVC];
    [[DataManager defaultManager] setContactsController:_contactsVC];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0) {
        self.title = @"消息列表";
        [self.navigationItem setRightBarButtonItem:nil];
    }
    else{
        self.title = @"好友列表";
        
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStyleBordered target:_contactsVC action:@selector(addFriendAction)];
        [self.navigationItem setRightBarButtonItem:addItem];
    }
}

#pragma mark - action

- (void)logout
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"退出当前账号失败，请重新操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
    } onQueue:nil];
}

@end
