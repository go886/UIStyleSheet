//
//  SkinMgr.h
//  test_CSS
//
//  Created by go886 on 14-9-21.
//  Copyright (c) 2014年 go886. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkinMgr : NSObject
@property(nonatomic,strong)NSString* skinName;
@property(nonatomic,strong)NSString* skinDir;
@property(nonatomic,assign)BOOL enabledLogger;
@property(nonatomic,assign)BOOL enabledAutoUpdate;

+(instancetype)instance;
@end