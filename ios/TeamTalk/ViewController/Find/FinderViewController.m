//
//  FinderViewController.m
//  TeamTalk
//
//  Created by 独嘉 on 14-10-22.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import "FinderViewController.h"
#import "MTTWebViewController.h"
#import "ScanQRCodePage.h"
#import "RuntimeStatus.h"
#import "MTTUserEntity.h"
#import "AFHTTPRequestOperationManager.h"
#import "MTTURLProtocal.h"
#import <SVWebViewController.h>
#import <Masonry/Masonry.h>
#import "LoginModule.h"

@interface FinderViewController ()
@property(strong)NSURLConnection *connection;
@property(assign)NSInteger hadUpdate;
@property(copy)NSString *url;
@property(nonatomic,strong) NSArray *items;
@end

@implementation FinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MTT_WEAKSELF(ws);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.tableView];
    [self.view setBackgroundColor:TTBG];
    [self.tableView setBackgroundColor:TTBG];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(ws.view);
        make.center.equalTo(ws.view);
    }];
    
    self.items = [NSArray new];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[LoginModule instance] getDiscovery:^(NSArray *dic) {
        if(!dic){
            return;
        }
        self.items = dic;
        
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
    
    self.title = @"发现";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tableView.contentInset =UIEdgeInsetsMake(64, 0, 49, 0);
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.tableView.contentInset =UIEdgeInsetsMake(0,0,0,0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"FinderCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = RGB(244, 245, 246);
    NSInteger row = [indexPath row];
    
    if(row < self.items.count){
        NSDictionary *dic = self.items[row];
        NSString *itemName = [dic objectForKey:@"itemName"];
        [cell.textLabel setText:itemName];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;

    if(row < self.items.count){
        NSDictionary *dic = self.items[row];
        NSString * itemUrl = [dic objectForKey:@"itemUrl"];
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:itemUrl]];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

@end
