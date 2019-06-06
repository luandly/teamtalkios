//
//  SelectFileViewController.m
//  TeamTalk
//
//  Created by li xiaoxiao on 2018/8/25.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import "SelectFileViewController.h"
#import <Masonry/Masonry.h>
#import "MTTFileEntity.h"
#import "RuntimeStatus.h"
#import "MTTUserEntity.h"
#import "IMBaseDefine.pb.h"
#import "DDFileTransferAPI.h"
#import "DDFileModule.h"
#import "DLDownloadView.h"

@interface SelectFileViewController ()<UITableViewDataSource,UITableViewDelegate,DLDownloadViewDelegate>

@property(nonatomic,strong)UITableView* tableView;
@property (strong ,nonatomic)NSMutableArray *fileArray;

@end

@implementation SelectFileViewController

- (void)viewDidLoad {
    MTT_WEAKSELF(ws);
    [super viewDidLoad];
    self.title = @"文件";
    
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
        make.centerY.mas_equalTo(ws.view.center.y + 49);
    }];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"%@",[[DDFileModule instance] filePath]);
    self.fileArray = [[NSMutableArray alloc]initWithArray:[fileManager contentsOfDirectoryAtPath:[[DDFileModule instance] filePath] error:nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fileArray count];
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
    
    if(row < self.fileArray.count){
        cell.textLabel.text = self.fileArray[row];
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
    if(row >= self.fileArray.count){
        return;
    }
    
    NSString *filename = self.fileArray[row];
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[DDFileModule instance] filePath],filename];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:path]) {
        
        [[DDFileModule instance] loadFile:path];
        
        MTTFileEntity *entity = [MTTFileEntity new];
        entity.toUserId = [NSString stringWithFormat:@"%ld",(long)self.userId];
        entity.fromUserId = [RuntimeStatus instance].user.objID;
        entity.fileName = filename;
        entity.fileSize = [[DDFileModule instance] sendFileSize];
        entity.transMode = TransferFileType_FileTypeOffline;
        
        DDFileTransferAPI *pushToken = [[DDFileTransferAPI alloc] init];
        [pushToken requestWithObject:entity Completion:^(id response, NSError *error) {
            MTTFileEntity *entity = (MTTFileEntity*)response;
            if(entity){
                [DDFileModule instance].downState = DownloadState_uploading;
                [[DDFileModule instance] loginFileServer:entity complete:^{
                    DLDownloadView *downview = [[DLDownloadView alloc] initWithdelegate:self];
                    [downview setTitleText:@"正在发送文件"];
                    UIView *currentView = [UIApplication sharedApplication].delegate.window.rootViewController.view;
                    [currentView addSubview:downview];
                }];
            }
        }];
    }
}
    
#pragma mark - DLDownloadViewDelegate
- (void)DownloadComplete{
    [self popViewControllerAnimated:YES];
}
@end
