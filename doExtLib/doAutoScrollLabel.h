//
//  doAutoScrollLabel.h
//  Do_Test
//
//  Created by yz on 15/10/19.
//  Copyright © 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface doAutoScrollLabel : UIView
@property (nonatomic,strong) UIColor *fontColor;
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,strong) NSString *fontStyle;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSString *textAlgin;
@property (nonatomic,strong) NSString *textFlag;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)start;//开始跑马
- (void)stop;//停止跑马

@end
