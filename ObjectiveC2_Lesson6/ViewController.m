//
//  ViewController.m
//  ObjectiveC2_Lesson6
//
//  Created by Admin on 23.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "CoreData.h"
#import "CustumTableViewCell.h"

/*ДЗ - Сделать записную книжку с использованием Core Data. 
 Сделать несколько параметров (на выбор) но не менее трех. 
 Реализовать блокирование сохранения данных, если какое-то поле пустое с выводом Алерта, 
 относительно того, что осталось незаполненным.
 Текстовые поля должны быть скрыты, когда заходим в детали записи. 
 А когда создаем новую запись, то должны быть открыты.
 Дополнительно необходимо использовать изображения, хранить и считывать в формате NSData.*/

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray * array_Events;
- (IBAction)button_NewAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array_Events = [[NSMutableArray alloc]init];
    CoreData * core = [CoreData new];
    
    
    //запаковываем картинки в коллекцию
    NSData * imageSunday = UIImagePNGRepresentation([UIImage imageNamed:@"Sunday.jpg"]);
    NSData * imageMonday = UIImagePNGRepresentation([UIImage imageNamed:@"Monday.jpg"]);
    NSData * imageTuesday = UIImagePNGRepresentation([UIImage imageNamed:@"Tuesday.jpg"]);
    NSData * imageWednesday = UIImagePNGRepresentation([UIImage imageNamed:@"Wednesday.jpg"]);
    NSData * imageThursday = UIImagePNGRepresentation([UIImage imageNamed:@"Thursday.jpg"]);
    NSData * imageFriday = UIImagePNGRepresentation([UIImage imageNamed:@"Friday.jpg"]);
    NSData * imageSaturday = UIImagePNGRepresentation([UIImage imageNamed:@"Saturday.jpg"]);
 
    
    NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:
    imageSunday, @"Sunday",
    imageMonday, @"Monday",
    imageTuesday, @"Tuesday",
    imageWednesday, @"Wednesday",
    imageThursday, @"Thursday",
    imageFriday, @"Friday",
    imageSaturday, @"Saturday", nil];
    
    // и добавляем коллекцию в БД (ImagesDay):
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [core save_NSData:@"ImagesDay" Value:data Key:@"images"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//------------------------------------------------------------------------------------------------------------------


- (void) viewWillAppear:(BOOL)animated {
    //достаем из БД (Records) данные и записываем их в массив:
    
        CoreData * core = [CoreData new];
        NSData * data = [core gate_NSData:@"Records" Key:@"data"];
        self.array_Events = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [self reload_TableView];
 
}


//------------------------------------------------------------------------------------------------------------------

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array_Events.count;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * identifier = @"Cell";
    CustumTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.label_Data.text = [[self.array_Events objectAtIndex:indexPath.row]objectForKey:@"Day"];
    cell.label_Text.text = [[self.array_Events objectAtIndex:indexPath.row]objectForKey:@"Text"];
    
    return cell;
    
}

//------------------------------------------------------------------------------------------------------------------

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //данная процедура позволяет редактировать таблицу
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //этот метод будет срабатывать, если стиль редактирования: удалить
    if (editingStyle ==  UITableViewCellEditingStyleDelete) {
        UILocalNotification * notif = [self.array_Events objectAtIndex:indexPath.row];
        [self.array_Events removeObjectAtIndex:indexPath.row];
        [[UIApplication sharedApplication] cancelLocalNotification:notif];
        [self reload_TableView];

        CoreData * core = [CoreData new];
        //запаковываем данные обратно в БД (Records):
        NSData * dataNew = [NSKeyedArchiver archivedDataWithRootObject:self.array_Events];
        [core save_NSData:@"Records" Value:dataNew Key:@"data"];
    }
}

//------------------------------------------------------------------------------------------------------------------

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //код когда будем выбирать ячейку
    
    DetailViewController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    detail.string_LabelTitle = [[self.array_Events objectAtIndex:indexPath.row]objectForKey:@"Day"];
    detail.string_Text = [[self.array_Events objectAtIndex:indexPath.row]objectForKey:@"Text"];
    detail.string_WeekDay = [[self.array_Events objectAtIndex:indexPath.row]objectForKey:@"WeekDay"];

    
    [self.navigationController pushViewController:detail animated:YES];
    
}
//------------------------------------------------------------------------------------------------------------------

- (IBAction)button_NewAction:(id)sender {
    

    
    DetailViewController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    detail.isNew = YES;
    
    if (!self.array_Events.count ==0) {
        detail.isArrayOld = YES;
    }
    
    [self.navigationController pushViewController:detail animated:YES];

    
    
}
//------------------------------------------------------------------------------------------------------------------
//метод, который перезагружает таблицу:
- (void) reload_TableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];});
}

@end
