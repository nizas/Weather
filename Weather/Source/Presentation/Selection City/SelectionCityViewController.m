//
//  SelectionCityViewController.m
//  Weather
//
//  Created by Valerii Mykhailenko on 12/12/17.
//  Copyright © 2017 Mykhailenko Valerii. All rights reserved.
//

#import "SelectionCityViewController.h"
#import "NetworkManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SelectionCityViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NetworkManager *manager;
@property (strong, nonatomic) NSDictionary *weatherDict;

@end

@implementation SelectionCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weatherDict = [NSDictionary new];
    self.manager = [NetworkManager new];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.manager getWeatherInCity:searchBar.text withCallback:^(NSDictionary *weatherInfo) {
        if (weatherInfo == nil) {
            NSLog(@"Error");
        } else {
            self.cityLabel.hidden = FALSE;
            self.windLabel.hidden = FALSE;
            self.humidityLabel.hidden = FALSE;
            self.cloudsLabel.hidden = FALSE;
            self.temperatureLabel.hidden = FALSE;
            self.weatherImageView.hidden = FALSE;
            self.weatherDict = weatherInfo;
            self.cityLabel.text = [self.weatherDict valueForKey:@"city"];
            self.temperatureLabel.text = [NSString stringWithFormat:@"%d°C", [[self.weatherDict valueForKey:@"temperature"] intValue]];
            self.windLabel.text = [NSString stringWithFormat:@"Wind %d m/s", [[self.weatherDict valueForKey:@"wind"] intValue]];
            self.humidityLabel.text = [NSString stringWithFormat:@"%d%% humidity", [[self.weatherDict valueForKey:@"humidity"] intValue]];
            self.cloudsLabel.text = [NSString stringWithFormat:@"%d%% overcast", [[self.weatherDict valueForKey:@"clouds"] intValue]];
            [self.weatherImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", [self.weatherDict valueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        }
    }];
}

@end

