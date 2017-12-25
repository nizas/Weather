 //
//  WeatherModel.m
//  Weather
//
//  Created by Valerii Mykhailenko on 12/16/17.
//  Copyright © 2017 Mykhailenko Valerii. All rights reserved.
//

#import "WeatherModel.h"
#import "NetworkManager.h"
#import "CLLocationManager+blocks.h"

@interface WeatherModel ()

@property (strong, nonatomic) NetworkManager *networkManager;
@property (strong, nonatomic) CLLocationManager *managerLocation;

@end

@implementation WeatherModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.networkManager = [NetworkManager new];
    }
    return self;
}

- (void)fillModelFrom:(NSDictionary *)weatherInfo {
    self.cityName = [weatherInfo valueForKey:@"city"];
    self.temperature = [NSString stringWithFormat:@"%d°C", [[weatherInfo valueForKey:@"temperature"] intValue]];
    self.temperatureMin = [NSString stringWithFormat:@"min %d°C", [[weatherInfo valueForKey:@"temperature_min"] intValue]];
    self.temperatureMax = [NSString stringWithFormat:@"max %d°C", [[weatherInfo valueForKey:@"temperature_max"] intValue]];
    self.wind = [NSString stringWithFormat:@"%d m/s wind", [[weatherInfo valueForKey:@"wind"] intValue]];
    self.humidity = [NSString stringWithFormat:@"%d%% humidity", [[weatherInfo valueForKey:@"humidity"] intValue]];
    self.clouds = [NSString stringWithFormat:@"%d%% overcast", [[weatherInfo valueForKey:@"clouds"] intValue]];
    self.imageURL = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", [weatherInfo valueForKey:@"image"]];
}

- (void)addInModel:(NSString *)cityName andResult:(ResultBlock)result {
    [self.networkManager getWeatherIn:cityName withRequestCompletion:^(NSDictionary *weatherInfo) {
        if (weatherInfo == nil) {
            result(@"error");
        } else {
            [self fillModelFrom:weatherInfo];
            result(@"completion");
        }
    }];
}

- (void)addInModelAutoLocation:(ResultBlock)result {
    self.managerLocation = [CLLocationManager updateManagerWithAccuracy:50.0
                                                            locationAge:15.0
                                                authorizationDesciption:CLLocationUpdateAuthorizationDescriptionAlways];
    [self.managerLocation startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager,
                                                                 CLLocation *location,
                                                                 NSError *error,
                                                                 BOOL *stopUpdating) {
        [self.networkManager getWeatherByLat:location.coordinate.latitude
                                      andLon:location.coordinate.longitude
                       withRequestCompletion:^(NSDictionary *weatherInfo) {
            if (weatherInfo == nil) {
                result(@"error");
            } else {
                result([weatherInfo valueForKey:@"city"]);
            }
        }];
    }];
}

- (void)addInDatabase:(NSString *)cityName completion:(СompletionBlock)completed {
    [self.networkManager getWeatherIn:cityName withRequestCompletion:^(NSDictionary *weatherInfo) {
        if (weatherInfo != nil) {
            NSArray *array = [Cities MR_findAll];
            NSInteger checkValue = 0;
            if (array.count == 0) {
                NSManagedObjectContext *contex = [NSManagedObjectContext MR_defaultContext];
                Cities *cities = [Cities MR_createEntityInContext:contex];
                cities.name = cityName;
                [contex MR_saveToPersistentStoreAndWait];
            } else {
                for (NSInteger i = 0; i < array.count; i++) {
                    if (([cityName caseInsensitiveCompare:[array[i] name]] == NSOrderedSame)) {
                        checkValue++;
                        break;
                    }
                }
                if (checkValue == 0) {
                    NSManagedObjectContext *contex = [NSManagedObjectContext MR_defaultContext];
                    Cities *city = [Cities MR_createEntityInContext:contex];
                    city.name = cityName;
                    [contex MR_saveToPersistentStoreAndWait];
                    completed();
                }
            }
        }
    }];
}

- (void)deleteFromDatabase:(Cities *)cityEntity {
    NSManagedObjectContext *contex = [NSManagedObjectContext MR_defaultContext];
    Cities *city = cityEntity;
    [city MR_deleteEntityInContext:contex];
    [contex MR_saveToPersistentStoreAndWait];
}

@end
