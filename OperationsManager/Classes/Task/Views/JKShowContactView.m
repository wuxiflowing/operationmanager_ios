//
//  JKShowContactView.m
//  OperationsManager
//
//  Created by xuziyuan on 2019/7/15.
//  Copyright © 2019 周家康. All rights reserved.
//

#import "JKShowContactView.h"
#define kZLPhotoBrowserBundle [NSBundle bundleForClass:[self class]]

#define ZQWindow [UIApplication sharedApplication].keyWindow
@interface JKShowContactView ()<UITableViewDataSource,UITableViewDelegate>
/**
 回调block
 */
@property (nonatomic, copy) ensureContactCallback ensureCotactBlock;

/**
 蒙板
 */
@property (nonatomic, weak) UIView *becloudView;
@end
@implementation JKShowContactView

+ (instancetype)showContactView
{
    return [[kZLPhotoBrowserBundle loadNibNamed:@"JKShowContactView" owner:self options:nil] lastObject];;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
}

- (void)show
{
    // 蒙版
    UIView *becloudView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    becloudView.backgroundColor = [UIColor blackColor];
    becloudView.layer.opacity = 0.3;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [becloudView addGestureRecognizer:tapGR];
    
    [ZQWindow addSubview:becloudView];
    self.becloudView = becloudView;
    
    
    
    // 输入框
    CGFloat height ;
    if (self.list.count >= 4) {
        height = 48*5;
    }else{
        height = 48*(self.list.count +1);
    }
    self.frame = CGRectMake(0, 0, becloudView.frame.size.width * 0.8, height);
    self.center = CGPointMake(becloudView.center.x, becloudView.frame.size.height * 0.4);
    [ZQWindow addSubview:self];
    
}
- (void)setList:(NSArray *)list{
    _list = list;
    
}

#pragma mark - 移除ZYInputAlertView
- (void)dismiss
{
    [self removeFromSuperview];
    [self.becloudView removeFromSuperview];
}

#pragma mark - 接收传过来的block

- (void)ensureCotactClickBlock:(ensureContactCallback)block{
    self.ensureCotactBlock = block;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // 定义唯一标识
    static NSString *CellIdentifier = @"Cell";
    // 通过唯一标识创建cell实例
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // 对cell 进行简单地数据配置
    UILabel *contactLb = [[UILabel alloc] init];
    contactLb.text = [self.list objectAtIndex:indexPath.row];
    contactLb.textColor = RGBHex(0x333333);
    contactLb.textAlignment = NSTextAlignmentCenter;
    contactLb.font = JKFont(14);
    [cell.contentView addSubview:contactLb];
    [contactLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.centerX.equalTo(cell.contentView);
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismiss];
    NSString *str = [self.list objectAtIndex:indexPath.row];
    if (self.ensureCotactBlock) {
        self.ensureCotactBlock(str);
    }
}



@end
