//
//  NetworkManager.h
//  Weather
//
//  Created by Valerii Mykhailenko on 12/12/17.
//  Copyright © 2017 Mykhailenko Valerii. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetworkCompletionBlock)(NSDictionary *weatherInfo);

@interface NetworkManager : NSObject

- (void)getWeatherIn:(NSString *)city withRequestCompletion:(NetworkCompletionBlock)completion;

- (void)getWeatherByLat:(double)lat andLon:(double)lon withRequestCompletion:(NetworkCompletionBlock)completion;

@end
