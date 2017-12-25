//
//  Cities+CoreDataProperties.h
//  
//
//  Created by Valerii Mykhailenko on 12/19/17.
//
//

#import "Cities+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Cities (CoreDataProperties)

+ (NSFetchRequest<Cities *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
