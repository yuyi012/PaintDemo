//
//  ViewController.m
//  PaintDemo
//
//  Created by delacro on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

-(void)loadView{
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    container.backgroundColor = [UIColor whiteColor];
    self.view = container;
    [container release];
    
    paintView = [[PaintView alloc]initWithFrame:CGRectMake(20, 20, 280, 350)];
    paintView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:paintView];
    
    UIButton *redButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 380, 50, 50)];
    [redButton setBackgroundColor:[UIColor redColor]];
    [redButton addTarget:self
                  action:@selector(redButtonClick:) 
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redButton];
    [redButton release];
    
    UIButton *blueButton = [[UIButton alloc]initWithFrame:CGRectMake(90, 380, 50, 50)];
    [blueButton setBackgroundColor:[UIColor blueColor]];
    [blueButton addTarget:self
                  action:@selector(redButtonClick:) 
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blueButton];
    [blueButton release];
    
    UIButton *yellowButton = [[UIButton alloc]initWithFrame:CGRectMake(160, 380, 50, 50)];
    [yellowButton setBackgroundColor:[UIColor yellowColor]];
    [yellowButton addTarget:self
                  action:@selector(redButtonClick:) 
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yellowButton];
    [yellowButton release];
    
    UIButton *eraserButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [eraserButton setTitle:@"橡皮擦" forState:UIControlStateNormal];
    eraserButton.frame = CGRectMake(230, 380, 50, 50);
    [eraserButton addTarget:self
                     action:@selector(eraserButtonClick)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eraserButton];
}

- (void)dealloc
{
    [paintView release];
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)redButtonClick:(UIButton*)theButton{
    paintView.paintColor = theButton.backgroundColor;
    paintView.erase = NO;
}

-(void)eraserButtonClick{
    paintView.erase = YES;
}
@end
