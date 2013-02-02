//
//  ContentView.m
//  balancing
//
//  Created by Grzegorz Krukiewicz-Gacek on 02.02.2013.
//  Copyright (c) 2013 AGDev. All rights reserved.
//

#import "ContentView.h"
#import "Support.h"
#import "Rod.h"

@interface ContentView ()
{
    CGContextRef context;
    CGPoint startPoint;
    CGPoint endPoint;
}

@property (nonatomic) CGContextRef context;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;

@end

@implementation ContentView

@synthesize delegate;
@synthesize mechanism;
@synthesize context;
@synthesize startPoint;
@synthesize endPoint;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.context = UIGraphicsGetCurrentContext();
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.context = UIGraphicsGetCurrentContext();
    
    //draw supports first as they are images and must be in the background
    NSArray *supports = [[NSArray alloc] initWithArray:
                                        [self.mechanism.supports allObjects]];
    
    for (Support *support in supports) {
        NSLog (@"Drawing support with parameters:");
        NSLog (@"x: %@", support.x);
        NSLog (@"y: %@", support.y);
        NSLog (@"type: %@", support.type);
        
        CGPoint point = CGPointMake([support.x floatValue] + self.frame.size.width/2 - 20,
                                    [support.y floatValue] + self.frame.size.height/2 - 9);
        if ([support.type isEqualToString:@"Grounded"])
        {
            UIImage *image = [UIImage imageNamed:@"PinnedSupportSmall.png"];
            [image drawAtPoint:point];
        }
        else if ([support.type isEqualToString:@"Roller"])
        {
            UIImage *image = [UIImage imageNamed:@"RollerSupportSmall.png"];
            [image drawAtPoint:point];
        }
    }
    
    //drawing x and y axis
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(self.context, [UIColor blueColor].CGColor);
    
    //y
    CGContextMoveToPoint(self.context, self.frame.size.width/2, self.frame.size.height/2);
    CGContextAddLineToPoint(self.context, self.frame.size.width/2, self.frame.size.height/2 -50);
    CGContextAddLineToPoint(self.context, self.frame.size.width/2 -5, self.frame.size.height/2 -45);
    CGContextAddLineToPoint(self.context, self.frame.size.width/2 +5, self.frame.size.height/2 -45);
    CGContextAddLineToPoint(self.context, self.frame.size.width/2, self.frame.size.height/2 -50);
    CGContextStrokePath(self.context);
    
    //x
    CGContextMoveToPoint(self.context, self.frame.size.width/2, self.frame.size.height/2);
    CGContextAddLineToPoint(self.context, self.frame.size.width/2 +50, self.frame.size.height/2);
    CGContextAddLineToPoint(self.context, self.frame.size.width/2 +45, self.frame.size.height/2 -5);
    CGContextAddLineToPoint(self.context, self.frame.size.width/2 +45, self.frame.size.height/2 +5);
    CGContextAddLineToPoint(self.context, self.frame.size.width/2 +50, self.frame.size.height/2);
    CGContextStrokePath(self.context);
    
    CGContextSetLineWidth(self.context, 2.0);
    CGContextSetStrokeColorWithColor(self.context, [UIColor blackColor].CGColor);
    
    
    //draw rods
    NSArray *rods = [[NSArray alloc] initWithArray:
                         [self.mechanism.rods allObjects]];
    
    for (Rod *rod in rods) {
        NSLog (@"Drawing rod with parameters:");
        NSLog (@"aX: %@", rod.xA);
        NSLog (@"aY: %@", rod.yA);
        NSLog (@"bX: %@", rod.xB);
        NSLog (@"bY: %@", rod.yB);
        NSLog (@"Mass: %@", rod.mass);
        CGPoint Apoint = CGPointMake([rod.xA floatValue] + self.frame.size.width/2,
                                     -[rod.yA floatValue] + self.frame.size.height/2);   // - is necessary because of Quartz inverted y axis
        CGPoint Bpoint = CGPointMake([rod.xB floatValue] + self.frame.size.width/2,
                                     -[rod.yB floatValue] + self.frame.size.height/2);
        
        CGContextMoveToPoint(self.context, Apoint.x, Apoint.y);
        CGContextAddLineToPoint(self.context, Bpoint.x, Bpoint.y);
        
        CGRect rectangle = CGRectMake([rod.xA floatValue] + self.frame.size.width/2 -4,
                                      [rod.yA floatValue] + self.frame.size.height/2 -4,
                                      8, 8);
        CGContextAddEllipseInRect(self.context, rectangle);
        CGContextStrokePath(self.context);
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.startPoint = [touch locationInView:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.endPoint = [touch locationInView:self];
    [self.delegate createRodWithMass:1 aPoint:self.startPoint bPoint:self.endPoint];
}

- (void)drawElement
{
    
}

@end
