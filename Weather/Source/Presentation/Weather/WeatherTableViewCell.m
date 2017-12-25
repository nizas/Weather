//
//  WeatherTableViewCell.m
//  Weather
//
//  Created by Valerii Mykhailenko on 12/12/17.
//  Copyright © 2017 Mykhailenko Valerii. All rights reserved.
//

#import "WeatherTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WeatherModel.h"

@interface WeatherTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (strong, nonatomic) WeatherModel *model;

@end

@implementation WeatherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
        self.model = [WeatherModel new];
}

- (void)fillCellWith:(NSString *)cityName {
    __weak typeof(self) weakSelf = self;
    [self.model addInModel:cityName andResult:^(NSString *result) {
        if (![result isEqualToString:@"error"]) {
            weakSelf.cityLabel.text = weakSelf.model.cityName;
            weakSelf.temperatureLabel.text = weakSelf.model.temperature;
            [weakSelf.weatherImage sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.imageURL]];
        }
    }];
}

@end
