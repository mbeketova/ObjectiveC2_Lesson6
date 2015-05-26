//
//  DetailViewController.h
//  ObjectiveC2_Lesson6
//
//  Created by Admin on 23.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DetailViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIDatePicker *dataPicker;

@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) NSString * string_LabelTitle;
@property (nonatomic, strong) NSString * string_WeekDay;
@property (nonatomic, strong) NSString * string_Text;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) BOOL isArrayOld;


@end
