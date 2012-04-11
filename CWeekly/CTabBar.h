//
//  CTabBar.h
//  CWeekly
//
//  Created by  on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTabBar : UIToolbar{
    NSMutableArray*barItems;
}
-(void)setBagedAtindex:(NSInteger)index;
@end
