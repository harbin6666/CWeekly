//
//  CateGories.m
//  CWeekly
//
//  Created by  on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CateGories.h"

@implementation CateGories
@end
@implementation NSString (cweekly)
+(NSString*)bundlePath:(NSString*)resName{
   NSArray* temp= [resName componentsSeparatedByString:@"."];
    if (temp.count) {
        NSString*name=[temp objectAtIndex:0];
        NSString*type=[temp objectAtIndex:1];
        NSString* path=[[NSBundle mainBundle] pathForResource:name ofType:type];
        return path;
    }else {
        return  nil;
    }
}
@end