//
//  JKFarmerEquipmentMainCell.m
//  BusinessManager
//
//  Created by xuziyuan on 2019/7/13.
//  Copyright © 2019 周家康. All rights reserved.
//

#import "JKFarmerEquipmentTaskCell.h"
#import "JKDeviceModel.h"

@interface JKFarmerEquipmentTaskCell ()
@property (weak, nonatomic) IBOutlet UIView *bgContentView;
@property (weak, nonatomic) IBOutlet UILabel *oxyValueLb;
@property (weak, nonatomic) IBOutlet UILabel *pondNameLb;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;

@property (weak, nonatomic) IBOutlet UILabel *control1Lb;
@property (weak, nonatomic) IBOutlet UIButton *equimentStatus1Btn;
@property (weak, nonatomic) IBOutlet UILabel *control2Lb;
@property (weak, nonatomic) IBOutlet UIButton *equimentStatus2Btn;
@property (weak, nonatomic) IBOutlet UILabel *control3Lb;
@property (weak, nonatomic) IBOutlet UIButton *equimentStatus3Btn;
@property (weak, nonatomic) IBOutlet UILabel *control4Lb;
@property (weak, nonatomic) IBOutlet UIButton *equimentStatus4Btn;
@property (weak, nonatomic) IBOutlet UILabel *temLb;
@property (weak, nonatomic) IBOutlet UILabel *phLb;
- (IBAction)onEquimentDetailAction:(id)sender;
- (IBAction)onPondDetailAction:(id)sender;

@property (nonatomic, strong) JKDeviceModel *model;
@property (nonatomic, assign) NSInteger no;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *pondID;
@property (nonatomic, assign) JKEquipmentType equipmentType;
@end

@implementation JKFarmerEquipmentTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgContentView.layer.cornerRadius = 5;
    self.bgContentView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -- 配置
- (IBAction)onEquimentDetailAction:(id)sender {
    if ([self.model.type isEqualToString:@"QY601"]) {
        self.equipmentType = JKEquipmentType_New;
    }
    if ([self.model.type isEqualToString:@"KD326"]) {
        self.equipmentType = JKEquipmentType_Old;
    }
    if ([_delegate respondsToSelector:@selector(setDeviceInfo:withPondName:withPondId:withNo:withType:)]) {
        [_delegate setDeviceInfo:self.deviceID withPondName:self.deviceName withPondId:self.pondID withNo:self.no withType:self.equipmentType];
    }
}
#pragma mark -- 删除
- (IBAction)onPondDetailAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(deleteDevice:)]) {
        [_delegate deleteDevice:self.no];
    }
}

- (void)configCellWithModel:(JKDeviceModel *)model{
    self.model = model;
    self.pondNameLb.text = model.name;
    self.typeLb.text = JKSafeNull(model.type);
    self.deviceName = model.name;
    self.deviceID = model.deviceId;
    self.pondID = model.pondId;
    self.no = self.tag;
    
    self.statusLb.text = [self getWorkStatusDescribeWithWorkStatus:model.workStatus];
    
    [self setControlStatusWithView:self.control1Lb status:model.aeratorControlOne];
    [self setControlStatusWithView:self.control2Lb status:model.aeratorControlTwo];
    self.equimentStatus1Btn.selected = [[NSString stringWithFormat:@"%@",model.statusControlOne] isEqualToString:@"0"];
    self.equimentStatus2Btn.selected = [[NSString stringWithFormat:@"%@",model.statusControlTwo] isEqualToString:@"0"];
    if (model.aeratorControlTree.integerValue) {
        [self setControlStatusWithView:self.control3Lb status:model.aeratorControlTree];
        self.equimentStatus3Btn.selected = [[NSString stringWithFormat:@"%@",model.statusControlTree] isEqualToString:@"0"];
    }else{
        self.control3Lb.hidden = YES;
        self.equimentStatus3Btn.hidden = YES;
    }
    if (model.aeratorControlFour.integerValue) {
        [self setControlStatusWithView:self.control4Lb status:model.aeratorControlFour];
        self.equimentStatus4Btn.selected = [[NSString stringWithFormat:@"%@",model.statusControlFour] isEqualToString:@"0"];

    }else{
        self.control4Lb.hidden = YES;
        self.equimentStatus4Btn.hidden = YES;
    }
    
    
    
    if ([model.workStatus isEqualToString:@"3"]) {
        self.oxyValueLb.text = @"--";
        self.temLb.text = @"--";
        self.phLb.text = @"--";
    }else{
        self.oxyValueLb.text = [NSString stringWithFormat:@"%.1f",model.dissolvedOxygen];
        self.temLb.text = [NSString stringWithFormat:@"%.1f ℃",model.temperature];
        if (model.ph == -1) {
            self.phLb.text = @"--";
        }else{
            self.phLb.text = [NSString stringWithFormat:@"%.1f",model.ph];
        }
    }
}

- (NSString *)getWorkStatusDescribeWithWorkStatus:(NSString *)workStatus{
    NSArray *status = [workStatus componentsSeparatedByString:@","];
    NSMutableArray *strStatus = [[NSMutableArray alloc] initWithCapacity:0];
    [status enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"0"]) {
            [strStatus addObject:@"正常"];
        }else if ([obj isEqualToString:@"1"]){
            [strStatus addObject:@"数据告警1"];
        }else if ([obj isEqualToString:@"2"]){
            [strStatus addObject:@"数据告警2"];
        }else if ([obj isEqualToString:@"3"]){
            [strStatus addObject:@"不在线告警"];
        }else if ([obj isEqualToString:@"5"]){
            [strStatus addObject:@"设备告警"];
        }else if ([obj isEqualToString:@"9"]){
            [strStatus addObject:@"电流异常"];
        }else if ([obj isEqualToString:@"10"]){
            [strStatus addObject:@"断电告警"];
        }else{
            [strStatus addObject:@""];
        }
    }];
    return [strStatus componentsJoinedByString:@"、"];
}

- (void)setControlStatusWithView:(UILabel*)view status:(NSString *)status{
    view.layer.cornerRadius = 12.5;
    view.layer.masksToBounds = YES;
    if ([[NSString stringWithFormat:@"%@",status] isEqualToString:@"0"]) {
        view.layer.borderWidth = 1;
        view.layer.borderColor = RGBHex(0x999999).CGColor;
        view.textColor = RGBHex(0x333333);
        view.backgroundColor = UIColor.whiteColor;
    }else{
        view.layer.borderWidth = 0;
        view.textColor = UIColor.whiteColor;
        view.backgroundColor = RGBHex(0x009051);
    }
}
@end
