//
//  NetworkManager.m
//  Weather
//
//  Created by Valerii Mykhailenko on 12/12/17.
//  Copyright © 2017 Mykhailenko Valerii. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking/AFNetworking.h"

//http://api.openweathermap.org/data/2.5/weather?q=london&units=metric&APPID=cfaf5cbe7aa6ce57a05ffc40c6e39359

@interface NetworkManager ()

@property (strong, nonatomic) AFURLSessionManager *manager;

@end

static NSString const *apiKey = @"&units=metric&APPID=cfaf5cbe7aa6ce57a05ffc40c6e39359"; //api with metric system
static NSString const *baceUrl = @"http://api.openweathermap.org/"; //base URL
static NSString const *weatherUrl = @"data/2.5/weather?q="; //weather

@implementation NetworkManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return self;
}

- (void)getWeatherInCity:(NSString *)city withCallback:(void (^)(NSDictionary *weatherInfo))callback {
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@", baceUrl, weatherUrl, city, apiKey];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request
                                                     completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            callback(nil);
        } else {
            NSDictionary *weatherInfo = @{@"city" : [responseObject valueForKey:@"name"],
                                          @"temperature" : [[responseObject valueForKey:@"main"] valueForKey:@"temp"],
                                          @"wind" : [[responseObject valueForKey:@"wind"] valueForKey:@"speed"],
                                          @"humidity" : [[responseObject valueForKey:@"main"] valueForKey:@"humidity"],
                                          @"clouds" : [[responseObject valueForKey:@"clouds"] valueForKey:@"all"],
                                          @"image" : [[[responseObject valueForKey:@"weather"] objectAtIndex:0] valueForKey:@"icon"]
                                       };
            callback(weatherInfo);
        }
    }];
    [dataTask resume];
}

@end

