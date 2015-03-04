//
//  XLFormTextViewCell.m
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

#import "XLFormRowDescriptor.h"
#import "UIView+XLFormAdditions.h"
#import "XLFormViewController.h"
#import "XLFormTextView.h"
#import "XLFormTextViewCell.h"

NSString *const kFormTextViewCellPlaceholder = @"placeholder";

@interface XLFormTextViewCell() <UITextViewDelegate>

@end

@implementation XLFormTextViewCell
{
    NSArray * _dynamicCustomConstraints;
}

@synthesize textLabel = _textLabel;
@synthesize textView = _textView;

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.textLabel && [keyPath isEqualToString:@"text"]){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            [self needsUpdateConstraints];
        }
    }
}

-(void)dealloc
{
    [self.textLabel removeObserver:self forKeyPath:@"text"];
}


#pragma mark - Properties

-(UILabel *)textLabel
{
    if (_textLabel) return _textLabel;
    _textLabel = [UILabel autolayoutView];
    [_textLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    return _textLabel;
}

-(XLFormTextView *)textView
{
    if (_textView) return _textView;
    _textView = [XLFormTextView autolayoutView];
    return _textView;
}


#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.textView];
    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    NSDictionary * views = @{@"label": self.textLabel, @"textView": self.textView};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[label]-[textView]-|" options:0 metrics:0 views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[label]-16-|" options:0 metrics:0 views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[textView]-16-|" options:0 metrics:0 views:views]];
}

-(void)update
{
    [super update];
    self.textView.delegate = self;
    self.textLabel.font = [XLFormConfig defaultFont];//[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textView.font = [XLFormConfig defaultFont];//[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textView.placeHolderLabel.font = [XLFormConfig defaultFont];//[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.text = self.rowDescriptor.value;
    [self.textView setEditable:!self.rowDescriptor.disabled];
    self.textView.textColor  = self.rowDescriptor.disabled ? [UIColor grayColor] : [UIColor blackColor];
    self.textLabel.textColor = self.rowDescriptor.disabled ? [UIColor grayColor] : [UIColor blackColor];
    self.textLabel.text = ((self.rowDescriptor.required && self.rowDescriptor.title && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle) ? [NSString stringWithFormat:@"%@*", self.rowDescriptor.title]: self.rowDescriptor.title);
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 110.f;
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.textView becomeFirstResponder];
}

-(BOOL)formDescriptorCellResignFirstResponder
{
    return [self.textView resignFirstResponder];
}

#pragma mark - Constraints

//-(void)updateConstraints
//{
//    if (_dynamicCustomConstraints){
//        [self.contentView removeConstraints:_dynamicCustomConstraints];
//    }
//    NSDictionary * views = @{@"label": self.label, @"textView": self.textView};
//    if (!self.label.text || [self.label.text isEqualToString:@""]){
//        _dynamicCustomConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[textView]-16-|" options:0 metrics:0 views:views];
//    }
//    else{
//        _dynamicCustomConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[label]-[textView]-4-|" options:0 metrics:0 views:views];
//    }
//    [self.contentView addConstraints:_dynamicCustomConstraints];
//    [super updateConstraints];
//}

#pragma mark - UITextViewDelegate

-(void)textViewDidEndEditing:(UITextView *)textView{
    if([self.textView.text length] > 0) {
        self.rowDescriptor.value = self.textView.text;
    } else {
        self.rowDescriptor.value = nil;
    }
    [self.formViewController textViewDidEndEditing:textView];
}

-(void)textViewDidChange:(UITextView *)textView{
    if([self.textView.text length] > 0) {
        self.rowDescriptor.value = self.textView.text;
    } else {
        self.rowDescriptor.value = nil;
    }
}

@end
