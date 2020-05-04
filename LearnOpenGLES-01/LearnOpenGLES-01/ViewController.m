//
//  ViewController.m
//  LearnOpenGLES-01
//
//  Created by Lowell on 2020/5/5.
//  Copyright © 2020 zh2zh. All rights reserved.
//

#import "ViewController.h"
#import "TrianglesDemoController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}
- (IBAction)trianglesBtnClick:(UIButton *)sender {
    
    TrianglesDemoController *triangleController = [[TrianglesDemoController alloc] init];
    
    [self.navigationController pushViewController:triangleController animated:YES];
    
}


@end
