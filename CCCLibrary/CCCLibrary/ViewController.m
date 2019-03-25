//
//  ViewController.m
//  CCCLibrary
//
//  Created by 财资赢-iOS on 2019/3/25.
//  Copyright © 2019年 hechong. All rights reserved.
//

#import "ViewController.h"
#import "CCCWXShareView.h"
#import "CCCTencentASRTools.h"
#import "CCCTheme.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [CCCTheme setTheme:0];
    self.view.backgroundColor = [CCCTheme submitBtnBgColor];
    
}


@end
