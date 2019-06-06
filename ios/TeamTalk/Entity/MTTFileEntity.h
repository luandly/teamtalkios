//
//  MTTFileEntity.h
//  TeamTalk
//
//  Created by li xiaoxiao on 2018/8/25.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTTFileEntity : NSObject

@property(nonatomic,strong) NSString *toUserId;         //接受用户id
@property(nonatomic,strong) NSString *fromUserId;         //发送用户id
@property(nonatomic,assign) int transMode;       //传输模式
@property(nonatomic,strong) NSString *fileName;   //文件名字
@property(nonatomic,assign) long fileSize;   //文件大小（字节）
@property(nonatomic,strong) NSString *task_id;//文件id
@property(nonatomic,assign) int filerole;//上传方式
@property(nonatomic,assign) int offset;//文件传输标志位
@property(nonatomic,assign) long dataSize;//文件传输大小
@property(nonatomic,strong) NSData *fileData;//文件数据

@end
