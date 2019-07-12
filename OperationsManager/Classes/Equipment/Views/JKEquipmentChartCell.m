//
//  JKEquipmentChartCell.m
//  OperationsManager
//
//  Created by    on 2018/9/17.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKEquipmentChartCell.h"
#import "JKEquipmentChartModel.h"
#import "JKChooseEquipmentChartView.h"
#import "JKDateFilterView.h"

@interface JKEquipmentChartCell () <YASimpleGraphDelegate, JKChooseEquipmentChartViewDelegate>
{
    BOOL _isLongTime;
    NSInteger _xCount;
    NSInteger _chartType;
}
@property (nonatomic, strong) NSString *tskID;
@property (nonatomic, strong) NSMutableArray *timeArr;
@property (nonatomic, strong) NSMutableArray *valueArr;
@property (nonatomic, strong) NSMutableArray *showFiveTimeArr;
@property (nonatomic, strong) NSMutableArray *xArr;
@property (nonatomic, strong) NSArray *columnArr;
@property (nonatomic, strong) UILabel *dateLb;
@property (nonatomic, strong) UIButton *calendarBtn;
@property (nonatomic, strong) UIButton *columnsBtn;
@property (nonatomic, strong) UIButton *fiveBtn;
@property (nonatomic, strong) UIButton *todayBtn;
@property (nonatomic, strong) NSString *sTimeStr;
@property (nonatomic, strong) NSString *eTimeStr;
@property (nonatomic, strong) NSString *startTimeDateStr;
@property (nonatomic, strong) NSString *endTimeDateStr;
@property (nonatomic, strong) NSString *chartTitleStr;
@property (nonatomic, strong) JKDateFilterView *dataView;
@end

@implementation JKEquipmentChartCell

- (NSMutableArray *)timeArr {
    if (!_timeArr) {
        _timeArr = [[NSMutableArray alloc] init];
    }
    return _timeArr;
}

- (NSMutableArray *)valueArr {
    if (!_valueArr) {
        _valueArr = [[NSMutableArray alloc] init];
    }
    return _valueArr;
}

- (NSMutableArray *)xArr {
    if (!_xArr) {
        _xArr = [[NSMutableArray alloc] init];
    }
    return _xArr;
}

- (NSMutableArray *)showFiveTimeArr {
    if (!_showFiveTimeArr) {
        _showFiveTimeArr = [[NSMutableArray alloc] init];
    }
    return _showFiveTimeArr;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withTskID:(NSString *)tskID{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.columnArr = @[@"溶氧曲线", @"温度曲线", @"PH值曲线"];
        _chartType = 0;
        _isLongTime = NO;
        self.sTimeStr = @"0";
        self.eTimeStr = @"0";
        [self createUI];
        self.tskID = tskID;
        [self getRawdataWithTitle:@"dissolvedOxygen" withStartTime:@"0" withEndTime:@"0"];
    }
    return self;
}

- (void)createUI {
    [self.dateLb removeFromSuperview];
    UILabel *dateLb = [[UILabel alloc] init];
    dateLb.text = [self currentDateWithFormatter:@"YYYY年MM月dd日"];
    dateLb.textColor = RGBHex(0x333333);
    dateLb.textAlignment = NSTextAlignmentLeft;
    dateLb.font = JKFont(16);
    [self addSubview:dateLb];
    [dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8, 20));
    }];
    self.dateLb = dateLb;
    
    [self.columnsBtn removeFromSuperview];
    UIButton *columnsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    columnsBtn.frame = CGRectMake(15, 35, 100, 25);
    [columnsBtn setTitle:self.columnArr[_chartType] forState:UIControlStateNormal];
    [columnsBtn setTitleColor:RGBHex(0x888888) forState:UIControlStateNormal];
    [columnsBtn setImage:[UIImage imageNamed:@"ic_equipt_arrow"] forState:UIControlStateNormal];
    columnsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self buttonEdgeInsets:columnsBtn];
    columnsBtn.titleLabel.font = JKFont(15);
    [columnsBtn addTarget:self action:@selector(columnsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:columnsBtn];
    self.columnsBtn = columnsBtn;
    
    [self.calendarBtn removeFromSuperview];
    UIButton *calendarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendarBtn setImage:[UIImage imageNamed:@"ic_calendar"] forState:UIControlStateNormal];
    [calendarBtn addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    columnsBtn.tag = 12;
    [self addSubview:calendarBtn];
    [calendarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dateLb.mas_centerY);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.calendarBtn = calendarBtn;
    
    [self.fiveBtn removeFromSuperview];
    UIButton *fiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fiveBtn setTitle:@"近5日" forState:UIControlStateNormal];
    [fiveBtn setTitleColor:RGBHex(0x666666) forState:UIControlStateNormal];
    [fiveBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
    fiveBtn.titleLabel.font = JKFont(14);
    fiveBtn.backgroundColor = RGBHex(0xdddddd);
    fiveBtn.selected = NO;
    fiveBtn.tag = 11;
    [fiveBtn addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fiveBtn];
    [fiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(columnsBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    self.fiveBtn = fiveBtn;

    [self.todayBtn removeFromSuperview];
    UIButton *todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [todayBtn setTitle:@"今日" forState:UIControlStateNormal];
    [todayBtn setTitleColor:RGBHex(0x666666) forState:UIControlStateNormal];
    [todayBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
    todayBtn.titleLabel.font = JKFont(14);
    todayBtn.backgroundColor = kThemeColor;
    todayBtn.selected = YES;
    todayBtn.tag = 10;
    [todayBtn addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:todayBtn];
    [todayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fiveBtn);
        make.bottom.equalTo(fiveBtn);
        make.right.equalTo(fiveBtn.mas_left).offset(-10);
        make.width.mas_equalTo(50);
    }];
    self.todayBtn = todayBtn;
}

- (void)changeValue {
    if ([self.columnArr[_chartType] isEqualToString:@"溶氧曲线"]) {
        self.chartTitleStr = @"dissolvedOxygen";
    } else if ([self.columnArr[_chartType] isEqualToString:@"温度曲线"]) {
        self.chartTitleStr = @"temperature";
    } else {
        self.chartTitleStr = @"ph";
    }
    
    if (self.startTimeDateStr != nil) {
        if ([self.startTimeDateStr isEqualToString:self.endTimeDateStr]) {
            self.dateLb.text = self.startTimeDateStr;
        } else {
            self.dateLb.text = [NSString stringWithFormat:@"%@~%@",self.startTimeDateStr, self.endTimeDateStr];
        }
    } else {
        self.dateLb.text = [self currentDateWithFormatter:@"YYYY年MM月dd日"];
    }

    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        0.33, 0.67, 0.93, 0.25,
        1.0, 1.0, 1.0, 1.0
    };
    
    YASimpleGraphView *graphView = [[YASimpleGraphView alloc] init];
    graphView.frame = CGRectMake(0, 60, SCREEN_WIDTH, 210);
    graphView.backgroundColor = [UIColor whiteColor];
    graphView.allValues = self.valueArr;
    graphView.allDates = self.timeArr;
    graphView.showFiveDates = self.showFiveTimeArr;
    graphView.defaultShowIndex = self.timeArr.count-1;
    graphView.delegate = self;
    graphView.lineColor = [UIColor grayColor];
    graphView.lineWidth = 1.0/[UIScreen mainScreen].scale;
    graphView.lineAlpha = 1.0;
    graphView.enableTouchLine = YES;
    
    graphView.bottomGradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    [self addSubview:graphView];
    [graphView startDraw];
}

-(void)buttonEdgeInsets:(UIButton *)button{
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.bounds.size.width, 0, button.imageView.bounds.size.width)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width - 5, 0, -button.titleLabel.bounds.size.width)];
}

- (void)calendarBtnClick:(UIButton *)btn {
    if (btn.tag == 10) {
        self.todayBtn.selected = YES;
        self.todayBtn.backgroundColor = kThemeColor;
        self.fiveBtn.selected = NO;
        self.fiveBtn.backgroundColor = RGBHex(0xdddddd);
        self.sTimeStr = @"0";
        self.eTimeStr = @"0";
        self.startTimeDateStr = [self currentDateWithFormatter:@"YYYY年MM月dd日"];
        self.endTimeDateStr = [self currentDateWithFormatter:@"YYYY年MM月dd日"];
        _isLongTime = NO;
        [self getRawdataWithTitle:self.chartTitleStr withStartTime:self.sTimeStr withEndTime:self.eTimeStr];
    } else if (btn.tag == 11) {
        self.todayBtn.selected = NO;
        self.todayBtn.backgroundColor = RGBHex(0xdddddd);
        self.fiveBtn.selected = YES;
        self.fiveBtn.backgroundColor = kThemeColor;
        _isLongTime = YES;
        self.startTimeDateStr = [self getFiveDayStr:[self getFiveDay]];
        self.endTimeDateStr = [self currentDateWithFormatter:@"YYYY年MM月dd日"];
        
        self.sTimeStr = [self getFiveDayStampStr:[self getFiveDay]];
        self.eTimeStr = [self getFiveDayStampStr:[NSDate date]];
        [self getRawdataWithTitle:self.chartTitleStr withStartTime:self.sTimeStr withEndTime:self.eTimeStr];
    } else {
        [self chooseDate];
    }
}

#pragma mark -- 选择时间
- (void)chooseDate {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kBlackColor;
    bgView.alpha = 0.5;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(keywindow);
    }];
    
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT - 240, SCREEN_WIDTH, 200);
    self.dataView = [[JKDateFilterView alloc]initWithFrame:frame buttonTitles:@[@"重置",@"完成"] quickSelected:YES startDate:nil endDate:[NSDate date]];
    __weak typeof(self) weakSelf = self;
    self.dataView.finishBlock = ^(JKDateFilterView *bView, NSString *bLeftDate, NSString *bRightDate, NSString * title) {
        if (bLeftDate==nil) {
            [weakSelf.dataView cleanDate];
        }else{
            [weakSelf.dataView removeFromSuperview];
            [bgView removeFromSuperview];
            NSString *startTempStr = [NSString stringWithFormat:@"%@",bLeftDate];
            NSString *endTempStr = [NSString stringWithFormat:@"%@",bRightDate];
            NSArray *startTimeArr = [startTempStr componentsSeparatedByString:@"-"];
            NSArray *endTimeArr = [endTempStr componentsSeparatedByString:@"-"];
            weakSelf.startTimeDateStr = [NSString stringWithFormat:@"%@年%@月%@日",startTimeArr[0],startTimeArr[1],startTimeArr[2]];
            weakSelf.endTimeDateStr = [NSString stringWithFormat:@"%@年%@月%@日",endTimeArr[0],endTimeArr[1],endTimeArr[2]];
            NSString *currentDateStr = [weakSelf currentDateWithFormatter:@"YYYY-MM-dd"];
            if ([startTempStr isEqualToString:endTempStr]) {
                _isLongTime = NO;
                if ([startTempStr isEqualToString:currentDateStr]) {
                    weakSelf.sTimeStr = @"0";
                    weakSelf.eTimeStr = @"0";
                } else {
                    weakSelf.sTimeStr = [weakSelf getFiveDayStampStr:[weakSelf getArbitrarilyTimeDate:bLeftDate]];
                    weakSelf.eTimeStr = [weakSelf getFiveDayStampStr:[weakSelf getArbitrarilyTimeDate:bRightDate]];
                }
                [weakSelf getRawdataWithTitle:weakSelf.chartTitleStr withStartTime:weakSelf.sTimeStr withEndTime:weakSelf.eTimeStr];
            } else {
                _isLongTime = YES;
                weakSelf.sTimeStr = [weakSelf getFiveDayStampStr:[weakSelf getArbitrarilyTimeDate:bLeftDate]];
                weakSelf.eTimeStr = [weakSelf getFiveDayStampStr:[weakSelf getArbitrarilyTimeDate:bRightDate]];
                [weakSelf getRawdataWithTitle:weakSelf.chartTitleStr withStartTime:weakSelf.sTimeStr withEndTime:weakSelf.eTimeStr];
            }
            weakSelf.todayBtn.selected = NO;
            weakSelf.todayBtn.backgroundColor = RGBHex(0xdddddd);
            weakSelf.fiveBtn.selected = NO;
            weakSelf.fiveBtn.backgroundColor = RGBHex(0xdddddd);
        }
    };
    [keywindow addSubview:self.dataView];
}

#pragma mark -- 获取5天前的日期(NSDate)
- (NSDate *)getFiveDay {
    NSInteger dis = 5;
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis];
    return theDate;
}

#pragma mark -- 获取5天前的日期(NSString)
- (NSString *)getFiveDayStr:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *timeStr = [dateFormatter stringFromDate:date];
    return timeStr;
}

#pragma mark -- 获取5天前的日期(时间戳)
- (NSString *)getFiveDayStampStr:(NSDate *)date {
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSString *timeStampStr = [NSString stringWithFormat:@"%.0f",timeInterval * 1000];
    return timeStampStr;
}

#pragma mark -- 获取任意时间（NSDate）
- (NSDate *)getArbitrarilyTimeDate:(NSString *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *timeDate = [dateFormatter dateFromString:time];
    return timeDate;
}

- (void)columnsBtnClick:(UIButton *)btn {
    JKChooseEquipmentChartView *alertView = [[JKChooseEquipmentChartView alloc] init];
    alertView.delegate = self;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(keywindow);
    }];
}

- (void)chooseChartTitle:(NSString *)title {
    [self.columnsBtn setTitle:title forState:UIControlStateNormal];
    if ([title isEqualToString:@"溶氧曲线"]) {
        self.chartTitleStr = @"dissolvedOxygen";
        [self getRawdataWithTitle:@"dissolvedOxygen" withStartTime:self.sTimeStr withEndTime:self.eTimeStr];
    } else if ([title isEqualToString:@"温度曲线"]) {
        self.chartTitleStr = @"temperature";
        [self getRawdataWithTitle:@"temperature" withStartTime:self.sTimeStr withEndTime:self.eTimeStr];
    } else {
        self.chartTitleStr = @"ph";
        [self getRawdataWithTitle:@"ph" withStartTime:self.sTimeStr withEndTime:self.eTimeStr];
    }
}

- (void)getRawdataWithTitle:(NSString *)title withStartTime:(NSString *)startDate withEndTime:(NSString *)endDate {
    _xCount = 0;
    if ([title isEqualToString:@"dissolvedOxygen"]) {
        _chartType = 0;
    } else if ([title isEqualToString:@"temperature"]) {
        _chartType = 1;
    } else {
        _chartType = 2;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@/v1/device/identifier/%@/rawdata?columns=%@&startTime=%@&endTime=%@",kUrl_Base,self.tskID,title,startDate,endDate];
    
    [YJProgressHUD showProgressCircleNoValue:@"加载中..." inView:self];
    [[JKHttpTool shareInstance] GetReceiveInfo:nil url:urlStr successBlock:^(id responseObject) {
        [YJProgressHUD hide];
        if (responseObject[@"success"]) {
            [self.timeArr removeAllObjects];
            [self.valueArr removeAllObjects];
            [self.showFiveTimeArr removeAllObjects];
            
            if ([responseObject[@"data"][@"values"] count] == 0) {
                [YJProgressHUD showMessage:@"暂无数据" inView:self];
                return;
            }
            
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            for (NSArray *arr in responseObject[@"data"][@"values"]) {
                [tempArr addObject:arr[0]];
                if (_isLongTime) {
                    NSString *time = [self currentDateWithFormatter:@"yyyy-MM-dd HH:mm" withDate:arr[0]];
                    [self.timeArr addObject:time];
                } else {
                    NSString *time = [self currentDateWithFormatter:@"HH:mm" withDate:arr[0]];
                    [self.timeArr addObject:time];
                }
                if ([arr[1] floatValue] != -1) {
                   [self.valueArr addObject:[NSString stringWithFormat:@"%.1f",[arr[1] floatValue]]];
                } else {
                    [self.valueArr addObject:@"0"];
                }
                [self.xArr addObject:[NSNumber numberWithInteger:_xCount]];
                _xCount++;
            }
            if (tempArr.count == 0) {
                return;
            }
            NSInteger startTime = [tempArr[0] integerValue];
            NSInteger endTime = [tempArr[tempArr.count - 1] integerValue];
            NSInteger difference = (endTime - startTime) / 4;
            NSString *startTimeStr = [NSString stringWithFormat:@"%ld",startTime];
            NSString *secondTimeStr = [NSString stringWithFormat:@"%ld",startTime + difference];
            NSString *thirdTimeStr = [NSString stringWithFormat:@"%ld",startTime + difference * 2];
            NSString *fourTimeStr = [NSString stringWithFormat:@"%ld",startTime + difference * 3];
            NSString *endTimeStr = [NSString stringWithFormat:@"%ld",endTime];
            if (_isLongTime) {
                [self.showFiveTimeArr addObject: [self currentDateWithFormatter:@"yyyy-MM-dd \nHH:mm" withDate:startTimeStr]];
                [self.showFiveTimeArr addObject: [self currentDateWithFormatter:@"yyyy-MM-dd \nHH:mm" withDate:secondTimeStr]];
                [self.showFiveTimeArr addObject: [self currentDateWithFormatter:@"yyyy-MM-dd \nHH:mm" withDate:thirdTimeStr]];
                [self.showFiveTimeArr addObject: [self currentDateWithFormatter:@"yyyy-MM-dd \nHH:mm" withDate:fourTimeStr]];
                [self.showFiveTimeArr addObject: [self currentDateWithFormatter:@"yyyy-MM-dd \nHH:mm" withDate:endTimeStr]];
            } else {
                [self.showFiveTimeArr addObject: [self currentDateWithFormatter:@"HH:mm" withDate:startTimeStr]];
                [self.showFiveTimeArr addObject: [self currentDateWithFormatter:@"HH:mm" withDate:secondTimeStr]];
                [self.showFiveTimeArr addObject: [self currentDateWithFormatter:@"HH:mm" withDate:thirdTimeStr]];
                [self.showFiveTimeArr addObject: [self currentDateWithFormatter:@"HH:mm" withDate:fourTimeStr]];
                [self.showFiveTimeArr addObject: [self currentDateWithFormatter:@"HH:mm" withDate:endTimeStr]];
            }

            [self changeValue];
        }
    } withFailureBlock:^(NSError *error) {
        [YJProgressHUD hide];
    }];
}

//自定义X轴 显示标签索引
- (NSArray *)incrementPositionsForXAxisOnLineGraph:(YASimpleGraphView *)graph {
    return self.xArr;
}

//Y轴坐标点数
- (NSInteger)numberOfYAxisLabelsOnLineGraph:(YASimpleGraphView *)graph {
    return 3;
}

//自定义popUpView
- (UIView *)popUpViewForLineGraph:(YASimpleGraphView *)graph {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.backgroundColor = [UIColor colorWithRed:146/255.0 green:191/255.0 blue:239/255.0 alpha:1];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

//修改相应点位弹出视图
- (void)lineGraph:(YASimpleGraphView *)graph modifyPopupView:(UIView *)popupView forIndex:(NSUInteger)index {
    UILabel *label = (UILabel*)popupView;
    NSString *date = [NSString stringWithFormat:@"%@",self.timeArr[index]];
    NSString *str;
    if (_chartType == 0) {
        str = [NSString stringWithFormat:@" %@ \n %@ml/L",date,self.valueArr[index]];
    } else if (_chartType == 1) {
        str = [NSString stringWithFormat:@" %@ \n %@℃",date,self.valueArr[index]];
    } else {
        str = [NSString stringWithFormat:@" %@ \n %@",date,self.valueArr[index]];
    }
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil];

    [label setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    label.textColor = [UIColor whiteColor];
    label.text = str;
}

#pragma mark -- 获取时间
- (NSString *)currentDateWithFormatter:(NSString *)formatter withDate:(NSString *)timeStampStr{
    NSTimeInterval interval = [timeStampStr doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];

    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSString *timeStr = [dateformatter stringFromDate:date];
    return timeStr;
}

#pragma mark -- 获取时间
- (NSString *)currentDateWithFormatter:(NSString *)formatter {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSString *timeStr = [dateformatter stringFromDate:date];
    return timeStr;
}

@end
