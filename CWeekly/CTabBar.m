//
//  CTabBar.m
//  CWeekly
//
//  Created by  on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CTabBar.h"
#import "CTabBarItem.h"
@implementation CTabBar
-(void)dealloc{
    [barItems release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString*path=[NSString bundlePath:@"tabBarItem.plist"];

        NSArray* items=[NSArray arrayWithContentsOfFile:path];
        barItems=[[NSMutableArray alloc] init];
        CTabBarItem* tabBarItem;

        [self addSpaceItemCount:5];
        for (int i=0; i<items.count; i++) {
            NSDictionary* item=[items objectAtIndex:i];
            UIImage*img=[UIImage imageNamed:[item valueForKey:@"icon"]];
            UIImage* simg=[UIImage imageNamed:[item valueForKey:@"sIcon"]];
            tabBarItem=[CTabBarItem buttonWithType:UIButtonTypeCustom];
            tabBarItem.frame=CGRectMake(0, 0, 58, 58);
            [tabBarItem addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
            tabBarItem.tag=i;
            [tabBarItem setImage:img forState:UIControlStateNormal];
            [tabBarItem setImage:simg forState:UIControlStateSelected];
           UIBarButtonItem* barBTn=[[UIBarButtonItem alloc] initWithCustomView:tabBarItem];
            [barItems addObject:barBTn];
            [barBTn release];
            [self addSpaceItemCount:1];
        }
        [self addSpaceItemCount:5];

        self.items=barItems;
    }
    return self;
}
-(void)addSpaceItemCount:(NSUInteger)count{
    UIBarButtonItem*  spaceBTN=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    for (int i=0; i<count; i++) {
        [barItems addObject:spaceBTN];
    }
    [spaceBTN release];

}
-(void)itemSelected:(CTabBarItem*)sender{
    sender.selected=!sender.selected;
}
-(void)setBagedAtindex:(NSInteger)index{


}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage* img;
    if (rect.size.width>1000) {
        img=[UIImage imageNamed:@"bottombar.png"];
    }else {
        img=[UIImage imageNamed:@"bottombar_v.png"];
    }
    [img drawInRect:rect];
}


@end
