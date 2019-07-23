//
//  JKFarmerEquipmentMainCell.m
//  BusinessManager
//
//  Created by xuziyuan on 2019/7/13.
//  Copyright © 2019 周家康. All rights reserved.
//

#import "JKFarmerEquipmentMainCell.h"
#import "JKPondModel.h"

@interface JKFarmerEquipmentMainCell ()
@property (weak, nonatomic) IBOutlet UIView *bgContentView;
@property (weak, nonatomic) IBOutlet UILabel *oxyValueLb;
@property (weak, nonatomic) IBOutlet UILabel *pondNameLb;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
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

@property (nonatomic, strong) JKPondModel *model;
@property (nonatomic, strong) JKPondChildDeviceModel *dModel;
@end

@implementation JKFarmerEquipmentMainCell

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

- (IBAction)onEquimentDetailAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(pushDeviceInfoVC:)]) {
        [_delegate pushDeviceInfoVC:self.dModel];
    }
}


- (void)configCellWithModel:(JKPondChildDeviceModel *)model withPondModel:(JKPondModel *)pModel{
    self.model = pModel;
    self.dModel = model;
    self.pondNameLb.text = pModel.name;
    self.typeLb.text = JKSafeNull(model.type);
    
    if (model.workStatus==0) {
        //        self.alarmType = @"正常";
        self.statusImageView.image = [UIImage imageNamed:@"icon_normal_"];
    } else if (model.workStatus==1) {
        //        self.alarmType = @"告警限1";
        self.statusImageView.image = [UIImage imageNamed:@"icon_ponds_data"];
    } else if (model.workStatus==2) {
        //        self.alarmType = @"告警限2";
        self.statusImageView.image = [UIImage imageNamed:@"icon_ponds_data2"];
    } else if (model.workStatus==3) {
        //        self.alarmType = @"不在线告警";
        self.statusImageView.image = [UIImage imageNamed:@"icon_ponds_offline"];
    } else if (model.workStatus==4) {
        //        self.alarmType = @"超过上下限报警"
        self.statusImageView.image = [UIImage imageNamed:@"icon_ponds_eq"];
    } else if (model.workStatus==-1) {
        //        self.alarmType = @"数据解析异常";
        self.statusImageView.image = [UIImage imageNamed:@"icon_ponds_warning"];
    }

    
    [self setControlStatusWithView:self.control1Lb status:model.aeratorControlOne];
    [self setControlStatusWithView:self.control2Lb status:model.aeratorControlTwo];
    self.equimentStatus1Btn.selected = [[NSString stringWithFormat:@"%@",model.statusControlOne] isEqualToString:@"0"];
    self.equimentStatus2Btn.selected = [[NSString stringWithFormat:@"%@",model.statusControlTwo] isEqualToString:@"0"];
    if (model.aeratorControlTree) {
        [self setControlStatusWithView:self.control3Lb status:model.aeratorControlTree];
        self.equimentStatus3Btn.selected = [[NSString stringWithFormat:@"%@",model.statusControlTree] isEqualToString:@"0"];
    }else{
        self.control3Lb.hidden = YES;
        self.equimentStatus3Btn.hidden = YES;
    }
    if (model.aeratorControlFour) {
        [self setControlStatusWithView:self.control4Lb status:model.aeratorControlFour];
        self.equimentStatus4Btn.selected = [[NSString stringWithFormat:@"%@",model.statusControlFour] isEqualToString:@"0"];
        
    }else{
        self.control4Lb.hidden = YES;
        self.equimentStatus4Btn.hidden = YES;
    }
    
    
    
    if (model.workStatus==3) {
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
