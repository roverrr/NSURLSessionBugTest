//
//  ViewController.m
//  NSURLSessionBugTest
//
//  Created by Evgeny Smirnov on 26.11.14.
//  Copyright (c) 2014 Evgeny Smirnov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) IBOutlet UIButton *dowloadButton;
@property (nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic) IBOutlet UISegmentedControl *sessionTypeSegmentControl;

@property (nonatomic) NSURLSession *backgroundSession;
@property (nonatomic) NSURLSession *ephemeralSession;
@property (nonatomic) NSURLSession *defaultSession;

@property (nonatomic) NSURL *imageURL;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    self.imageURL = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/7/7f/Williams_River-27527.jpg"];

}

-(IBAction)handleDowloadTap:(id)sender{
        
    NSInteger sessionType = self.sessionTypeSegmentControl.selectedSegmentIndex;
    
    NSURLSession *currentSession;
    if (sessionType == 0) {
        currentSession = self.defaultSession;
    } else if (sessionType == 1){
        currentSession = self.ephemeralSession;
    } else if (sessionType == 2){
        currentSession = self.backgroundSession;
    }
    
    NSURLSessionDownloadTask *imageTask = [currentSession downloadTaskWithURL:self.imageURL];
    [imageTask resume];
}

-(IBAction)handleDeleteButton:(id)sender{
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    UIImage *downloadedImage = [UIImage imageWithData:
                                [NSData dataWithContentsOfURL:location]];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:downloadedImage];
    imageView.frame = CGRectMake(10, 150, 300, 200);
    [self.view addSubview:imageView];

}


-(NSURLSession *)backgroundSession{
    
    if (!_backgroundSession) {
        NSURLSessionConfiguration *background = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.background"];
        _backgroundSession = [NSURLSession sessionWithConfiguration:background delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    
    return _backgroundSession;
}

-(NSURLSession *)ephemeralSession{
    if (!_ephemeralSession) {
        NSURLSessionConfiguration *empharal = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _ephemeralSession = [NSURLSession sessionWithConfiguration:empharal delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _ephemeralSession;
}
-(NSURLSession *)defaultSession{
    if (!_defaultSession) {
        NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _defaultSession = [NSURLSession sessionWithConfiguration:defaultConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _defaultSession;
}

@end
