//
//  Cities+CoreDataProperties.m
//  
//
//  Created by Valerii Mykhailenko on 12/19/17.
//
//

#import "Cities+CoreDataProperties.h"

@implementation Cities (CoreDataProperties)

+ (NSFetchRequest<Cities *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Cities"];
}

@dynamic name;

@end
