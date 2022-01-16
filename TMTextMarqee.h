//
//  TMTextMarqee.h
//  SquareSynth
//
//  Created by James Navarro on 7/21/14.
//  Copyright (c) 2014 James Navarro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TMTextMarqeeDelegate <NSObject>

- (void)tmMarqee_doneScrolling:(NSInteger)index;

@end

typedef enum : NSUInteger {
    TMTextLeft = 0,
    TMTextCenter,
    TMTextRight,
} TMTextAlignment;

@interface TMTextMarqee : UIView
{
    
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, assign) NSTimeInterval speed; // pixels per second
@property (nonatomic, assign) UILabel *label;
@property (nonatomic, retain) id <TMTextMarqeeDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) TMTextAlignment align;
@property (nonatomic, assign) BOOL isAnimating;

- (void)setText:(NSString*)text;
- (NSString*)text;

- (void)setTextColor:(UIColor*)color;
- (void)scroll;
- (void)center:(BOOL)aCenter;

@end
