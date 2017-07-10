//
//  Preson.m
//  BLOCK
//
//  Created by 紫川秀 on 2017/6/23.
//  Copyright © 2017年 View. All rights reserved.
//

#import "Preson.h"

@implementation Preson

-(void)PresonBlock:(void (^)())presonBlock{
    NSLog(@"Block调用");
}

@end
