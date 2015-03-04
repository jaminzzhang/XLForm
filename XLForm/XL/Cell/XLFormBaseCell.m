//
//  XLFormBaseCell.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2014 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLFormBaseCell.h"
#import "UIView+XLFormAdditions.h"

@implementation XLFormBaseCell
@synthesize detailTextLabel = _detailTextLabel;


- (id)init
{
    return [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.textMinWidth = floor(self.bounds.size.width/3) + 8;
        [self configure];
    }
    return self;
}


-(void)setRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    _rowDescriptor = rowDescriptor;
    [self update];
}


- (UILabel *)detailTextLabel
{
    
    if (_detailTextLabel) return _detailTextLabel;
    _detailTextLabel = [UILabel autolayoutView];
    _detailTextLabel.textAlignment = NSTextAlignmentCenter;
    _detailTextLabel.textColor = [XLFormConfig valueDefaultColor];
    _detailTextLabel.frame = self.contentView.bounds;
    [_detailTextLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:_detailTextLabel];
    return _detailTextLabel;
}

- (CGFloat)textMinWidth
{
    if (_textMinWidth == -1) {
        return floor(self.bounds.size.width/3);
    }
    
    return _textMinWidth;
}


- (void)configure
{
    //override
}

- (void)update
{
    // override
    self.detailTextLabel.textColor = self.rowDescriptor.disabled ? [UIColor grayColor] : [XLFormConfig valueDefaultColor];
}


-(XLFormViewController *)formViewController
{
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect textFrame = self.textLabel.frame;
    if (textFrame.size.width < self.textMinWidth) {
        textFrame.size.width = self.textMinWidth;
        self.textLabel.frame = textFrame;
    } else {
        CGFloat maxWidth = self.contentView.frame.size.width - textFrame.origin.x - 40;
        if (textFrame.size.width > maxWidth) {
            textFrame.size.width = maxWidth;
            self.textLabel.frame = textFrame;
        }
        
    }
    
    if (nil != self.detailTextLabel) {
        CGRect detailFrame = self.detailTextLabel.frame;
        detailFrame.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + 8;
        detailFrame.size.width = self.contentView.bounds.size.width - detailFrame.origin.x - 4;
        self.detailTextLabel.frame = detailFrame;
    }
}


@end
