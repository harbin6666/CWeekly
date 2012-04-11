//
//  MainViewController.m
//  CWeekly
//
//  Created by Tiger on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#define HEIGHT_S 1024-64-69
#define HEIGHT_H 768-64-69
#define HEIGHT_S_2 (1024-64-69)/2
#define HEIGHT_H_2 (768-64-69)/2

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [scrollView release];
    [pageControl release];
    [bar release];
    
    //下载
    [queue release];
    [infoView release];
    [progressView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"首页";
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizesSubviews = NO;
    
    totalCount = 9;
    totalPage = (int)ceil((CGFloat)totalCount/4.0);
    currentPage = 0;
    
    scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    pageControl = [[UIPageControl alloc]init];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = totalPage;
    pageControl.currentPage = currentPage;
    [self.view addSubview:pageControl];
    
    //下载view
    infoView = [[UIView alloc]init];
    infoView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:infoView];
    
    progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(10, 10, 140, 20)];
    progressView.progress = 0.0;
    progressView.hidden = YES;
    [infoView addSubview:progressView];
    
    progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, -5, 200, 20)];
    progressLabel.text = @"0%";
    progressLabel.textColor = [UIColor blackColor];
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.font = [UIFont systemFontOfSize:14.0];
    [progressView addSubview:progressLabel];
    [progressLabel release];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 30, 60, 30);
    [btn setTitle:@"下载" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnEvent) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:btn];
    
    [self deleteFile];
    
    queue = [[ASINetworkQueue alloc] init];
    //[queue reset];
    [queue setShowAccurateProgress:YES];//高精度进度
    [queue go];
    
    barView = [[UIView alloc]init];
    barView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    bar=[[CTabBar alloc] initWithFrame:CGRectZero];
    [self.view addSubview:bar];
    [bar setBagedAtindex:0];
//    [self.view addSubview:barView];
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        scrollView.frame = CGRectMake(0, 0, 1024, HEIGHT_H);
        scrollView.contentSize = CGSizeMake(1024*totalPage, HEIGHT_H);
        pageControl.frame = CGRectMake(0, HEIGHT_H,1024, 20);
        bar.frame = CGRectMake(0, HEIGHT_H+20,1024, 58);
        
        infoView.frame = CGRectMake(240, 50,250, 200);
    }
    else {  
        scrollView.frame = CGRectMake(0, 0, 768, HEIGHT_S);
        scrollView.contentSize = CGSizeMake(768*totalPage, HEIGHT_S);
        pageControl.frame = CGRectMake(0, HEIGHT_S,768, 20);
        bar.frame = CGRectMake(0, HEIGHT_S+20,768, 58);
        
        infoView.frame = CGRectMake(50, 270,300, 200);
    }
    
    for (int i=0; i<totalCount; i++) {
        UILabel *book = [[UILabel alloc]init];
        book.tag = 1000+i;
        book.textAlignment = UITextAlignmentCenter;
        book.text = [NSString stringWithFormat:@"%d",i];
        book.backgroundColor = [UIColor grayColor];
        [scrollView addSubview:book];
        [book release];
        
        if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            book.frame = CGRectMake((i/4)*1024+(i%2)*512+50, ((i%4)/2)*HEIGHT_H_2+50, 160, 200);
        }
        else {  
            book.frame = CGRectMake((i/4)*768+(i%2)*384+50, ((i%4)/2)*HEIGHT_S_2+50, 160, 200);
        }
    }
}

- (void)btnEvent
{
    if ([btn.titleLabel.text isEqualToString:@"下载"] || [btn.titleLabel.text isEqualToString:@"继续"]) {
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
        progressView.hidden = NO;
        
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        downloadPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/book.zip"] retain];
        NSString *tempPath = [path stringByAppendingPathComponent:@"book.temp"];
        
        NSURL *url = [NSURL URLWithString:@"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V2.0.2.dmg"];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.delegate = self;//代理
        [request setDownloadDestinationPath:downloadPath];//下载路径
        [request setTemporaryFileDownloadPath:tempPath];//缓存路径
        [request setAllowResumeForFileDownloads:YES];//断点续传
        request.downloadProgressDelegate = self;//下载进度代理
        [queue addOperation:request];//添加到队列，队列启动后不需重新启动
        if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
            NSLog(@"有了");
        }
        else {
            NSLog(@"没有");
        }
    }
    else if ([btn.titleLabel.text isEqualToString:@"暂停"]) {
        [btn setTitle:@"继续" forState:UIControlStateNormal];
        
        ASIHTTPRequest *request = [[queue operations] objectAtIndex:0];
        [request clearDelegatesAndCancel];
    }
}

- (void)deleteFile
{
    BOOL clear = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]) {
        if ([[NSFileManager defaultManager] removeItemAtPath:downloadPath error:nil]) {
            NSLog(@"删除压缩文件");
        }
        else {
            NSLog(@"删除压缩文件失败");
            clear = NO;
        }
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:unzipPath]) {
        if ([[NSFileManager defaultManager] removeItemAtPath:unzipPath error:nil]) {
            NSLog(@"删除解压文件");
        }
        else {
            NSLog(@"删除解压文件失败");
            clear = NO;
        }
    }
    if (clear) {
        fileLength = 0;
        progressView.progress = 0;
        progressLabel.text = @"0%";
        [btn setTitle:@"下载" forState:UIControlStateNormal];
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"收到头部！");
    NSLog(@"%f",request.contentLength/1024.0/1024.0);
    NSLog(@"%@",responseHeaders);
    if (fileLength == 0) {
        fileLength = request.contentLength/1024.0/1024.0;
    }
}

- (void)setProgress:(float)newProgress
{
    progressView.progress = newProgress;
    progressLabel.text = [NSString stringWithFormat:@"%.2f%%",newProgress*100];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    //
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"下载成功！");
    progressView.hidden = YES;
    [btn setTitle:@"阅读" forState:UIControlStateNormal];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"下载失败！");
    [self deleteFile];
}



- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    CGPoint p = scrollView.contentOffset;
    
    CGFloat width = 0.0;
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        width = 1024;
    }
    else {  
        width = 768;
    }
    
    currentPage = floor((p.x - width / 2) / width) + 1;
    pageControl.currentPage = currentPage;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {  
    for (UILabel *book in [scrollView subviews]) {
        NSInteger i = book.tag - 1000;
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            book.frame = CGRectMake((i/4)*1024+(i%2)*512+50, ((i%4)/2)*HEIGHT_H_2+50, 160, 200);
        }
        else {  
            book.frame = CGRectMake((i/4)*768+(i%2)*384+50, ((i%4)/2)*HEIGHT_S_2+50, 160, 200);
        }
    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        scrollView.frame = CGRectMake(0, 0, 1024, HEIGHT_H);
        scrollView.contentSize = CGSizeMake(1024*totalPage, HEIGHT_H);
        [scrollView setContentOffset:CGPointMake(currentPage*1024, 0) animated:YES];
        pageControl.frame = CGRectMake(0, HEIGHT_H,1024, 20);
        bar.frame = CGRectMake(0, HEIGHT_H+20,1024, 58);
        
        infoView.frame = CGRectMake(240, 50,250, 200);
    }
    else {  
        scrollView.frame = CGRectMake(0, 0, 768, HEIGHT_S);
        scrollView.contentSize = CGSizeMake(768*totalPage, HEIGHT_S);
        [scrollView setContentOffset:CGPointMake(currentPage*768, 0) animated:YES];
        pageControl.frame = CGRectMake(0, HEIGHT_S,768, 20);
        bar.frame = CGRectMake(0, HEIGHT_S+20,768, 58);
        
        infoView.frame = CGRectMake(50, 270,300, 200);
    }
}

@end
