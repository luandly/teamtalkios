//
//  DDFileModule.m
//  TeamTalk
//
//  Created by li xiaoxiao on 2018/8/25.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import "DDFileModule.h"
#import "MTTFileEntity.h"
#import "DDFileTcpServer.h"
#import "DDFileLoginAPI.h"
#import "DDFilePullAPI.h"
#import "ImBaseDefine.pb.h"
#import "MTTUtil.h"
#import "DDFileTcpManager.h"
#import "ChattingMainViewController.h"
#import "NSDictionary+JSON.h"
#import "DDFileDownloadPullAPI.h"
#import "IMFile.pb.h"
#import "DDFileStateAPI.h"

const static int DATASIZE = 32768;

@interface DDFileModule()

@property(nonatomic,strong) NSData *sendFileData;
@property(nonatomic,assign) float offset;
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,strong) NSMutableData *saveData;
@property(nonatomic,assign) float downloadSize;
@property(nonatomic,assign) float downloadOffset;
@property(nonatomic,strong) NSMutableArray *downloadTasks;
    
@end

@implementation DDFileModule

+ (instancetype)instance
{
    static DDFileModule* group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        group = [[DDFileModule alloc] init];
        
    });
    return group;
}

-(instancetype)init{
    self = [super init];
    if(self){
        self.sendFileData = nil;
        self.fileName = @"";
        self.downState = DownloadState_unknown;
        self.saveData = nil;
        self.downloadSize = 0.0f;
        self.downloadTasks = [NSMutableArray new];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *cachePath = [self filePath];
        
        if (![fileManager fileExistsAtPath:cachePath]) {
            NSError *error = NULL;
            if (![fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:&error]) {
                NSLog(@"创建文件下载目录失败");
            }
        }
    }
    return self;
}

-(void)loginFileServer:(MTTFileEntity *)entity complete:(void (^)())complete{
    if(!entity){
        return;
    }
    DDFileTcpServer *tcpServer = [[DDFileTcpServer alloc] init];
    [tcpServer loginTcpServerIP:self.ip port:self.port.intValue Success:^{
        DDFileLoginAPI *file = [DDFileLoginAPI new];
        file.isFileServer = YES;
        if(self.downState == DownloadState_uploading){
            file.isDownload = NO;
        }else{
            file.isDownload = YES;
        }
        [file requestWithObject:entity Completion:^(id response, NSError *error) {
            if(complete){
                complete();
            }
        }];
    } failure:^{
        
    }];
}

-(void)loadFile:(NSString *)path{
    if(!path){
        return;
    }
    self.fileName = [path lastPathComponent];
    self.sendFileData = [NSData dataWithContentsOfFile:path];
}

-(long)sendFileSize{
    if(!self.sendFileData){
        return 0;
    }
    
    return self.sendFileData.length;
}

-(NSString *)filePath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [path stringByAppendingPathComponent:@"InBox"];
}

-(void)beginSend:(MTTFileEntity *)entity{
    if(!self.sendFileData){
        return;
    }
    
    if(entity.offset >= [self sendFileSize]){
        return;
    }
    
    long datasize = entity.offset + entity.dataSize;
    if(datasize >= [self sendFileSize]){
        datasize = [self sendFileSize] - entity.offset;
    }else{
        datasize = entity.dataSize;
    }
    NSData *subData =[self.sendFileData subdataWithRange:NSMakeRange(entity.offset,datasize)];
    entity.fileData = subData;
    
    NSLog(@"%ld     %ld       %lu       %d     %ld",datasize,[self sendFileSize],(unsigned long)subData.length,entity.offset,entity.dataSize);
    self.offset = entity.offset;
    
    DDFilePullAPI *pull = [DDFilePullAPI new];
    pull.isFileServer = YES;
    [pull requestWithObject:entity Completion:^(id response, NSError *error) {
        
    }];
}

-(float)progress{
    if(self.downState == DownloadState_uploading){
        if(!self.sendFileData){
            return 0.0f;
        }
        
        return self.offset / [self sendFileSize];
    }else{
        if(self.downloadSize == 0.0f){
            return 0.0f;
        }
        
        return self.downloadOffset / self.downloadSize;
    }
}
    
-(void)endSend:(MTTFileEntity *)entity{
    
    if(self.downState != DownloadState_uploading){
        return;
    }
    
    if(!self.sendFileData){
        return;
    }
    
    [[DDFileTcpManager instance] disconnect];
    self.offset = (int)[self sendFileSize] + 1;
    if(entity.transMode == ClientFileState_ClientFileDone){
        NSDictionary *dic = @{@"serverAddress":@[@{@"ip":self.ip,@"port":self.port}],
                              @"fileSize":[NSString stringWithFormat:@"%ld",[self sendFileSize]],
                              @"fileName":self.fileName,
                              @"taskId":entity.task_id
                              };
        NSString *text = [dic jsonString];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ChattingMainViewController shareInstance] sendFileMessage:text];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MTTUtil showAlertWithTitle:@"温馨提示" message:@"上传失败"];
        });
    }
}

-(BOOL)isDownload:(NSString *)taskid{
    if(!taskid){
        return NO;
    }
    
    if([self.downloadTasks containsObject:taskid]){
        return YES;
    }
    
    return NO;
}

-(void)downloadFile:(MTTFileEntity *)entity{
    self.downState = DownloadState_Begin;
    [self loginFileServer:entity complete:^{
        self.downState = DownloadState_Downing;
        entity.offset = 0;
        if(entity.fileSize < DATASIZE){
            entity.dataSize = entity.fileSize;
        }else{
            entity.dataSize = DATASIZE;
        }
        self.downloadSize = entity.fileSize;
        self.downloadOffset = entity.offset;
        self.saveData = [[NSMutableData alloc] initWithLength:0];
        
        DDFileDownloadPullAPI *pull = [DDFileDownloadPullAPI new];
        pull.isFileServer = YES;
        [pull requestWithObject:entity Completion:^(id response, NSError *error) {
            IMFilePullDataRsp *rsp = (IMFilePullDataRsp *)response;
            entity.fileData = rsp.fileData;
            entity.offset += (int)entity.dataSize;
            self.downloadOffset = entity.offset;
            [self saveDownloadData:entity];
        }];
    }];
}

-(void)saveDownloadData:(MTTFileEntity *)entity{
    NSLog(@"%ld      %lu        %d        %ld",entity.fileSize,(unsigned long)self.saveData.length,entity.offset,entity.dataSize);
    [self.saveData appendData:entity.fileData];
    if(entity.fileSize == self.saveData.length){
        self.downState = DownloadState_end;
        
        NSString *path = [NSString stringWithFormat:@"%@/%@",[self filePath],entity.fileName];
        [self.saveData writeToFile:path atomically:YES];
        
       
        [self.downloadTasks addObject:entity.task_id];
        
        DDFileStateAPI *state = [DDFileStateAPI new];
        [state requestWithObject:entity Completion:^(id response, NSError *error) {
            [[DDFileTcpManager instance] disconnect];
        }];
        return;
    }
    
    if(entity.offset + entity.dataSize > entity.fileSize){
        entity.dataSize = entity.fileSize - entity.offset;
    }
    
    DDFileDownloadPullAPI *pull = [DDFileDownloadPullAPI new];
    pull.isFileServer = YES;
    [pull requestWithObject:entity Completion:^(id response, NSError *error) {
        IMFilePullDataRsp *rsp = (IMFilePullDataRsp *)response;
        entity.fileData = rsp.fileData;
        entity.offset += (int)entity.dataSize;
        self.downloadOffset = entity.offset;
        [self saveDownloadData:entity];
    }];
}

@end
