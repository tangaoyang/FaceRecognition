//
//  ViewController.m
//  人脸识别
//
//  Created by cinderella on 2020/1/30.
//  Copyright © 2020 cinderella. All rights reserved.
//

#import "ViewController.h"
#import "ImageManager.h"
#import "ImageModel.h"
#import "AccessModel.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[ImageManager sharedManger] getAccess:^(AccessModel * _Nonnull AccessModel) {
        self.access_token = AccessModel.access_token;
        NSLog(@"self.access_token == %@", self.access_token);
    } error:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
     [self addObserver:[ImageManager sharedManger] forKeyPath:@"access_token" options:NSKeyValueObservingOptionNew context:nil];
    
    UIImageView *mmImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mmm.jpg"]];
    mmImageView.frame = CGRectMake(0, 150, self.view.bounds.size.width, 250);
    [self.view addSubview:mmImageView];
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[ImageManager sharedManger] identification:^(ImageModel *resultImageModel) {
        ImageModel *model = [[ImageModel alloc] init];
        model = resultImageModel;
        ListModel *list = [[ListModel alloc] init];
        list = model.result.face_list[0];
        UILabel *label = [[UILabel alloc] init];
        [self.view addSubview:label];
        label.frame = CGRectMake(50, 450, self.view.bounds.size.width - 100, 50);
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15];
        label.text = [NSString stringWithFormat:@"年龄为%@岁， 性别为%@的可能性是%@， 表情为%@的可能性是%@", list.age, list.gender.type, list.gender.probability, list.expression.type, list.expression.probability];
    }];
}


@end
