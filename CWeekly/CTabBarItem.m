//
//  CTabBarItem.m
//  CWeekly
//
//  Created by  on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CTabBarItem.h"

@interface BadgeView ()

@property (nonatomic, assign) NSUInteger width;

@end

@implementation BadgeView

@synthesize width, badgeString;


- (id) initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{		
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;	
}

- (void) drawRect:(CGRect)rect
{	
	NSString *countString = self.badgeString;
	
	CGSize numberSize = [countString sizeWithFont:[UIFont boldSystemFontOfSize: 14]];
	
	self.width = numberSize.width + 16;
	
	CGRect bounds = CGRectMake(0 , 0, numberSize.width + 14 , 18);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	float radius = bounds.size.height / 2.0f;
	
	CGContextSaveGState(context);
	
	UIColor *col=[UIColor colorWithRed:247/255 green:0/255 blue:33/255 alpha:1.000f];
//	if (parent.highlighted || parent.selected) {
//		if (self.badgeColorHighlighted) {
//			col = self.badgeColorHighlighted;
//		} else {
//			col = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.000f];
//		}
//	} else {
//		if (self.badgeColor) {
//			col = self.badgeColor;
//		} else {
//			col = [UIColor colorWithRed:0.530f green:0.600f blue:0.738f alpha:1.000f];
//		}
//	}
    
	CGContextSetFillColorWithColor(context, [col CGColor]);
	
	CGContextBeginPath(context);
	CGContextAddArc(context, radius, radius, radius, (CGFloat)M_PI_2 , 3.0f * (CGFloat)M_PI_2, NO);
	CGContextAddArc(context, bounds.size.width - radius, radius, radius, 3.0f * (CGFloat)M_PI_2, (CGFloat)M_PI_2, NO);
	CGContextClosePath(context);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
	
	bounds.origin.x = (bounds.size.width - numberSize.width) / 2.0f + 0.5f;
	
	CGContextSetBlendMode(context, kCGBlendModeClear);
	
	[countString drawInRect:bounds withFont:[UIFont boldSystemFontOfSize: 14]];
}

- (void) dealloc
{
	[badgeString release];
	[super dealloc];
}

@end

@implementation CTabBarItem
@synthesize badgeView;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectZero;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGSize size=self.frame.size;
    CGRect rect=CGRectMake(size.width/2-16, 6, 32, 44);
    return rect;

}
-(void)dealloc{
    [badgeView release];
    [super dealloc];
}
@end
