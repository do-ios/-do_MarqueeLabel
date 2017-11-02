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
#define IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.1f)

@implementation doAutoScrollLabel
{
    
    CGRect rectMark1;//标记第一个位置
    NSTimeInterval timeInterval;//时间
    UILabel *mainLab;
    CGFloat curFontSize;
    NSString *curFontStyle;
    NSString *curFontFlag;
    NSMutableDictionary *attributeDict;
    Direction _direction;
    NSTimer *_timer;
    CGFloat _currentX;
    NSString *_currentTitle;
}
- (instancetype)initWithFrame:(CGRect)frame withFontSize:(NSInteger)fontsize
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        mainLab = [[UILabel alloc]init];
        [self addSubview:mainLab];
        //默认字体
        curFontStyle = @"normal";
        attributeDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont systemFontOfSize:fontsize],NSFontAttributeName,
                                           [UIColor blackColor],NSForegroundColorAttributeName,
                                           @(NSUnderlineStyleNone),NSUnderlineStyleAttributeName,nil];
    }
    curFontSize = fontsize;
    self.start = NO;
    return self;
}
- (void)start
{
    if (mainLab.text.length == 0) {
        return;
    }
//    NSDictionary *fontDec = [mainLab.attributedText attributesAtIndex:0 effectiveRange:nil];
    CGSize fontSize = [mainLab.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) options:NSStringDrawingUsesFontLeading attributes:attributeDict context:nil].size;
    rectMark1 = CGRectMake(0, 0, fontSize.width + 10, self.bounds.size.height);
    if (_direction == Left) {
        mainLab.frame = CGRectMake(self.frame.size.width, 0, rectMark1.size.width, rectMark1.size.height);
        _currentX = self.frame.size.width;
        
    }
    else
    {
        mainLab.frame = CGRectMake(-rectMark1.size.width, 0, rectMark1.size.width + 10, rectMark1.size.height);
        _currentX = 0;
    }

    self.start = YES;
    [self startTimer];
}
- (void)startTimer
{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(changeViewX) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}
- (void) changeViewX
{
    if (_direction == Left) {
        _currentX -= 1;
        if (_currentX <= -mainLab.frame.size.width) {
            _currentX = self.frame.size.width;
        }
         mainLab.frame = CGRectMake(_currentX, 0, mainLab.frame.size.width, mainLab.frame.size.height);
    }
    else
    {
        _currentX += 1;
        if (_currentX >= (self.frame.size.width + mainLab.frame.size.width)) {
            _currentX = 0;
        }
         mainLab.frame = CGRectMake( -mainLab.frame.size.width + _currentX, 0, mainLab.frame.size.width, mainLab.frame.size.height);
    }
   
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
    if (_currentTitle) {
        [self setText:_currentTitle];
    }
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
    if (curFontFlag) {
        [self setTextFlag:curFontFlag];
    }
    if (_currentTitle) {
        [self setText:_currentTitle];
    }
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
    else if([fontStyle isEqualToString:@"bold_italic"]){ return;}//不支持
    [attributeDict setObject:font forKey:NSFontAttributeName];
    if (_currentTitle) {
        [self setText:_currentTitle];
    }

}
- (void)setText:(NSString *)text
{
    _currentTitle = text;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:text attributes:attributeDict];
    if (attributeStr.length <= 0) {
        return;
    }
    [mainLab setAttributedText:attributeStr];
    CGSize fontSizes = [mainLab.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) options:NSStringDrawingUsesFontLeading attributes:attributeDict context:nil].size;
    rectMark1 = CGRectMake(_currentX, 0, fontSizes.width + 10, self.bounds.size.height);
    mainLab.frame = rectMark1;
}
- (void)setTextFlag:(NSString *)textFlag
{
    curFontFlag = textFlag;
    if (IOS_7 && curFontSize < 18) {
        return;
    }
    if ([textFlag isEqualToString:@"normal" ]) {
        attributeDict[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleNone);
        attributeDict[NSStrikethroughStyleAttributeName] = @(NSUnderlineStyleNone);
    }else if ([textFlag isEqualToString:@"underline" ]) {
        attributeDict[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
    }
    else if ([textFlag isEqualToString:@"strikethrough" ]) {
        [attributeDict setObject:@(NSUnderlineStyleSingle) forKey:NSStrikethroughStyleAttributeName];
    }
    if (_currentTitle) {
        [self setText:_currentTitle];
    }
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}
@end
