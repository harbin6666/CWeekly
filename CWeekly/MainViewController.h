//
//  MainViewController.h
//  CWeekly
//
//  Created by Tiger on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "CTabBar.h"

@interface MainViewController : UIViewController <UIScrollViewDelegate,ASIHTTPRequestDelegate> {
    NSInteger totalCount;
    NSInteger totalPage;
    NSInteger currentPage;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    UIView *barView;
    
    //下载
    CTabBar*bar;
    UIView *infoView;
    ASINetworkQueue *queue;
    UIProgressView *progressView;
    UILabel *progressLabel;
    UIButton *btn;
    float fileLength;
    NSString *downloadPath;
    NSString *unzipPath;
}

@end
