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

@implementation doAutoScrollLabel
{
    
    CGRect rectMark1;//标记第一个位置
    CGRect rectMark2;//标记第二个位置
    NSMutableArray* labelArr;
    NSTimeInterval timeInterval;//时间
    BOOL isStop;//停止
    UILabel *mainLab;
    UILabel *rightLab;
    CGFloat curFontSize;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        mainLab = [[UILabel alloc]init];
        rightLab = [[UILabel alloc]init];
        [self addSubview:mainLab];
        [self addSubview:rightLab];
        labelArr = [NSMutableArray arrayWithObject:mainLab];
        [labelArr addObject:rightLab];
    }
    return self;
}
- (void)start
{
    timeInterval = [self displayDurationForString:mainLab.text];
    NSDictionary *fontDec = [mainLab.attributedText attributesAtIndex:0 effectiveRange:nil];
    CGSize fontSize = [mainLab.text sizeWithAttributes:fontDec];
    rectMark1 = CGRectMake(0, 0, fontSize.width, self.bounds.size.height);
    rectMark2 = CGRectMake(rectMark1.origin.x+rectMark1.size.width, 0, fontSize.width, self.bounds.size.height);

    mainLab.frame = rectMark1;
    //判断是否需要reserveTextLb
    BOOL useReserve = fontSize.width > self.frame.size.width ? YES : NO;
    
    if (!useReserve)
    {
        return;
    }
    isStop = NO;
    rightLab.frame = rectMark2;
    [self startAnimate];
}
- (void)stop
{
    isStop = YES;
}
- (void)startAnimate
{
    if (!isStop) {
        UILabel* lbindex0 = labelArr[0];
        UILabel* lbindex1 = labelArr[1];
        [UIView transitionWithView:self duration:timeInterval options:UIViewAnimationOptionCurveLinear animations:^{
            lbindex0.frame = CGRectMake(-rectMark1.size.width, 0, rectMark1.size.width, rectMark1.size.height);
            lbindex1.frame = CGRectMake(lbindex0.frame.origin.x+lbindex0.frame.size.width, 0, lbindex1.frame.size.width, lbindex1.frame.size.height);
            
        } completion:^(BOOL finished) {
            if (finished) {
                lbindex0.frame = rectMark2;
                lbindex1.frame = rectMark1;
                [labelArr replaceObjectAtIndex:0 withObject:lbindex1];
                [labelArr replaceObjectAtIndex:1 withObject:lbindex0];
                [self startAnimate];
            }
        }];
    }
}
- (NSTimeInterval)displayDurationForString:(NSString*)string {
    
    return string.length/5;
}

#pragma -mark -重写set方法
-(void)setFontColor:(UIColor *)fontColor
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithAttributedString:[self getTextAttributeString]];
    if (attributeStr.length <= 0) {
        return;
    }
    [attributeStr addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(0, attributeStr.length)];
    [mainLab setAttributedText:attributeStr];
    [rightLab setAttributedText:attributeStr];
}
- (void)setFontSize:(CGFloat)fontSize
{
    curFontSize = fontSize;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithAttributedString:[self getTextAttributeString]];
    if (attributeStr.length <= 0) {
        return;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CTFontRef ctFont =CTFontCreateWithName((CFStringRef)font.fontName,
                                           font.pointSize,
                                           NULL);
    [attributeStr addAttribute:(id)kCTFontAttributeName value:(__bridge id)ctFont range:NSMakeRange(0, attributeStr.length)];
    ctFont = nil;
    [mainLab setAttributedText:attributeStr];
    [rightLab setAttributedText:attributeStr];
    NSDictionary *fontDec = [mainLab.attributedText attributesAtIndex:0 effectiveRange:nil];
    CGSize fontSizes = [mainLab.text sizeWithAttributes:fontDec];
    rectMark1 = CGRectMake(0, 0, fontSizes.width, self.bounds.size.height);
    rectMark2 = CGRectMake(rectMark1.origin.x+rectMark1.size.width, 0, fontSizes.width, self.bounds.size.height);
//    mainLab.frame = rectMark1;
//    rightLab.frame = rectMark2;
}
- (void)setFontStyle:(NSString *)fontStyle
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithAttributedString:[self getTextAttributeString]];
    if (attributeStr.length <= 0) {
        return;
    }
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
    

    CTFontRef ctFont =CTFontCreateWithName((CFStringRef)font.fontName,
                                           font.pointSize,
                                           NULL);
    [attributeStr addAttribute:(id)kCTFontAttributeName value:(__bridge id)ctFont range:NSMakeRange(0, attributeStr.length)];
    ctFont = nil;
    [mainLab setAttributedText:attributeStr];
    [rightLab setAttributedText:attributeStr];
}
- (void)setText:(NSString *)text
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:text];
    if (attributeStr.length <= 0) {
        return;
    }
    
    [mainLab setAttributedText:attributeStr];
    mainLab.text = text;
    [rightLab setAttributedText:attributeStr];
    rightLab.text = text;
}
- (void)setTextAlgin:(NSString *)textAlgin
{
//    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithAttributedString:[self getTextAttributeString]];
//    if (attributeStr.length <= 0) {
//        return;
//    }
//    [attributeStr addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(0, attributeStr.length)];
//    [self setTextAttributeString:attributeStr];
}
- (void)setTextFlag:(NSString *)textFlag
{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithAttributedString:[self getTextAttributeString]];
    if (attributeStr.length <= 0) {
        return;
    }
    NSRange contentRange = {0,[attributeStr length]};
    if ([textFlag isEqualToString:@"normal" ]) {
        [attributeStr removeAttribute:NSUnderlineStyleAttributeName range:contentRange];
        [attributeStr removeAttribute:NSStrikethroughStyleAttributeName range:contentRange];
    }else if ([textFlag isEqualToString:@"underline" ]) {
        [attributeStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    }else if ([textFlag isEqualToString:@"strikethrough" ]) {
        [attributeStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    }
    
    [mainLab setAttributedText:attributeStr];
    [rightLab setAttributedText:attributeStr];
}
#pragma -mark - 私有方法
-(NSAttributedString *)getTextAttributeString
{
    return mainLab.attributedText;
}
- (void)setTextAttributeString:(NSMutableAttributedString *)attributedText
{
    mainLab.attributedText = attributedText;
}
@end
