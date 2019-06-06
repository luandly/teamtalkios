//
//  DDFileTcpServer.h
//  TeamTalk
//
//  Created by li xiaoxiao on 2018/8/25.
//  Copyright © 2018 MoguIM. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ClientSuccess)();
typedef void(^ClientFailure)(NSError* error);

@interface DDFileTcpServer : NSObject

- (void)loginTcpServerIP:(NSString*)ip port:(NSInteger)point Success:(void(^)())success failure:(void(^)())failure;

@end
