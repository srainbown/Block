//
//  ViewController.m
//  BLOCK
//
//  Created by 紫川秀 on 2017/6/20.
//  Copyright © 2017年 View. All rights reserved.
//

#import "ViewController.h"

typedef void(^nameBlock)(NSString *);//定义一种无返回值的Block类型
typedef int(^numBlock)();//定义一种有返回值无参数列表的Block类型
typedef int (^myBlock)(int,int);//定义一种有返回值有参数列表的Block类型

@interface ViewController ()
@end
@implementation ViewController{
    int globalVariable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    globalVariable = 100;
    
    [self test_one];
    [self test_two];
    [self test_three];
    [self test_four];
    [self test_five];
    [self test_six];
    
    
}

/*
 ************************************************************************
 
 Block是苹果在iOS4开始引入的对C语言的扩展，用来实现匿名函数的特性，Block是一种特殊的数据类型，其可以正常定义变量，作为参数，作为返回值，特殊地，Block还可以保存一段代码，在需要的时候调用，目前Block已经广泛的应用于iOS开发中，常用于GCD，动画，排序及各类调用；
 
 注：Block的声明与赋值只是保存了一段代码段，必须调用才能执行内部代码；
 
 *
 **
 ***
 Block变量的声明格式：返回值类型(^Block名字)(参数列表)；
 注：^被称为“脱字符”；
 Block变量的赋值：Block变量 = ^（参数列表）{函数体}；
 如：函数test_one所示；
 ***
 **
 *
 
 *
 **
 ***
 在实际使用Block的过程中，我们可能需要重复地声明多个，相同返回值，相同参数列表的Block变量，如果总是重复地编写一长串代码来声明变量会非常繁琐，所以我们可以使用typedef来定义Block类型；
 如：函数test_two所示;
 ***
 **
 *
 
 *
 **
 ***
 Block可以作为函数参数；
 如：函数test_three所示；
 ***
 **
 *
 
 *
 **
 ***
 在Block中可以访问局部变量；
 在局部变量前添加__block，这样在定义Block时会将指向局部变量的地址给block，而不添加__block只是将局部变量的值给了Block。如：函数test_four所示；
 在Block中可以访问全局变量；
 Block可以不用添加__block，直接修改全局变量的值；
 如：函数test_five所示；
 ***
 **
 *
 
 *
 **
 ***
 在Block中可以访问静态变量；
 在定义Block时就将静态变量的地址给了Block。
 BlocK可以不用添加__block，直接修改全局变量的值；
 静态全局变量也是可以在任何时候以任何状态调用的；
 如：函数test_six所示；
 ***
 **
 *
 
 结论：Block实质上是OC对闭包的对象实现，简单来说Block就是对象。
      从表层分析，Block是一个类型。
      从深层分析，Block是OC对象，因为它的结构体中含有isa指针。
 
 
 ************************************************************************
 */


#pragma mark -- test_one
-(void)test_one{

//    声明一个无返回值，参数为2个int型的对象，叫做nimadan的Block；
    void (^nimadan)(int a, int b);
//    形参变量名可以省略，值保留变量类型即可；
    void (^nimei)(NSString *, NSString *);
//    注:Block变量的赋值格式可以是:Block变量 = ^返回值类型(参数列表){函数体};不过通常情况下都将返回值类型省略，因为编译器可以从存储代码块的变量中确定返回值的类型；
    
    nimadan = ^(int a ,int b){
        NSLog(@"%d",a + b);
    };
    
    nimei = ^(NSString *name_one, NSString *name_two){
        NSLog(@"%@ and %@",name_one,name_two);
    };

//    如果没有参数列表，在赋值时参数列表可以省略；
    void (^ads)()= ^{
        NSLog(@"233~~");
    };
    
    NSString *(^name)(NSString *) = ^(NSString *str_one){
        NSString *str_two = [NSString stringWithFormat:@"%@之紫川秀",str_one];
        return str_two;
    };
    
//    block调用；
    nimadan(5,10);
    nimei(@"紫川秀",@"流风霜");
    ads();
    NSLog(@"%@",name(@"紫川三杰"));
}


#pragma mark -- test_two
-(void)test_two{
//    我们可以像OC中声明变量一样使用Block类型nameBlock来声明变量；
    nameBlock name = ^(NSString *name){
        NSLog(@"%@",name);
    };
    name(@"紫川宁");
    
    numBlock number = ^{
        return 110;
    };
    NSLog(@"%d",number());
}


#pragma mark -- test_three
-(void)test_three{
    int (^addBlock)(int,int) = ^(int x,int y){
        return x + y;
    };
//    以Block作为函数参数，把Block像对象一样传递；
    [self useBlockForOC:addBlock];
    
//    已内联定义的Block作为函数参数；
    [self useBlockForOC:^int(int x, int y) {
        return x * y;
    }];
    
//    声明并定义一个Block类型变量；
    myBlock myBlock = ^(int x,int y){
        return x + y;
    };
    [self useTypedefBlock:myBlock];
    
//    已内联方式作为函数参数；
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


#pragma mark -- test_four
-(void)test_four{
//    声明局部变量global；
    int global = 100;
    void(^myGlobal)() = ^{
        NSLog(@"global == %d",global);
    };
    myGlobal();
    
    int haha = 100;
    void (^hahaBlock)() = ^{
        NSLog(@"haha == %d",haha);
    };
    haha = 110;
//    在声明Block之后，调用Block之前对局部变量进行修改，在调用时局部变量的值是修改之前的旧值；
    hahaBlock();
    
    //在Block中部可以直接修改局部变量；
    int heihei = 100;
    void (^heiheiBlock)() = ^{
//        heihei = 110;//会报错；
        NSLog(@"heihei == %d",heihei);
    };
    heiheiBlock();
    /*
     注:原理分析，通过clang命令将OC转成C++代码来查看一下Block底层实现，clang命令使用方式为终端使用cd定位到main.m文件所在文件夹，然后利用clang-rewrite-objc.main.m将OC转为C++，成功后在main.m同目录下会生成一个main.cpp文件；
     我们发现Block变量实际上就是一个指向结构体的指针，而结构体的第三个元素就是局部变量heihei的值；
     由此可知，在Block定义时便是将局部变量的值传给Block变量所指的机构体，因此在调用Block之前对局部变量进行修改并不会影响Block内部的值，同时内部的值也是不可修改的；
     */
    
    /*
     Block内访问 __block修饰的局部变量；
     在局部变量前使用下划线block修饰后，在声明Block之后，调用Block之前对局部变量进行修改，在调用Block时局部变量值是修改之后的新值；
     */
    __block int a = 100;
    void (^aBlock)() = ^{
        NSLog(@"a == %d",a);
    };
    a = 110;
    aBlock();
//    在局部变量前使用下划线block修饰，在Block中可以直接修改局部变量的值；
    __block int b = 100;
    void (^bBlock)() = ^{
        b = 119;
        NSLog(@"b == %d",b);
    };
    bBlock();
    NSLog(@"b == %d",b);
    /*
     原理分析:在局部变量前使用__block修饰，在Block定义时便是将局部变量的指针传给Block变量所指向的结构体，因此在调用Block之前对局部变量进行修改会影响到Block内部的值，同时内部的值也是可以修改的；
     注意：这里的修改是指整个变量的赋值操作，变更该对象的操作是允许的，比如在不加上__block修饰符的情况下，给在变量Block内部的可变数组添加对象的操作是可以的；
     */
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSLog(@"%@",array);
    void (^printInt)() = ^{
        [array addObject:@1];
    };
    
    printInt();
    NSLog(@"%@",array);
}


#pragma mark -- test_five
-(void)test_five{
//    在声明Block之后，调用Block之前对局部变量进行修改，在调用Block时全局变量的值是修改之后的新值；
    void (^abcBlock)() = ^{
        NSLog(@"globalVariable == %d",globalVariable);
    };
    globalVariable = 112;
    abcBlock();
    
//    在Block中可以直接修改全局变量；
    void (^hahaBlock)() = ^{
        globalVariable = 115;
        NSLog(@"globalVariable == %d",globalVariable);
    };
    hahaBlock();
    /*
     原理分析：全局变量所占的内存只有一份，供所有函数共同调用，在Block定义时并未将全局变量的值或者指针传给Block变量所指向的结构体，因此在调用Block之前对局部变量进行修改会影响Block内部的值，同时内部的值也是可以修改的；
     */
}

#pragma mark -- test_six
-(void)test_six{
//    在声明Block之后，调用Block之前对静态变量进行修改，在调用Block时静态变量的值是修改之后的新值；
    static int global = 100;
    void (^globalBlock)() = ^{
        NSLog(@"global == %d",global);
    };
    global = 1234;
    globalBlock();
//    在Block中可以直接修改静态变量的值；
    static int num = 100;
    void(^numBlock)() = ^{
        num = 233;
        NSLog(@"num == %d",num);
    };
    numBlock();
    /*
     原理分析：在Block定义时便是将静态变量的指针传给Block变量所指向的结构体，因此在调用Block之前对静态变量进行修改会影响Block内部的值，同时内部的值也是可以修改的；
     */
}








@end
