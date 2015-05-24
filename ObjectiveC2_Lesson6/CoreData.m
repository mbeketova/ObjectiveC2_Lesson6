//
//  CoreData.m
//  ObjectiveC2_Lesson6
//
//  Created by Admin on 23.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "CoreData.h"
#import "AppDelegate.h"

@implementation CoreData

- (NSManagedObjectContext *) managedObjectContext {
    
    //с помощью селектора обращаемся в скрытый метод, чтобы работать с контекстом
    //NSManagedObjectContext - управляет значениями в БД
    
    NSManagedObjectContext * context = nil;
    
    id delegate = [[UIApplication sharedApplication]delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void) saveData: (NSString *)entety_Name Value: (NSString *)name For_Key: (NSString*)key {
    
    //запись в базу данных объекта по ключу
    NSManagedObject * newName = [NSEntityDescription insertNewObjectForEntityForName:entety_Name inManagedObjectContext:[self managedObjectContext]];
    
    [newName setValue:name forKey:key];
    
    NSError * error = nil;
    
    if (![[self managedObjectContext]save:&error]){
        //обработка ошибки
        NSLog(@"ERROR = %@", error);
    }
}

- (NSArray*) gateData: (NSString*)entety_Name Key: (NSString*)key {
    //Класс, который реализует доступ к БД:
    //NSFetchRequest описывает критерии поиска, используемые для получения данных из постоянного хранилища
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    NSFetchRequest * requestData = [[NSFetchRequest alloc]init];
    NSEntityDescription * entityData = [NSEntityDescription entityForName:entety_Name inManagedObjectContext:[self managedObjectContext]];
    [requestData setEntity:entityData];
    
     NSError * error = nil;
    NSArray * arrayData = [[self managedObjectContext] executeFetchRequest:requestData error:&error];
    
    for (NSManagedObject * obj in arrayData){
        NSString * value = [obj valueForKey:key];
        [array addObject:value];
    }
    
    return array;
}


- (void) save_NSData: (NSString*)entety_Name Value:(NSData*)dataValue Key:(NSString*)key {
    

    //запись в базу данных объекта по ключу
    NSManagedObject * newName = [NSEntityDescription insertNewObjectForEntityForName:entety_Name inManagedObjectContext:[self managedObjectContext]];
    
    [newName setValue:dataValue forKey:key];
    
    NSError * error = nil;
    
    if (![[self managedObjectContext]save:&error]){
        //обработка ошибки
        NSLog(@"ERROR = %@", error);
    }
}


- (NSData*) gate_NSData: (NSString*)entety_Name Key: (NSString*)key {
    //Класс, который реализует доступ к БД:
    //NSFetchRequest описывает критерии поиска, используемые для получения данных из постоянного хранилища
    
    NSData * data = [[NSData alloc]init];
    
    NSFetchRequest * requestData = [[NSFetchRequest alloc]init];
    NSEntityDescription * entityData = [NSEntityDescription entityForName:entety_Name inManagedObjectContext:[self managedObjectContext]];
    [requestData setEntity:entityData];
    
    NSError * error = nil;
    NSArray * arrayData = [[self managedObjectContext] executeFetchRequest:requestData error:&error];
    
    for (NSManagedObject * obj in arrayData){
        data = [obj valueForKey:key];
        
    }
    
    return data;
}




@end
