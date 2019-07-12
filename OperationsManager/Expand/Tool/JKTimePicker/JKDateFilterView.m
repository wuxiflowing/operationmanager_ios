//
//  JKDateFilterView.m
//  ChaZX
//
//  Created by    on 2018/8/23.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKDateFilterView.h"
#import "UIView+JKDateFilterView.h"
#import "JKFactoryManager.h"

#define WIDTHFC  [UIScreen mainScreen].bounds.size.width
#define TAGBUTTON   1100

@implementation JKButtonDataModel

@end

@interface  JKDateFilterView()
{
    NSArray<JKButtonDataModel *> * _qsButtonDateArray;
    NSInteger _qsButtonCount;
}

@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, strong) NSMutableArray<UIButton *> * buttonTitleArrM;
@property (nonatomic, strong) NSMutableArray<UIButton *> *qsButtonArray;
@property (nonatomic, strong) UIScrollView * titleScrollView;
@property (nonatomic, assign) BOOL needQuickSelectionModule;

@end

@implementation JKDateFilterView

- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)buttonTitles quickSelected:(BOOL)needQuickSelectionModule startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    CGRect rect = CGRectMake(0, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 200);
    if(self = [super initWithFrame:rect]) {
        self.backgroundColor = [UIColor whiteColor];
        self.buttonTitleArrM = [NSMutableArray array];
        _startDate = startDate;
        _endDate = endDate;
        self.needQuickSelectionModule = needQuickSelectionModule;
        self.buttonTitles = buttonTitles;
        _qsButtonCount = 4;
        [self layoutDateSubviews];
        [self layoutButtons];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)buttonTitles quickSelected:(BOOL)needQuickSelectionModule {
    return [self initWithFrame:frame buttonTitles:buttonTitles quickSelected:needQuickSelectionModule startDate:nil endDate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)buttonTitles {
    return [self initWithFrame:frame buttonTitles:buttonTitles quickSelected:NO startDate:nil endDate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame buttonTitles:@[@"重置",@"完成"] quickSelected:NO startDate:nil endDate:nil];
}

- (void)cleanDate {
    [_dateView initStatus:nil];
}

- (void)layoutDateSubviews {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, (_needQuickSelectionModule? 200:200))];
    contentView.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    [self addSubview:contentView];
    [contentView addSubview:self.titleScrollView];
    
    if (_titleScrollView.width!=0) {
//        [self quickSelectedArray:nil];
        [self setQuickSelectedFrame];
    }
    
    _dateView = [[JKCustomDateView alloc] initWithFrame:CGRectMake(0, 40, self.width, 200) minDate:_startDate maxDate:_endDate];
    
    [self addSubview:_dateView];
    __weak __typeof(self) weakSelf = self;
    _dateView.block = ^ (JKCustomDateView *bView,JKDate *leftDate,JKDate *rightDate){
        for (UIButton * button in weakSelf.qsButtonArray) {
            if (button.selected == YES) {
                [weakSelf setButton:button selected:NO];
            }
        }
        [weakSelf checkCanGoOn];
    };
}

//- (void)quickSelectedArray:(NSArray *)dataArray
//{
//    if (!_needQuickSelectionModule) {
//        return;
//    }
//    if (_qsButtonArray) {
//        for (UIButton * button in _qsButtonArray) {
//            [button removeFromSuperview];
//        }
//        [_qsButtonArray removeAllObjects];
//    }
//    _qsButtonArray = [[NSMutableArray alloc] init];
//
//    if (!dataArray) {
//        NSMutableArray * array = [[NSMutableArray alloc] init];
//        for (NSInteger i = 0 ; i < 4 ; i++) {
//            JKButtonDataModel * buttonModel = [[JKButtonDataModel alloc] init];
//            buttonModel.selectedColor =  [UIColor blueColor];
//            buttonModel.normalColor = [UIColor darkGrayColor];
//            switch (i) {
//                case 0:
//                {
//                    buttonModel.title = @"昨天";
//                    NSDictionary * dic = [JKFactoryManager dayCompareTodayOffset:-1];
//                    buttonModel.startTime = dic[@"start_date"];
//                    buttonModel.endTime = dic[@"end_date"];
//                }
//                    break;
//                case 1:
//                {
//                    buttonModel.title = @"今天";
//                    NSDictionary * dic = [JKFactoryManager dayCompareTodayOffset:0];
//                    buttonModel.startTime = dic[@"start_date"];
//                    buttonModel.endTime = dic[@"end_date"];
//                }
//                    break;
//                case 2:
//                {
//                    buttonModel.title = @"本周";
//                    NSDictionary * dic = [JKFactoryManager thisWeek];
//                    buttonModel.startTime = dic[@"start_date"];
//                    buttonModel.endTime = dic[@"end_date"];
//                }
//                    break;
//                case 3:
//                {
//                    buttonModel.title = @"本月";
//                    NSDictionary * dic = [JKFactoryManager thisMonth];
//                    buttonModel.startTime = dic[@"start_date"];
//                    buttonModel.endTime = dic[@"end_date"];
//                }
//                    break;
//                default:
//                    break;
//            }
//            [array addObject:buttonModel];
//
//        }
//        dataArray = [NSArray arrayWithArray:array];
//    }
//    _qsButtonDateArray = [NSArray arrayWithArray:dataArray];
//    for (int i = 0 ; i < dataArray.count; i++) {
//        JKButtonDataModel * buttonModel = dataArray[i];
//        UIButton * button = [self quickSelectedButtonTitle:buttonModel.title selectedColor:buttonModel.selectedColor defaultColor:(UIColor*)buttonModel.normalColor startTime:buttonModel.startTime endTime:buttonModel.endTime tag:20000+i];
//        [_titleScrollView addSubview:button];
//        [_qsButtonArray addObject:button];
//    }
//
//    UIButton * button = (UIButton*)[_titleScrollView viewWithTag:20001];
//    [self quickSelectedButtonClick:button];
//
//}


- (UIButton * )quickSelectedButtonTitle:(NSString *)title selectedColor:(UIColor *)selectedColor defaultColor:(UIColor*)defaultColor startTime:(NSString * )startTime endTime:(NSString *)endtime tag:(NSInteger)tag {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 14;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [defaultColor CGColor];
    button.tag = tag;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    [button setTitleColor:defaultColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(quickSelectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    return button;
}


- (void)setButton:(UIButton*)button selected:(BOOL)selected {
    
    NSInteger index = [_qsButtonArray indexOfObject:button];
    if (_qsButtonDateArray.count>index) {
        JKButtonDataModel * model = [_qsButtonDateArray objectAtIndex:index];
        button.selected = selected;
        if (selected) {
            button.layer.borderColor = [model.selectedColor CGColor];
        }else{
            button.layer.borderColor = [model.normalColor CGColor];
        }
    }
}

- (void)quickSelectedButtonClick:(UIButton*)button {
    for (UIButton * btn in _qsButtonArray) {
        [self setButton:btn selected:NO];
    }
    [self setButton:button selected:YES];
    NSInteger tag = button.tag;
    JKButtonDataModel * model = _qsButtonDateArray[tag-20000];
    [_dateView initStatus:[NSDictionary dictionaryWithObjectsAndKeys:model.startTime,@"start_date",model.endTime,@"end_date", nil]];
}

- (void)setQuickSelectedFrame {
    NSInteger blankCount = _qsButtonCount-1;
    CGFloat left = (WIDTHFC-_qsButtonCount*57-18*blankCount)/2;
    for (UIButton * button in _qsButtonArray) {
        button.frame = CGRectMake(left, 6, 57, 28);
        left+=75;
    }
}

- (void)layoutButtons {
    NSArray *array = _buttonTitles;
    for (int x = 0; x < array.count; x ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat  width = (self.width - 30) / array.count;
        button.frame = CGRectMake(15 + width * x, 0, width, 40);
        [button setTitle:array[x] forState:UIControlStateNormal];
        UIColor * titleColor;
        if (x==0) {
            titleColor =  kLightGrayColor;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }else{
            titleColor = kThemeColor;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
        button.titleLabel.font = JKFont(16);
        button.tag = TAGBUTTON + x;
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClickDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonTitleArrM addObject:button];
        [self addSubview:button];
    }
}

- (void)btnClickDate:(UIButton *)button {
    
    if (_buttonTitles.count > 1) {
        if (button.tag == TAGBUTTON) {
            [_dateView initStatus:nil];
        }else {
            if (self.finishBlock) {
                BOOL canGoOn = [self checkCanGoOn];
                if (!canGoOn) {
                    return;
                }
                self.finishBlock(self,[_dateView leftDateString],[_dateView rightDateString],[self getTitleStringWithStartTime:[_dateView leftDateString] endTime:[_dateView rightDateString]]);
            }
        }
    } else {
        
        if (self.finishBlock) {
            self.finishBlock(self,[_dateView leftDateString],[_dateView rightDateString],[self getTitleStringWithStartTime:[_dateView leftDateString] endTime:[_dateView rightDateString]]);
        }
        
    }
}

- (NSString*)getTitleStringWithStartTime:(NSString*)startTime endTime:(NSString *)endTime {
    NSString * title = nil;
    
    if(!self.needQuickSelectionModule){
        return [NSString stringWithFormat:@"%@至%@",startTime,endTime];
    }
    for (UIButton * button in _qsButtonArray) {
        if (button.selected == YES) {
            return button.titleLabel.text;
        }
    }
    NSDictionary * today = [JKFactoryManager dayCompareTodayOffset:0];
    NSDictionary * yesterday = [JKFactoryManager dayCompareTodayOffset:-1];
    
    if ([endTime isEqualToString:today[@"end_date"]]) {
        NSDictionary * thieM = [JKFactoryManager thisMonth];
        NSDictionary * thisWeek = [JKFactoryManager thisWeek];
        if ([startTime isEqualToString:thieM[@"start_date"]]) {
            title = @"本月";
        }else if ([startTime isEqualToString:thisWeek[@"start_date"]]) {
            title = @"本周";
        }else if ([startTime isEqualToString:today[@"start_date"]]) {
            title = @"今天";
        }else{
            title = [NSString stringWithFormat:@"%@至%@",startTime,endTime];
        }
    }else if([startTime isEqualToString:yesterday[@"start_date"]]&&[endTime isEqualToString:yesterday[@"end_date"]]){
        title = @"昨天";
    }else{
        title = [NSString stringWithFormat:@"%@至%@",startTime,endTime];
    }
    for (UIButton * button in _qsButtonArray) {
        if ([title isEqualToString:button.titleLabel.text]) {
            [self setButton:button selected:YES];
        }
    }
    return title;
}

- (BOOL)checkCanGoOn {
    JKDate *leftDate = [_dateView leftDate];
    JKDate *rightDate = [_dateView rightDate];
    
    if ([JKFactoryManager timeIntervalWithString:[_dateView leftDateString]] > [JKFactoryManager timeIntervalWithString:[_dateView rightDateString]]) {
        [YJProgressHUD showMessage:@"开始日期不能大于结束日期" inView:self];
        return NO;
    }
    
    NSTimeInterval startTime = [JKFactoryManager timeIntervalWithString:[_dateView leftDateString]];
    NSTimeInterval endTime = [JKFactoryManager timeIntervalWithString:[_dateView rightDateString]];
    NSTimeInterval value = endTime - startTime;
    int day = (int)value / (24 *3600);
    if (day > 30) {
        [YJProgressHUD showMessage:@"查询范围不能大于30天" inView:self];
        return NO;
    }
    
    if ([_minDate isKindOfClass:[NSDate class]]) {
        NSDateComponents *dateComponents = [JKFactoryManager dateComponentForTimeInterval:[_minDate timeIntervalSince1970]];
        
        NSString *month = nil;
        if (dateComponents.month < 10) {
            month = [[NSString alloc] initWithFormat:@"0%@",@(dateComponents.month)];
        }else {
            month = @(dateComponents.month).stringValue;
        }
        NSString *day = nil;
        if (dateComponents.day < 10) {
            day = [[NSString alloc] initWithFormat:@"0%@",@(dateComponents.day)];
        }else {
            day = @(dateComponents.day).stringValue;
        }
        
        NSDate *date = [JKFactoryManager dateFromStringByHotline:[[NSString alloc] initWithFormat:@"%@-%@-%@ 00:00:00",@(dateComponents.year),month,day]];
        
        NSTimeInterval timeInterval = (long)[date timeIntervalSince1970] - 8 * 3600;
        NSTimeInterval leftTimeInterval = [leftDate toTimeInterval];
        NSTimeInterval rightTimeInterval = [rightDate toTimeInterval];
        NSString *message = [[NSString alloc] initWithFormat:@"只能选择%@年%@月%@日之后的日期",@(dateComponents.year),@(dateComponents.month),@(dateComponents.day)];
        
        BOOL leftOK = YES;
        BOOL rightOK = YES;
        if (leftTimeInterval < timeInterval) {
            NSLog(@"%@",message);
            [_dateView selectDate:_minDate isRight:NO];
            leftOK = NO;
        }
        if (rightTimeInterval < timeInterval) {
            NSLog(@"%@",message);
            [_dateView selectDate:_minDate isRight:YES];
            rightOK = NO;
        }
        return leftOK && rightOK;
    }
    return YES;
}

- (void)setBtnNormalColor:(UIColor *)btnNormalColor {
    _btnNormalColor = btnNormalColor;
    
    
    [_qsButtonDateArray enumerateObjectsUsingBlock:^(JKButtonDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.normalColor = btnNormalColor;
    }];
    [self.qsButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:btnNormalColor forState:UIControlStateNormal];
        if (!obj.selected) {
            obj.layer.borderColor = btnNormalColor.CGColor;
        }
    }];
    
    [self.buttonTitleArrM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) {
            obj.backgroundColor = btnNormalColor;
            obj.layer.borderColor = btnNormalColor.CGColor;
        }
    }];
    
}
- (void)setBtnSelectColor:(UIColor *)btnSelectColor {
    
    _btnSelectColor = btnSelectColor;
    [_qsButtonDateArray enumerateObjectsUsingBlock:^(JKButtonDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectedColor = btnSelectColor;
    }];
    [self.qsButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:btnSelectColor forState:UIControlStateSelected];
        if (obj.selected) {
            obj.layer.borderColor = btnSelectColor.CGColor;
        }
    }];
    [self.buttonTitleArrM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 1) {
            obj.backgroundColor = btnSelectColor;
            obj.layer.borderColor = btnSelectColor.CGColor;
        }
    }];
}

- (UIScrollView*)titleScrollView {
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] init];
        if(_needQuickSelectionModule){
            _titleScrollView.frame = CGRectMake(0, 0, self.width, 40);
        }else{
            _titleScrollView.frame = CGRectZero;
        }
        _titleScrollView.contentSize = CGSizeMake(self.width, 40);
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.showsVerticalScrollIndicator = NO;
    }
    return _titleScrollView;
}

@end
