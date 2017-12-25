//
//  NetworkManager.m
//  Weather
//
//  Created by Valerii Mykhailenko on 12/12/17.
//  Copyright © 2017 Mykhailenko Valerii. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking/AFNetworking.h"

@interface NetworkManager ()

@property (strong, nonatomic) AFURLSessionManager *manager;

@end

static NSString const *apiKey = @"&units=metric&APPID=6bc0b502577ea73ec155f4a195674083"; //api with metric system
static NSString const *baceUrl = @"http://api.openweathermap.org/"; //base URL
static NSString const *weatherCityUrl = @"data/2.5/weather?q="; //getting weather from the name of the city
static NSString const *weatherWithCoordinatesUrl = @"data/2.5/weather?"; //getting the weather from the coordinates of the city | need to substitute the coordinates data/2.5/weather?lat=37.7858&lon=122.40

@implementation NetworkManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return self;
}

- (void)getWeatherIn:(NSString *)city withRequestCompletion:(NetworkCompletionBlock)completion {
    NSString *cityName = [city stringByReplacingOccurrencesOfString:@" " withString:@"%20"]; //if the city name contains 2 words
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@", baceUrl, weatherCityUrl, cityName, apiKey];
    NSURL *URL = [NSURL URLWithString:urlString];
    [self getWeatherFrom:URL withRequestCompletion:^(NSDictionary *weatherInfo) {
        completion(weatherInfo);
    }];
}

- (void)getWeatherByLat:(double)lat andLon:(double)lon withRequestCompletion:(NetworkCompletionBlock)completion {
    NSString *urlString = [NSString stringWithFormat:@"%@%@lat=%f&lon=%f%@", baceUrl, weatherWithCoordinatesUrl, lat, lon, apiKey];
    NSURL *URL = [NSURL URLWithString:urlString];
    [self getWeatherFrom:URL withRequestCompletion:^(NSDictionary *weatherInfo) {
        completion(weatherInfo);
    }];
}

- (void)getWeatherFrom:(NSURL *)URL withRequestCompletion:(NetworkCompletionBlock)completion {
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request
                                                     completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            completion(nil);
        } else {
            NSDictionary *weatherInfo = @{@"city" : [responseObject valueForKey:@"name"],
                                          @"temperature" : [[responseObject valueForKey:@"main"] valueForKey:@"temp"],
                                          @"temperature_min" : [[responseObject valueForKey:@"main"] valueForKey:@"temp_min"],
                                          @"temperature_max" : [[responseObject valueForKey:@"main"] valueForKey:@"temp_max"],
                                          @"wind" : [[responseObject valueForKey:@"wind"] valueForKey:@"speed"],
                                          @"humidity" : [[responseObject valueForKey:@"main"] valueForKey:@"humidity"],
                                          @"clouds" : [[responseObject valueForKey:@"clouds"] valueForKey:@"all"],
                                          @"image" : [[[responseObject valueForKey:@"weather"] objectAtIndex:0] valueForKey:@"icon"]
                                        };
            completion(weatherInfo);
        };
    }];
    [dataTask resume];
}

@end
