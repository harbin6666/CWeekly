//
//  CTabBarItem.h
//  CWeekly
//
//  Created by  on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BadgeView : UIView
{
	NSUInteger width;
	NSString *badgeString;
    
}

@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, retain) NSString *badgeString;

@end

@interface CTabBarItem : UIButton
{
    NSString* badge;
    BadgeView*badgeView;
}
@property(nonatomic, retain)BadgeView*badgeView;
@end
