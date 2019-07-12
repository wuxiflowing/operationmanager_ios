//
//  Typedef.h
//  OperationsManager
//
//  Created by    on 2018/7/3.
//  Copyright © 2018年   . All rights reserved.
//

#ifndef Typedef_h
#define Typedef_h

typedef NS_ENUM(NSInteger, JKInstallation) {
    JKInstallationWait,
    JKInstallationIng,
    JKInstallationEd,
};

typedef NS_ENUM(NSInteger, JKMaintain) {
    JKMaintainWait,
    JKMaintainIng,
    JKMaintainEd,
};

typedef NS_ENUM(NSInteger, JKRepaire) {
    JKRepaireWait,
    JKRepaireIng,
    JKRepaireEd,
};

typedef NS_ENUM(NSInteger, JKRecyce) {
    JKRecyceWait,
    JKRecyceIng,
    JKRecyceEd,
};

typedef NS_ENUM(NSInteger, JKEquipmentInfoType) {
    JKEquipmentInfoTypeInstall,
    JKEquipmentInfoTypeRepaire
};

typedef NS_ENUM(NSInteger, JKImageType) {
    JKImageTypeInstallOrder,
    JKImageTypeInstallService,
    JKImageTypeInstallDeposit,
    JKImageTypeRepaireFixOrder,
    JKImageTypeRepaireReceipt,
    JKImageTypeMaintain,
    JKImageTypeRecyceDevicePhoto,
    JKImageTypeRecyceDeviceOrder,
    JKImageTypeAttachFile,
};

#endif /* Typedef_h */
