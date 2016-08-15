//
//  ViewController.m
//  IndexTabView
//
//  Created by langyue on 16/8/15.
//  Copyright © 2016年 langyue. All rights reserved.
//

#import "ViewController.h"


#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenWidth [UIScreen mainScreen].bounds.size.height
#define kScreenHeight [UIScreen mainScreen].bounds.size.width
#define pictureHeight 200


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    NSDictionary * dataDictionary;

    NSArray * listGroupNameArray;

    UITableView * tabView;

}

@property(nonatomic,strong)UIView* header;
@property(nonatomic,strong)UIImageView* pictureImageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.navigationItem.title = @"索引+下拉放大图片";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self createTabView];
    [self getData];





}

-(void)getData{

    //得到数据
    NSBundle * bundle = [NSBundle mainBundle];
    NSString * plistPathStr = [bundle pathForResource:@"team_dictionary" ofType:@"plist"];


    dataDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPathStr];
    NSLog(@"取出的plist文件字典: %@",dataDictionary);
    listGroupNameArray = [[dataDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"排序后的数组：%@",listGroupNameArray);

    [tabView reloadData];

}

-(void)createTabView{

    //创建UI界面
    tabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];[self.view addSubview:tabView];tabView.delegate = self;tabView.dataSource = self;

    tabView.backgroundColor = [UIColor cyanColor];
    tabView.translatesAutoresizingMaskIntoConstraints = NO;


    NSLayoutConstraint * constraint0 = [NSLayoutConstraint constraintWithItem:tabView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:20];
    NSLayoutConstraint * constraint1 = [NSLayoutConstraint constraintWithItem:tabView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint * constraint2 = [NSLayoutConstraint constraintWithItem:tabView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint * constraint3 = [NSLayoutConstraint constraintWithItem:tabView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];



    NSArray * consArr = @[constraint0,constraint1,constraint2,constraint3];

    [self.view addConstraints:consArr];



    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, pictureHeight)];
    _pictureImageView = [[UIImageView alloc] initWithFrame:_header.bounds];
    _pictureImageView.image = [UIImage imageNamed:@"picture9.jpg"];


    _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    _pictureImageView.clipsToBounds = YES;
    [_header addSubview:_pictureImageView];

    tabView.tableHeaderView = _header;
    [self.view addSubview:tabView];


}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return listGroupNameArray.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSString * groupName = listGroupNameArray[section];
    NSArray * listTeamsArray = dataDictionary[groupName];
    return [listTeamsArray count];

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"CellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    //按照节索引 从小组名数组中 获得组名
    NSString * groupName = [listGroupNameArray objectAtIndex:indexPath.section];
    // 将组名作为key,从字典中取出球队数组集合
    NSArray * listTeamsArray = [dataDictionary objectForKey:groupName];

    cell.textLabel.text = [listTeamsArray objectAtIndex:indexPath.row];

    return cell;

}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return listGroupNameArray[section];
}

-(nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray * listTitlesArray = [[NSMutableArray alloc] initWithCapacity:[listGroupNameArray count]];
    for (NSString * item in listGroupNameArray) {
        NSString * title = [item substringToIndex:1];
        [listTitlesArray addObject:title];
    }
    return listTitlesArray;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{


    CGFloat offset_y = scrollView.contentOffset.y;

    if (offset_y < 0) {

        CGFloat totalOffset = pictureHeight - offset_y;
        CGFloat scale = totalOffset / pictureHeight;
        CGFloat width = kScreenWidth;
        _pictureImageView.frame = CGRectMake(-(width * scale - width)/2, offset_y, width * scale, totalOffset);

    }




}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
