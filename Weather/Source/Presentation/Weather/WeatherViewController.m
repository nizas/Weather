//
//  SelectionCityViewController.m
//  Weather
//
//  Created by Valerii Mykhailenko on 12/12/17.
//  Copyright © 2017 Mykhailenko Valerii. All rights reserved.
//

#import "WeatherViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WeatherTableViewCell.h"
#import "WeatherModel.h"

@interface WeatherViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (strong, nonatomic) NSArray *citiesArray;
@property (strong, nonatomic) WeatherModel *model;

@end

static NSString *const kCityTableVIewCell = @"kCityTableVIewCell";

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [WeatherModel new];
    self.citiesArray = [Cities MR_findAll];
    if (self.citiesArray.firstObject != nil) {
        [self fillMainScreenFrom:[self.citiesArray.lastObject name]];
    }
    [self.searchBar setShowsCancelButton:NO animated:NO];
}

- (void)fillMainScreenFrom:(NSString *)cityName {
    __weak typeof(self) weakSelf = self;
    [self.model addInModel:cityName andResult:^(NSString *result) {
        if ([result isEqualToString:@"error"]) {
            [weakSelf showAlertWithTitle:@"City not found" andMessage:@"Enter the correct city name."];
            weakSelf.searchBar.text = @"";
        } else {
            weakSelf.navigationItem.title = weakSelf.model.cityName;
            weakSelf.temperatureLabel.text = weakSelf.model.temperature;
            weakSelf.temperatureMinLabel.text = weakSelf.model.temperatureMin;
            weakSelf.temperatureMaxLabel.text = weakSelf.model.temperatureMax;
            weakSelf.windLabel.text = weakSelf.model.wind;
            weakSelf.humidityLabel.text = weakSelf.model.humidity;
            weakSelf.cloudsLabel.text = weakSelf.model.clouds;
            [weakSelf.weatherImage sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.imageURL]];
        }
    }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.text = @"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    __weak typeof(self) weakSelf = self;
    [self.searchBar resignFirstResponder];
    [self fillMainScreenFrom:searchBar.text];
    [self.model addInDatabase:searchBar.text completion:^{
            weakSelf.citiesArray = [Cities MR_findAll];
            [weakSelf.tableView reloadData];
    }];
}

- (IBAction)autocacationButton:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.model addInModelAutoLocation:^(NSString *result) {
        [weakSelf fillMainScreenFrom:result];
        [weakSelf.model addInDatabase:result completion:^{
            weakSelf.citiesArray = [Cities MR_findAll];
            [weakSelf.tableView reloadData];
        }];
    }];
}

- (IBAction)viewWasTapped:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.citiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCityTableVIewCell];
    [cell fillCellWith:[self.citiesArray[((self.citiesArray.count - 1) - indexPath.row)] name]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self fillMainScreenFrom:[self.citiesArray[((self.citiesArray.count - 1) - indexPath.row)] name]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.model deleteFromDatabase:self.citiesArray[((self.citiesArray.count - 1) - indexPath.row)]];
        self.citiesArray = [Cities MR_findAll];
        [self.tableView reloadData];
    }
}

@end
