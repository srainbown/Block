//
//  ViewController.m
//  BLOCK
//
//  Created by 紫川秀 on 2017/6/20.
//  Copyright © 2017年 View. All rights reserved.
//

#import "ViewController.h"

//定义一种无返回值的Block类型
typedef void(^nameBlock)(NSString *);
//定义一种有返回值无参数列表的Block类型
typedef int(^numBlock)();
//定义一种有返回值有参数列表的Block类型
typedef int (^myBlock)(int,int);

@interface ViewController ()

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self test_one];
    [self test_two];
    [self test_three];
    [self test_four];
    
}

/*
 ************************************************************************
 
 Block是苹果在iOS4开始引入的对C语言的扩展，用来实现匿名函数的特性，Block是一种特殊的数据类型，其可以正常定义变量，作为参数，作为返回值，特殊地，Block还可以保存一段代码，在需要的时候调用，目前Block已经广泛的应用于iOS开发中，常用于GCD，动画，排序及各类调用；
 
 注：Block的声明与赋值只是保存了一段代码段，必须调用才能执行内部代码；
 
 Block变量的声明格式：返回值类型(^Block名字)(参数列表)；如：函数test_one所示；
 
 注：^被称为“脱字符”；
 
 Block变量的赋值：Block变量 = ^（参数列表）{函数体}；
 
 在实际使用Block的过程中，我们可能需要重复地声明多个，相同返回值，相同参数列表的Block变量，如果总是重复地编写一长串代码来声明变量会非常繁琐，所以我们可以使用typedef来定义Block类型；如：函数test_two所示;
 
 Block可以作为函数参数；如：函数test_three所示；
 
 ************************************************************************
 */


-(void)test_one{

    //声明一个无返回值，参数为2个int型的对象，叫做nimadan的Block；
    void (^nimadan)(int a, int b);
    //形参变量名可以省略，值保留变量类型即可；
    void (^nimei)(NSString *, NSString *);
    //注:Block变量的赋值格式可以是:Block变量 = ^返回值类型(参数列表){函数体};不过通常情况下都将返回值类型省略，因为编译器可以从存储代码块的变量中确定返回值的类型；
    
    nimadan = ^(int a ,int b){
        NSLog(@"%d",a + b);
    };
    
    nimei = ^(NSString *name_one, NSString *name_two){
        NSLog(@"%@ and %@",name_one,name_two);
    };

    //如果没有参数列表，在赋值时参数列表可以省略
    void (^ads)()= ^(){
        NSLog(@"233~~");
    };
    
    NSString *(^name)(NSString *) = ^(NSString *str_one){
        NSString *str_two = [NSString stringWithFormat:@"%@之紫川秀",str_one];
        return str_two;
    };
    
    //block调用
    nimadan(5,10);
    nimei(@"紫川秀",@"流风霜");
    ads();
    NSLog(@"%@",name(@"紫川三杰"));
}


-(void)test_two{
    //我们可以像OC中声明变量一样使用Block类型nameBlock来声明变量
    nameBlock name = ^(NSString *name){
        NSLog(@"%@",name);
    };
    name(@"紫川宁");
    
    numBlock number = ^(){
        return 110;
    };
    NSLog(@"%d",number());
}


-(void)test_three{
    int (^addBlock)(int,int) = ^(int x,int y){
        return x + y;
    };
    //以Block作为函数参数，把Block像对象一样传递
    [self useBlockForOC:addBlock];
    
    //已内联定义的Block作为函数参数
    [self useBlockForOC:^int(int x, int y) {
        return x * y;
    }];
    
    //声明并定义一个Block类型变量
    myBlock myBlock = ^(int x,int y){
        return x + y;
    };
    [self useTypedefBlock:myBlock];
    
    //已内联方式作为函数参数
    [self useTypedefBlock:^int(int x, int y) {
        return x * y;
    }];
    
}
-(void)useBlockForOC:(int (^)(int,int))aBlock{
    NSLog(@"result = %d",aBlock(100,200));
}
-(void)useTypedefBlock:(myBlock)block{
    NSLog(@"result = %d",block(200,300));
}


-(void)test_four{
    
    
    
}










@end
