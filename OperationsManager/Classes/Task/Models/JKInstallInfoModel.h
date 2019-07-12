//
//  JKInstallInfoModel.h
//  OperationsManager
//
//  Created by    on 2018/8/13.
//  Copyright © 2018年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKInstallInfoModel : NSObject
@property (nonatomic, strong) NSString *txtFarmerID;
@property (nonatomic, strong) NSString *txtFarmer;//养殖户姓名
@property (nonatomic, strong) NSString *txtFarmerManager;//养殖管家
@property (nonatomic, strong) NSString *picture;//养殖户头像
@property (nonatomic, strong) NSString *txtFarmerAddress;//养殖户地址
@property (nonatomic, strong) NSString *txtDeviceNum;//设备数量
@property (nonatomic, strong) NSString *txtPhone;//养殖户电话
@property (nonatomic, strong) NSString *txtStatus;//任务状态
@property (nonatomic, strong) NSString *txtInstallationPersonnel;//运维人员
@property (nonatomic, strong) NSString *txtFishPondCount;//鱼塘数量
@property (nonatomic, strong) NSString *region;//省市区镇
@property (nonatomic, strong) NSString *txtInstallAddress;//安装地址
@property (nonatomic, strong) NSString *txtDepositAmount;//代收服务费
@property (nonatomic, strong) NSString *txtServiceAmount;//代收押金费
@property (nonatomic, strong) NSString *calExpectedTime;//计划完成时间
@property (nonatomic, strong) NSString *calDispatchTime;//接单时间
@property (nonatomic, strong) NSString *calInstallationTime;//实际完成时间
@property (nonatomic, strong) NSArray *tabEquipmentList;//待安装设备列表
@property (nonatomic, strong) NSArray *tabEquipmentBindPond;//安装完成设备列表
@property (nonatomic, strong) NSString *ITEM2; //设备名称
@property (nonatomic, strong) NSString *ITEM3; //设备数量
//是否收取服务费
@property (nonatomic, strong) NSString *txtRelaceAmoutS;//实收金额
@property (nonatomic, strong) NSString *txtPaymentMethodS;//付款方式
@property (nonatomic, strong) NSString *txtNoteS;//备注
@property (nonatomic, strong) NSString *txtPaymentUrlS;//附件图片列表
//是否收取押金费
@property (nonatomic, strong) NSString *txtRelaceAmoutD;//实收金额
@property (nonatomic, strong) NSString *txtPaymentMethodD;//付款方式
@property (nonatomic, strong) NSString *txtNoteD;//备注
@property (nonatomic, strong) NSString *txtPaymentUrlD;//附件图片列表

@property (nonatomic, strong) NSString *txtUrls;//任务附件图片列表

@property (nonatomic, strong) NSString *txtDepositRemark;
@property (nonatomic, strong) NSString *txtServiceRemark;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *txtReciptTime;


@end
