//
//  Preson.h
//  BLOCK
//
//  Created by 紫川秀 on 2017/6/23.
//  Copyright © 2017年 View. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void(^presonBlock)();

@interface Preson : NSObject

@property (nonatomic, copy) NSString *name;

//@property (nonatomic, copy) presonBlock presonBlock;

-(void)PresonBlock:(void (^)())presonBlock;

@end
