//
//  DDFileTcpManager.h
//  TeamTalk
//
//  Created by li xiaoxiao on 2018/8/25.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DDSendBuffer;
@interface DDFileTcpManager : NSObject<NSStreamDelegate>
{
@private
    NSInputStream *_inStream;
    NSOutputStream *_outStream;
    NSLock *_receiveLock;
    NSMutableData *_receiveBuffer;
    NSLock *_sendLock;
    NSMutableArray *_sendBuffers;
    DDSendBuffer *_lastSendBuffer;
    BOOL _noDataSent;
    int32_t cDataLen;
    
}

+ (instancetype)instance;

-(void)connect:(NSString *)ipAdr port:(NSInteger)port status:(NSInteger)status;
-(void)disconnect;
-(void)writeToSocket:(NSMutableData *)data;

@end
