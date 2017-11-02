//
//  doAutoScrollLabel.h
//  Do_Test
//
//  Created by yz on 15/10/19.
//  Copyright © 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,Direction)
{
    Left = 0,
    Right = 1
};
@interface doAutoScrollLabel : UIView
@property (nonatomic,strong) UIColor *fontColor;
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,strong) NSString *fontStyle;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSString *textFlag;
@property (nonatomic,assign) Direction direction;
@property (nonatomic,assign,getter=isStart) BOOL start;

- (instancetype)initWithFrame:(CGRect)frame withFontSize:(NSInteger)fontsize;

- (void)start;//开始跑马
@end
