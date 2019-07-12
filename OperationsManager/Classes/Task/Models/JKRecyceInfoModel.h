//
//  JKRecyceInfoModel.h
//  OperationsManager
//
//  Created by    on 2018/10/30.
//  Copyright © 2018年   . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKRecyceInfoModel : NSObject
@property (nonatomic, strong) NSString *txtPondName;
@property (nonatomic, strong) NSString *txtPondPhone;
@property (nonatomic, strong) NSString *txtPondID;
@property (nonatomic, strong) NSString *txtPondAddr;
@property (nonatomic, strong) NSString *txtFarmerName;
@property (nonatomic, strong) NSString *txtFarmerAddr;
@property (nonatomic, strong) NSString *txtHKID;
@property (nonatomic, strong) NSString *txtHK;
@property (nonatomic, strong) NSString *txtHKPhone;
@property (nonatomic, strong) NSString *txtFarmerPhone;
@property (nonatomic, strong) NSString *txtFormNo;
@property (nonatomic, strong) NSString *txtFarmerID;
@property (nonatomic, strong) NSString *txtMatnerMembNo;
@property (nonatomic, strong) NSString *txtMatnerMembName;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *txtResMulti;
@property (nonatomic, strong) NSString *tarRemarks;
@property (nonatomic, strong) NSArray *tarEqps;
@property (nonatomic, strong) NSArray *brokenUrls;
@property (nonatomic, strong) NSArray *recycleUrls;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, assign) BOOL isGood;
@property (nonatomic, strong) NSString *explain;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSString *ident;
@property (nonatomic, strong) NSString *name;
@end
