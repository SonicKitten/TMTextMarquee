//
//  TMTextMarqee.m
//  SquareSynth
//
//  Created by James Navarro on 7/21/14.
//  Copyright (c) 2014 James Navarro. All rights reserved.
//

#import "TMTextMarqee.h"
#import <QuartzCore/QuartzCore.h>

@interface TMTextMarqee ()
{
    BOOL _cancel;
}

@property (nonatomic)  NSDictionary *attributes;

-(void)commonInit;

@end


@implementation TMTextMarqee

@synthesize label, scrollView, attributes = _attributes, speed = _speed, delegate = _delegate, font = _font;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ([super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ((self = [super initWithFrame:frame]))
    {
        [self commonInit];
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
    _index = 0;
    _speed = 0.016;
    _cancel = NO;
    self.backgroundColor = [UIColor clearColor];
    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
    self.scrollView.contentSize = self.label.frame.size;
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    self.label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
    self.label.backgroundColor = [UIColor clearColor];
    self.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    self.label.font = self.font;
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.contentMode = UIViewContentModeLeft;
    
    
    [self.scrollView addSubview:self.label];
    [self addSubview:self.scrollView];
   
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.scrollView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    _isAnimating = NO;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _attributes = @{NSFontAttributeName: self.font};
    CGRect rect = [self.label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:_attributes
                                                context:nil];
    rect = CGRectMake(rect.origin.x, rect.origin.y, MAX(rect.size.width, self.frame.size.width), rect.size.height);
    
    
    self.scrollView.contentSize = rect.size;
    if ([self.scrollView.layer animationKeys].count == 0)
    {
         [self setText:self.text]; // tricky
    }
}

- (void)setText:(NSString *)text
{
    // cancel animation
    _cancel = YES;
    [self.scrollView.layer removeAllAnimations];
    
    self.label.text = text;
    _attributes = @{NSFontAttributeName: self.font};
    
    CGRect rect = [self.label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:_attributes
                                                context:nil];
    rect = CGRectMake(rect.origin.x, rect.origin.y, MAX(rect.size.width, self.frame.size.width), self.bounds.size.height);
    
    self.scrollView.contentSize = rect.size;
    self.label.frame = rect;
}

- (NSString *)text
{
    return self.label.text;
}

-(void)setAlign:(TMTextAlignment)align
{
    _align = align;
    [self setNeedsLayout];
}

- (void)scroll
{
    __block NSTimeInterval dur = _speed * self.label.frame.size.width;
    
    if (self.label.frame.size.width > self.frame.size.width)
    {
        _cancel = NO;
        _isAnimating = YES;
        [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.scrollView.contentOffset = CGPointMake(self.label.frame.size.width, 0);
           
        } completion:^(BOOL finished) {
            _isAnimating = NO;
            if (_cancel == NO)
            {
                self.scrollView.contentOffset = CGPointMake(-self.frame.size.width, 0);
                // Find width of single char, with font. Then divide self.frame.size.width by that. That times speed is dur.
                dur = _speed * self.frame.size.width;
                [UIView animateWithDuration:dur delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.scrollView.contentOffset = CGPointMake(0, 0);
                } completion:^(BOOL finished) {
                    [self.delegate tmMarqee_doneScrolling:self.index];
                }];
            }
            else
            {
                _cancel = NO;
                self.scrollView.contentOffset = CGPointMake(0, 0);
                [self.delegate tmMarqee_doneScrolling:self.index];
            }
        }];
    }
    else
    {
        [self.delegate tmMarqee_doneScrolling:self.index];
    }
}

- (void)setTextColor:(UIColor*)color
{
    self.label.textColor = color;
}

-(void)setFont:(UIFont *)font
{
    _font = font;
    self.label.font = _font;
    //[self setText:_text];
}

-(UIFont *)font
{
    return _font;
}

- (void)center:(BOOL)aCenter
{
    if (aCenter)
    {
        self.label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.scrollView.contentSize = self.label.frame.size;
        [self.label setTextAlignment:NSTextAlignmentCenter];
    }
    else
    {
        _attributes = @{NSFontAttributeName: self.label.font};
        CGRect rect = [self.label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:_attributes
                                                    context:nil];
        self.scrollView.contentSize = rect.size;
        self.label.frame = rect;
        [self.label setTextAlignment:NSTextAlignmentLeft];
    }
}

@end
