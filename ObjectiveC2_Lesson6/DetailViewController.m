//
//  DetailViewController.m
//  ObjectiveC2_Lesson6
//
//  Created by Admin on 23.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "DetailViewController.h"
#import "CoreData.h"
#import "ViewController.h"


@interface DetailViewController ()


@property (weak, nonatomic) IBOutlet UITextField *textField;


@property (weak, nonatomic) IBOutlet UIView *view_Title;
@property (weak, nonatomic) IBOutlet UILabel *label_Title;
@property (weak, nonatomic) IBOutlet UIView *view_TextView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSDate * date_New_Event;

@property (weak, nonatomic) IBOutlet UILabel *label_WeekDay;

@end

@implementation DetailViewController {
    BOOL isPlaceHolderTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    isPlaceHolderTextField = NO;
    
    
    
    if (!self.isNew){
        
        //если открываем детали, то на экране видим: Дату, день недели, текст записи и картинку, соответствующую дню недели:
        
        
        self.textView.text = self.string_Text;
        self.label_Title.text = self.string_LabelTitle;
        self.label_WeekDay.text = self.string_WeekDay;
       
        //распаковываем БД и берем нужную картинку по ключу
        CoreData * core = [CoreData new];
        NSData * dataImage = [core gate_NSData:@"ImagesDay" Key:@"images"];
        NSDictionary*dict = [NSKeyedUnarchiver unarchiveObjectWithData:dataImage];
        self.imageView.image = [UIImage imageWithData:[dict objectForKey:self.string_WeekDay]];
        
        //запаковываем БД обратно
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [core save_NSData:@"ImagesDay" Value:data Key:@"images"];


        
        
        self.textField.alpha = 0;
        self.dataPicker.alpha = 0;
        self.label_Title.alpha = 1;
        self.imageView.alpha = 1;
        self.view_TextView.alpha = 1;
        self.label_WeekDay.alpha = 1;
        
        
        
        
    }
    
    else {
        
        //если открываем по кнопке New, то на экране видим: текстфилд, барабан с часами (не двигается, показывает текущую дату и время)
        self.view_TextView.alpha = 0;
        
        self.textField.alpha = 1;
       
        self.imageView.alpha = 0;
        self.label_Title.alpha = 0;
        self.view_Title.alpha = 0;
        self.label_Title.text = @"";
        self.label_WeekDay.alpha = 0;

        
        self.dataPicker.minimumDate = [NSDate date]; //устанавливаем дату = текущей дате
        self.dataPicker.alpha = 1;
        self.dataPicker.userInteractionEnabled = NO; //так же блокируем барабан с датой
        
        //делаем текстфилд немного приличным на вид:
        self.textField.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9].CGColor;
        self.textField.layer.borderColor = [UIColor blackColor].CGColor;
        self.textField.layer.borderWidth = 1.0;
        self.textField.layer.cornerRadius = 5.0;
    }
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
//  достаем данные из БД
    CoreData * core = [CoreData new];
    NSMutableArray * arrayNewRecord = [[NSMutableArray alloc]init];
    
    
    if (!self.arrayOld.count == 0) {
        NSData * data = [core gate_NSData:@"Records" Key:@"data"];
        arrayNewRecord = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
  
    //записываем в строку все, что будет набрано в текстфилде:
    NSString * stringTitle = self.textField.text;
    
    if (stringTitle.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ВНИМАНИЕ!" message:@"Напишите хоть что-нибудь!" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"ОК", nil];
        [alert show];
    }
    
    else {
 
    //переформатируем дату:
    self.date_New_Event = self.dataPicker.minimumDate;
    NSDateFormatter * format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"dd.MMMM.yyyy HH:mm";
    NSString * string_Date = [format stringFromDate:self.dataPicker.minimumDate];
    
    //переформатируем день недели:
    NSArray *days = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:self.date_New_Event];
    NSInteger weekday = [weekdayComponents weekday];
    NSString* string_WeekDay = [days objectAtIndex:weekday];
    
    
    //заполняем коллекцию:
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:stringTitle forKey:@"Text"];
    [dict setObject:string_Date forKey:@"Day"];
    [dict setObject:string_WeekDay forKey:@"WeekDay"];
   
    
    //заполняем массив:
    [arrayNewRecord addObject:dict];
  
    
    //запаковываем массив в БД
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:arrayNewRecord];
    [core save_NSData:@"Records" Value:data Key:@"data"];
     
    }
    
    return YES;
}



@end
