//
//  WeatherModel.h
//  Weather
//
//  Created by Valerii Mykhailenko on 12/16/17.
//  Copyright © 2017 Mykhailenko Valerii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MagicalRecord/MagicalRecord.h"
#import "Cities+CoreDataProperties.h"

typedef void (^ResultBlock)(NSString *result);
typedef void (^СompletionBlock)(void);

@interface WeatherModel : NSObject

@property (strong, nonatomic) NSString *cityName;
@property (strong, nonatomic) NSString *temperature;
@property (strong, nonatomic) NSString *temperatureMin;
@property (strong, nonatomic) NSString *temperatureMax;
@property (strong, nonatomic) NSString *wind;
@property (strong, nonatomic) NSString *humidity;
@property (strong, nonatomic) NSString *clouds;
@property (strong, nonatomic) NSString *imageURL;

- (void)addInModel:(NSString *)cityName andResult:(ResultBlock)result;

- (void)addInModelAutoLocation:(ResultBlock)result;

- (void)addInDatabase:(NSString *)cityName completion:(СompletionBlock)completion;

- (void)deleteFromDatabase:(Cities *)cityEntity;

@end
