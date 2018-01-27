//
//  ViewController.m
//  MyWorkPlace
//
//  Created by modong on 2018/1/27.
//  Copyright © 2018年 modong. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lonlatLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property(nonatomic ,strong) CLLocationManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    //    [manager requestAlwaysAuthorization];
    [_manager requestWhenInUseAuthorization];
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    _manager.distanceFilter = 1.0;
    [_manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    //1.如果打卡地点是这里，当前的经纬度。
    //2.直接copy下面的经纬度，无需转换
    //3.去Location1.gpx修改经纬度
    //当前的经纬度
    NSLog(@"当前的经纬度 %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    self.lonlatLabel.text = [NSString stringWithFormat:@"纬度:%f,经度:%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
    
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            //看需求定义一个全局变量来接收赋值
            NSLog(@"当前国家 - %@",placeMark.country);//当前国家
            NSLog(@"当前城市 - %@",currentCity);//当前城市
            NSLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
            NSLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
            NSLog(@"具体地址 - %@",placeMark.name);//具体地址
            self.infoLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placeMark.country,currentCity,placeMark.subLocality,placeMark.thoroughfare,placeMark.name];
        }
    }];
}
@end
