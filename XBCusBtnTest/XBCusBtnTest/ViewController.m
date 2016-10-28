//
//  ViewController.m
//  XBCusBtnTest
//
//  Created by chuango on 16/10/28.
//  Copyright © 2016年 chuango. All rights reserved.
//

#import "ViewController.h"
#import "XBCusBtn.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titleArr1=@[@"图左文右靠左对齐距离左边框20",@"图右文左靠右对齐",@"图左文右居中图片尺寸10x10",@"图右文左居中图文间距15"];
    for (int i=0; i<4; i++)
    {
        XBCusBtn *cusBtn=[XBCusBtn new];
        [self.view addSubview:cusBtn];
        cusBtn.frame=CGRectMake(20, i*40+40, 250, 30);
        cusBtn.backgroundColor=[UIColor orangeColor];
        cusBtn.contentType=i%2+2;
        cusBtn.contentSide=i+2>4?4:i+2;
        cusBtn.imageNormal=[UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
        cusBtn.titleNormal=titleArr1[i];
        cusBtn.titleFont=[UIFont systemFontOfSize:12];
        if (i==2)
        {
            cusBtn.imageSize=CGSizeMake(10, 10);
        }
        if (i==3)
        {
            cusBtn.spaceOfImageAndTitle=15;
        }
        if (i==0)
        {
            cusBtn.spaceToContentSide=20;
        }
    }
    
    NSArray *titleArr2=@[@"图上文下顶部对齐",@"图下文上底部对齐",@"图上文下居中",@"图下文上居中"];
    for (int i=0; i<4; i++)
    {
        XBCusBtn *cusBtn=[XBCusBtn new];
        [self.view addSubview:cusBtn];
        cusBtn.frame=CGRectMake(20+(i%2)*100, 240+(i/2)*120, 80, 100);
        cusBtn.backgroundColor=[UIColor orangeColor];
        cusBtn.contentType=i%2;
        cusBtn.contentSide=i>1?4:i;
        cusBtn.imageNormal=[UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
        cusBtn.titleNormal=titleArr2[i];
        cusBtn.titleFont=[UIFont systemFontOfSize:12];

    }
}


@end
