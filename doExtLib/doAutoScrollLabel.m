//
//  doAutoScrollLabel.m
//  Do_Test
//
//  Created by yz on 15/10/19.
//  Copyright © 2015年 DoExt. All rights reserved.
//

#import "doAutoScrollLabel.h"
#import <CoreText/CoreText.h>

#define FONT_OBLIQUITY 15.0
#define ANIMATIONKEY @"animationKey"

@implementation doAutoScrollLabel
{
    
    CGRect rectMark1;//标记第一个位置
//    CGRect rectMark2;//标记第二个位置
    NSMutableArray* labelArr;
    NSTimeInterval timeInterval;//时间
    BOOL isStop;//停止
    UILabel *mainLab;
//    UILabel *rightLab;
    CGFloat curFontSize;
    NSString *curFontStyle;
    NSMutableDictionary *attributeDict;
    Direction _direction;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        mainLab = [[UILabel alloc]init];
//        rightLab = [[UILabel alloc]init];
        [self addSubview:mainLab];
//        [self addSubview:rightLab];
        labelArr = [NSMutableArray arrayWithObject:mainLab];
//        [labelArr addObject:rightLab];
        curFontSize = 11;
        curFontStyle = @"normal";
        attributeDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont systemFontOfSize:11],NSFontAttributeName,
                                           [UIColor blackColor],NSForegroundColorAttributeName,
                                           NSUnderlineStyleAttributeName,@(NSUnderlineStyleNone),nil];
    }
    return self;
}
- (void)start
{
    NSDictionary *fontDec = [mainLab.attributedText attributesAtIndex:0 effectiveRange:nil];
    CGSize fontSize = [mainLab.text sizeWithAttributes:fontDec];
    rectMark1 = CGRectMake(0, 0, fontSize.width, self.bounds.size.height);
    if (_direction == Left) {
        mainLab.frame = rectMark1;
    }
    else
    {
        mainLab.frame = CGRectMake(-rectMark1.size.width, rectMark1.size.height, rectMark1.size.width, rectMark1.size.height);
    }
    //判断是否需要reserveTextLb
//    BOOL useReserve = fontSize.width > self.frame.size.width ? YES : NO;
//    
//    if (!useReserve)
//    {
//        return;
//    }
    isStop = NO;
    [self startAnimate];
}
- (void)stop
{
    isStop = YES;
}
- (void)startAnimate
{
    if (!isStop) {
        CABasicAnimation *anima=[CABasicAnimation animation];
        anima.keyPath=@"position.x";
        anima.duration = [self displayDurationForString:mainLab.text];
        if (_direction == Left) {
            anima.byValue = @(-rectMark1.size.width);
        }
        else
        {
            anima.byValue = @(rectMark1.size.width);
        }
        anima.removedOnCompletion=NO;
        anima.fillMode=kCAFillModeForwards;
        anima.repeatCount = CGFLOAT_MAX;
        [mainLab.layer addAnimation:anima forKey:ANIMATIONKEY];
    }
}

- (NSTimeInterval)displayDurationForString:(NSString*)string
{
    double time = string.length / 5 ;
    if (time < 1) {
        time = 1;
    }
    else if (time > 5)
    {
        time = 5;
    }
    return time;
}

#pragma -mark -重写set方法
- (void)setDirection:(Direction)direction
{
    if (direction == Left) {
        _direction = Left;
    }
    else
    {
        _direction = Right;
    }
}
-(void)setFontColor:(UIColor *)fontColor
{
    attributeDict[NSForegroundColorAttributeName] = fontColor;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:mainLab.text attributes:attributeDict];
    
    if (attributedStr.length <= 0) {
        return;
    }
    [mainLab setAttributedText:attributedStr];
}
- (void)setFontSize:(CGFloat)fontSize
{
    curFontSize = fontSize;
    UIFont *curFont;
    if([curFontStyle isEqualToString:@"normal"])
    {
        curFont = [UIFont systemFontOfSize:curFontSize];
    }
    else if([curFontStyle isEqualToString:@"bold"])
    {
        curFont = [UIFont boldSystemFontOfSize:curFontSize];
    }
    else if([curFontStyle isEqualToString:@"italic"])
    {
        CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(FONT_OBLIQUITY * (CGFloat)M_PI / 180), 1, 0, 0);
        UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize :curFontSize ]. fontName matrix :matrix];
        curFont = [UIFont fontWithDescriptor:desc size:curFontSize];
    }
    [attributeDict setObject:curFont forKey:NSFontAttributeName];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:mainLab.text attributes:attributeDict];
    [mainLab setAttributedText:attributeStr];

    CGSize fontSizes = [mainLab.text sizeWithAttributes:attributeDict];
    rectMark1 = CGRectMake(0, 0, fontSizes.width, self.bounds.size.height);
    mainLab.frame = rectMark1;
    if ([mainLab.layer animationForKey:ANIMATIONKEY]) {
        [mainLab.layer removeAllAnimations];
    }
    [self start];
}
- (void)setFontStyle:(NSString *)fontStyle
{
    curFontStyle = fontStyle;
    UIFont *font;
    if([fontStyle isEqualToString:@"normal"])
    {
        font = [UIFont systemFontOfSize:curFontSize];
    }
    else if([fontStyle isEqualToString:@"bold"])
    {
        font = [UIFont boldSystemFontOfSize:curFontSize];
    }
    else if([fontStyle isEqualToString:@"italic"])
    {
        CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(FONT_OBLIQUITY * (CGFloat)M_PI / 180), 1, 0, 0);
        UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize :curFontSize ]. fontName matrix :matrix];
        font = [UIFont fontWithDescriptor:desc size:curFontSize];
    }
    else if([fontStyle isEqualToString:@"bold_italic"]){}//不支持
    [attributeDict setObject:font forKey:NSFontAttributeName];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:mainLab.text attributes:attributeDict];
    [mainLab setAttributedText:attributeStr];
    if ([mainLab.layer animationForKey:ANIMATIONKEY]) {
        [mainLab.layer removeAllAnimations];
    }
    [self start];
}
- (void)setText:(NSString *)text
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:text attributes:attributeDict];
    if (attributeStr.length <= 0) {
        return;
    }
    
    [mainLab setAttributedText:attributeStr];
    if ([mainLab.layer animationForKey:ANIMATIONKEY]) {
        [mainLab.layer removeAllAnimations];
    }
    [self start];
}
- (void)setTextFlag:(NSString *)textFlag
{
    if ([textFlag isEqualToString:@"normal" ]) {
        attributeDict[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleNone);
        attributeDict[NSStrikethroughStyleAttributeName] = @(NSUnderlineStyleNone);
    }else if ([textFlag isEqualToString:@"underline" ]) {
        attributeDict[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
    }
    else if ([textFlag isEqualToString:@"strikethrough" ]) {
        [attributeDict setObject:@(NSUnderlineStyleSingle) forKey:NSStrikethroughStyleAttributeName];
        attributeDict[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
    }
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:mainLab.text attributes:attributeDict];
    [mainLab setAttributedText:attributeStr];
}
@end
