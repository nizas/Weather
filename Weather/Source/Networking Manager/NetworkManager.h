//
//  NetworkManager.h
//  Weather
//
//  Created by Valerii Mykhailenko on 12/12/17.
//  Copyright © 2017 Mykhailenko Valerii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

- (void)getWeatherInCity:(NSString *)city withCallback:(void (^)(NSDictionary *weatherInfo))callback;

@end
