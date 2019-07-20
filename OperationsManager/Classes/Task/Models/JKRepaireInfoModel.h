//
//  JKRepaireInfoModel.h
//  OperationsManager
//
//  Created by    on 2018/8/13.
//  Copyright © 2018年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKRepaireInfoModel : NSObject
@property (nonatomic, strong) NSString *txtFarmerID;//养殖户ID
@property (nonatomic, strong) NSString *picture;//养殖户头像
@property (nonatomic, strong) NSString *txtFarmerName;//养殖户姓名
@property (nonatomic, strong) NSString *txtFarmerAddr;//养殖户地址
@property (nonatomic, strong) NSString *txtFarmerPhone;//养殖户电话
@property (nonatomic, strong) NSString *txtPondsName;//鱼塘名称
@property (nonatomic, strong) NSString *region;//省市区镇
@property (nonatomic, strong) NSString *txtPondAddr;//鱼塘位置
@property (nonatomic, strong) NSString *txtRepairEqpKind;//设备型号
@property (nonatomic, strong) NSString *txtRepairEqpID;//旧设备ID
@property (nonatomic, strong) NSString *txtNewID;//新设备ID
@property (nonatomic, strong) NSString *txtPondPhone;//鱼塘联系电话
@property (nonatomic, strong) NSString *txtMaintenDetail;//故障描述
@property (nonatomic, strong) NSString *txtMatnerMembName;//运维人员
@property (nonatomic, assign) BOOL rdoSelfYes;//处理方式
@property (nonatomic, strong) NSString *txtResMulti;//故障原因
@property (nonatomic, strong) NSString *tarResOth;//备注
@property (nonatomic, strong) NSString *txtConMulti;//维修内容
@property (nonatomic, strong) NSString *tarConOth;//备注
@property (nonatomic, strong) NSString *tarRemarks;//备注
@property (nonatomic, strong) NSString *txtRepairFormImg;//维修单附件图片
@property (nonatomic, strong) NSString *txtReceiptImg;//收款凭证附件图片
@property (nonatomic, strong) NSString *txtEndDate;//实际完成时间
@property (nonatomic, strong) NSString *txtStartDate;//接单时间
@property (nonatomic, strong) NSString *txtPondID;//鱼塘ID
@property (nonatomic, strong) NSString *txtAppRepairImg;//报修图片
@property (nonatomic, strong) NSString *txtFormNo;
@property (nonatomic, strong) NSString *txtHKName;
@property (nonatomic, strong) NSString *txtMonMembName;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *cboPondID;

@end
