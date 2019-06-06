//
//  DDFileModule.h
//  TeamTalk
//
//  Created by li xiaoxiao on 2018/8/25.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int,DownloadState) {
    DownloadState_Begin = 1,
    DownloadState_Downing = 2,
    DownloadState_end = 3,
    DownloadState_uploading = 4,
    DownloadState_unknown = 5,
};

@class MTTFileEntity;
@interface DDFileModule : NSObject

@property(nonatomic,strong) NSString *ip;
@property(nonatomic,strong) NSString *port;
@property(nonatomic,assign) DownloadState downState;

+ (instancetype)instance;

-(void)loginFileServer:(MTTFileEntity *)entity complete:(void (^)())complete;
-(void)loadFile:(NSString *)path;
-(long)sendFileSize;
-(void)beginSend:(MTTFileEntity *)entity;
-(float)progress;
-(void)endSend:(MTTFileEntity *)entity;
-(NSString *)filePath;
-(BOOL)isDownload:(NSString *)taskid;
-(void)downloadFile:(MTTFileEntity *)entity;

@end
