//
//  XLFormConfig.m
//  Pods
//
//  Created by Jamin on 1/20/15.
//
//

#import "XLFormConfig.h"


static UIFont * kXLFormDefaultFont;
static UIColor * kXLFormValueDefaultColor;


@implementation XLFormConfig


#pragma mark - Global Config
+ (UIFont *)defaultFont
{
    if (nil == kXLFormDefaultFont) {
        kXLFormDefaultFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return kXLFormDefaultFont;
}

+ (void)setDefaultFont:(UIFont *)font
{
    kXLFormDefaultFont = font;
}


+ (UIColor *)valueDefaultColor
{
    if (nil == kXLFormValueDefaultColor) {
        kXLFormValueDefaultColor = [UIColor darkTextColor];
    }
    return kXLFormValueDefaultColor;
}

+ (void)setValueDefaultColor:(UIColor *)color
{
    kXLFormValueDefaultColor = color;
}



@end
