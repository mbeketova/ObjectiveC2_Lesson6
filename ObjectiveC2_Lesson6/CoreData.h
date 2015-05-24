//
//  CoreData.h
//  ObjectiveC2_Lesson6
//
//  Created by Admin on 23.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreData : NSObject

- (void) saveData: (NSString *)entety_Name Value: (NSString *)name For_Key: (NSString*)key;
- (NSArray*) gateData: (NSString*)entety_Name Key: (NSString*)key;
- (void) save_NSData: (NSString*)entety_Name Value:(NSData*)dataValue Key:(NSString*)key;
- (NSData*) gate_NSData: (NSString*)entety_Name Key: (NSString*)key;

@end
