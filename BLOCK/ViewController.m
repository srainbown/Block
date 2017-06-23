//
//  ViewController.m
//  BLOCK
//
//  Created by 紫川秀 on 2017/6/20.
//  Copyright © 2017年 View. All rights reserved.
//

#import "ViewController.h"
#import "Preson.h"

typedef void(^nameBlock)(NSString *);//定义一种无返回值的Block类型
typedef int(^numBlock)();//定义一种有返回值无参数列表的Block类型
typedef int (^myBlock)(int,int);//定义一种有返回值有参数列表的Block类型

@interface ViewController ()

@property (nonatomic, strong) Preson *preson;
@property (nonatomic, copy) NSString *string;

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
 ********************************************************************************************
 
 Block是苹果在iOS4开始引入的对C语言的扩展，用来实现匿名函数的特性，Block是一种特殊的数据类型，其可以正常定义变量，作为参数，作为返回值，特殊地，Block还可以保存一段代码，在需要的时候调用，目前Block已经广泛的应用于iOS开发中，常用于GCD，动画，排序及各类调用；
 
 注：Block的声明与赋值只是保存了一段代码段，必须调用才能执行内部代码；
 
 *****   Block的写法  ****************************************************************
 
 Block变量的声明格式：返回值类型(^Block名字)(参数列表)；
 注：^被称为“脱字符”；
 Block变量的赋值：Block变量 = ^（参数列表）{函数体}；
 如：函数test_one所示；

 在实际使用Block的过程中，我们可能需要重复地声明多个，相同返回值，相同参数列表的Block变量，如果总是重复地编写一长串代码来声明变量会非常繁琐，所以我们可以使用typedef来定义Block类型；
 如：函数test_two所示;
 
 *****   Block作为函数参数  ************************************************************
 
 Block可以作为函数参数；
 如：函数test_three所示；

 *****   Block访问变量  ****************************************************************
 
 在Block中可以访问局部变量；
 在局部变量前添加__block，这样在定义Block时会将指向局部变量的地址给block，而不添加__block只是将局部变量的值给了Block。如：函数test_four所示；
 
 在Block中可以访问全局变量；
 Block可以不用添加__block，直接修改全局变量的值；
 如：函数test_five所示；

 在Block中可以访问静态变量；
 在定义Block时就将静态变量的地址给了Block。
 BlocK可以不用添加__block，直接修改全局变量的值；
 
 静态全局变量和全局变量一样，也是可以在任何时候以任何状态调用的，它们的访问是不经过Block的；
 如：函数test_six所示；


*****   结论  **************************************************************************
 
 结论：Block实质上是OC对闭包的对象实现，简单来说Block就是对象。
      从表层分析，Block是一个类型。
      从深层分析，Block是OC对象，因为它的结构体中含有isa指针。
      __block的作用：block说明符用于指定将变量值设置到哪个存储区域中，也就是说，当自动变量加上__block说明符之后，会改变这个自动变量的存储区域。__block可以修饰任意类型的自动变量；
 
*****   isa指针   **********************************************************************
 
 Block一共分为3中：这里指的是isa的指针指向：
    Block的类                      存储域             拷贝效果
    _NSConcreteStackBlock           栈             从栈拷贝到堆
    _NSConcreteGlobalBlock     程序的数据区域         什么也不做
    _NSConcreteMallocBlock          堆             引用计数增加
 全局Block：_NSConcreteGlobalBlock
    因为全局Block的结构体实例设置在程序的数据存储区，所以可以在程序的任意位置通过指针来访问，它的产生条件：
        1.记述全局变量的地方有block语法时；
        2.block不截获的自动变量时；
    以上两个条件只要满足一个就可以产生全局Block；
 栈Block：_NSConcreteStackBlock
    在生成Block以后，如果这个Block不是全局Block，那么它就是为_NSConcreteStackBlock对象，但是如果其所属的变量作用域名结束，该Block就被废弃。在栈上的__block变量也是如此。
    但是，如果Block变量和__block变量复制到了堆上以后，则不再会受到变量作用域结束的影响，因为它变成了堆Block；
 堆Block：_NSConcreteMallocBlock；
    将栈Block复制到堆以后，Block结构体的isa成员变量变成了_NSConcreteMallocBlock；
 在大多数情况下，编译器会进行判断，自动将Block从栈上复制到堆：
    1.Block作为函数值返回的时候
    2.部分情况下向方法或函数中传递block的时候：
        1）Cocoa框架的方法而且方法名中含有usingBlock等时；
        2）Grand Central Dispatch 的API；
    除了这两种情况，基本都需要我们手动复制Block；
 那么__block变量在Block执行copy操作后会发生什么呢？
    1.任何一个block被复制到堆上时，__block变量也会一并从栈复制到堆上，并被该Block持有；
    2.如果接着有其他Block被复制到堆上的话，被复制的Block会持有block变量，并增加block的引用计数，反过来如果Block被废弃，它所持有的__block也就被释放(不在有block引用它)；
 
*****   Block的循环引用  ****************************************************************
 
 如果在Block内部使用__strong修饰符的对象类型的自动变量，那么当Block从栈复制到堆的时候，该对象就会被Block所持有；
 所以如果这个对象还同时持有Block的话，就容易发生循环引用；
 
 常见误区：
    1.所有Block都会造成循环引用：在Block中，并不是所有的Block都会造成循环引用，比如UIView动画Block，Masonry添加约束Block，AFN网络请求回调Block等。
        UIView动画Block不会造成循环引用是因为这是类方法，不可能强引用一个类，所以不会造成循环引用。
        Masonry约束Block不会造成循环引用是因为内部使用的变量是局部变量，Block并没有持有self，在超出它的作用域后就会被销毁。
        AFN请求回调不会造成循环引用是因为在内部做了处理。Block先是被AFURLSessionManagerTaskDelegate对象持有。而AFURLSessionManagerTaskDelegate对象被mutableTaskDelegatesKeyedByTaskIdentifier字典持有，在Block执行完成后，mutableTaskDelegatesKeyedByTaskIdentifier字典会移除AFURLSessionManagerTaskDelegate对象，这样对象就被释放了，所所以不会造成循环引用。
    2.Block中只有self会造成循环引用
        在block中并不只是self会造成循环引用，用下划线调用属性（如_name）也会出现循环引用，效果和使用self是一样的。
    3.通过__weak __typeof(self) weakSelf = self;可以解决所有Block造成的循环引用
        大部分情况下，这样使用时可以解决Block循环引用，但是有些情况下这样使用会造成一些问题。比如在Block中延迟执行一些代码，在还没有执行的时候，控制器被销毁了，这样控制器中的对象也会被释放，__weak对象就会变成null,所以会输出null；如：函数
    4.用self调用带有block的方法会引起循环引用
        并不是所有通过self调用带有block的方法会引起循环引用，需要看方法内部是否持有self。
 如：test_seven所示；
 
 
 
 
 
**************************************************************************************************
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

#pragma mark -- seven
-(void)test_seven{

    _preson = [[Preson alloc]init];
    _preson.name = @"帝林";
    __weak __typeof(self) weakSelf = self;
    [_preson PresonBlock:^{
        //在延迟执行期间，控制器如果被释放，那么打印出来的就是null，如果执行其他操作，也可能Crash.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@",weakSelf.preson.name);
        });
    }];
    
    //并不是所有通过self调用带有block的方法会引起循环引用，需要看方法内部是否持有self。
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@",self.string);
    }];
    
}




@end
