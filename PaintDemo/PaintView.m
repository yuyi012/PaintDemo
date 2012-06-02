//
//  PaintView.m
//  PaintDemo
//
//  Created by delacro on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PaintView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PaintView
@synthesize paintColor = _paintColor;
@synthesize erase;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.backgroundColor = [UIColor whiteColor];
        self.paintColor = [UIColor blackColor];
        // Initialization code
        linesArray = [[NSMutableArray alloc]init];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                    action:@selector(panGesture:)];
        [self addGestureRecognizer:panGesture];
        [panGesture release];
    }
    return self;
}

- (void)dealloc {
    [linesArray release];
    [_paintColor release];
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 20);
    //NSLog(@"color:%@",_paintColor);

    for (NSDictionary *lineDic in linesArray) {
        UIColor *lineColor = [lineDic objectForKey:@"color"];
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
        CGMutablePathRef paintPath = CGPathCreateMutable();
        NSArray *linePointArray = [lineDic objectForKey:@"line"];
        for (NSInteger i=0; i<linePointArray.count; i++) {
            CGPoint point = [[linePointArray objectAtIndex:i]CGPointValue];
            if (i==0) {
                //CGContextMoveToPoint(context, point.x, point.y);
                CGPathMoveToPoint(paintPath, NULL, point.x, point.y);
            }else {
                //CGContextAddLineToPoint(context, point.x, point.y);
                CGPathAddLineToPoint(paintPath, NULL, point.x, point.y);
            }
        }
        CGContextAddPath(context, paintPath);
        CGContextStrokePath(context);
        
        if ([lineDic objectForKey:@"eraseArray"]) {
            //NSLog(@"color:%@",lineColor);
            NSMutableArray *eraseArray = [lineDic objectForKey:@"eraseArray"];
            CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
            CGMutablePathRef paintPath = CGPathCreateMutable();
            for (NSInteger i=0; i<eraseArray.count; i++) {
                CGPoint point = [[eraseArray objectAtIndex:i]CGPointValue];
                //NSLog(@"erase point:%@",NSStringFromCGPoint(point));
                if (i==0) {
                    //CGContextMoveToPoint(context, point.x, point.y);
                    CGPathMoveToPoint(paintPath, NULL, point.x, point.y);
                }else {
                    //CGContextAddLineToPoint(context, point.x, point.y);
                    CGPathAddLineToPoint(paintPath, NULL, point.x, point.y);
                }
            }
            CGContextAddPath(context, paintPath);
            CGContextStrokePath(context);
        }
    }
}


-(void)panGesture:(UIPanGestureRecognizer*)thePan{
    CGPoint touchPoint = [thePan locationInView:self];
    if (self.erase) {
        if (thePan.state==UIGestureRecognizerStateChanged) {
            for (NSMutableDictionary *lineDic in linesArray) {
                NSMutableArray *linePointArray = [lineDic objectForKey:@"line"];
                for (NSInteger i=0; i<linePointArray.count; i++) {
                    CGPoint point = [[linePointArray objectAtIndex:i]CGPointValue];
                    CGFloat distance = powf(point.x-touchPoint.x,point.y-touchPoint.y);
                    if (distance<20) {
                        NSMutableArray *eraseArray;
                        if ([lineDic objectForKey:@"eraseArray"]) {
                            eraseArray = [lineDic objectForKey:@"eraseArray"];
                        }else {
                            eraseArray = [NSMutableArray array];
                        }
                        [eraseArray addObject:[NSValue valueWithCGPoint:touchPoint]];
                        [lineDic setObject:eraseArray forKey:@"eraseArray"];
                        CGRect paintRect = CGRectMake(touchPoint.x-50, touchPoint.y-50, 100, 100);
                        [self setNeedsDisplayInRect:paintRect];
                        //[self setNeedsDisplay];
                        continue;
                    }
                }
            }
        }
        //[self eraseLine:currentLineDic erase:[thePan locationInView:self]];
    }else {
        if (thePan.state==UIGestureRecognizerStateBegan) {
            NSMutableArray *currentLineArray = [NSMutableArray arrayWithObject:[NSValue valueWithCGPoint:touchPoint]];
            NSMutableDictionary *lineDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:currentLineArray,@"line",_paintColor,@"color", nil];
            [linesArray addObject:lineDic];
        }else if(thePan.state==UIGestureRecognizerStateChanged){
            NSMutableDictionary *lineDic = [linesArray lastObject];
            NSMutableArray *currentLineArray = [lineDic objectForKey:@"line"];
            [currentLineArray addObject:[NSValue valueWithCGPoint:touchPoint]];
            CGRect paintRect = CGRectMake(touchPoint.x-50, touchPoint.y-50, 100, 100);
            [self setNeedsDisplayInRect:paintRect];
        }else if(thePan.state==UIGestureRecognizerStateEnded){

        }
    }
}
@end
