//
//  JKRecyceResultCell.m
//  OperationsManager
//
//  Created by    on 2018/7/9.
//  Copyright © 2018年   . All rights reserved.
//

#import "JKRecyceResultCell.h"
#import "TZImagePickerHelper.h"
#import "JKRecyceInfoModel.h"

#define WeakPointer(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface JKRecyceResultCell() <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *noBtn;
@property (nonatomic, strong) UIButton *yesBtn;
@property (nonatomic, strong) UIScrollView *pictureScrollView;
@property (nonatomic, strong) UIScrollView *orderScrollView;
@property (nonatomic, strong) TZImagePickerHelper *photoHelper;
@property (nonatomic, strong) TZImagePickerHelper *orderHelper;
@property (nonatomic, strong) NSMutableArray *imagePhotoURL;
@property (nonatomic, strong) NSMutableArray *imageOrderURL;
@property (nonatomic, strong) UILabel *orderLb;
@property (nonatomic, strong) UILabel *pictureLb;

@end

@implementation JKRecyceResultCell

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kBgColor;
        _tableView.separatorColor = RGBHex(0xdddddd);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (UIScrollView *)pictureScrollView {
    if (!_pictureScrollView) {
        _pictureScrollView = [[UIScrollView alloc] init];
        _pictureScrollView.showsHorizontalScrollIndicator = NO;
        _pictureScrollView.backgroundColor = kWhiteColor;
    }
    return _pictureScrollView;
}

- (UIScrollView *)orderScrollView {
    if (!_orderScrollView) {
        _orderScrollView = [[UIScrollView alloc] init];
        _orderScrollView.showsHorizontalScrollIndicator = NO;
        _orderScrollView.backgroundColor = kWhiteColor;
    }
    return _orderScrollView;
}

- (NSMutableArray *)imagePhotoURL {
    if (!_imagePhotoURL) {
        _imagePhotoURL = [NSMutableArray array];
    }
    return _imagePhotoURL;
}

- (NSMutableArray *)imagePhotoArr {
    if (!_imagePhotoArr) {
        _imagePhotoArr = [NSMutableArray array];
    }
    return _imagePhotoArr;
}

- (NSMutableArray *)imageOrderURL {
    if (!_imageOrderURL) {
        _imageOrderURL = [NSMutableArray array];
    }
    return _imageOrderURL;
}

- (NSMutableArray *)imageOrderArr {
    if (!_imageOrderArr) {
        _imageOrderArr = [NSMutableArray array];
    }
    return _imageOrderArr;
}

- (TZImagePickerHelper *)photoHelper {
    if (!_photoHelper) {
        _photoHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _photoHelper.imageType = JKImageTypeRecyceDevicePhoto;
        _photoHelper.finishRecyceDevicePhoto = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imagePhotoURL addObjectsFromArray:array];
            for (NSString *str in imageArr) {
                [weakSelf.imagePhotoArr addObject:str];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _photoHelper;
}

- (TZImagePickerHelper *)orderHelper {
    if (!_orderHelper) {
        _orderHelper = [[TZImagePickerHelper alloc] init];
        WeakPointer(weakSelf);
        _orderHelper.imageType = JKImageTypeRecyceDeviceOrder;
        _orderHelper.finishRecyceDeviceOrder = ^(NSArray *array, NSArray *imageArr) {
            [weakSelf.imageOrderURL addObjectsFromArray:array];
            for (NSString *str in imageArr) {
                [weakSelf.imageOrderArr addObject:str];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
                NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
                [weakSelf.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            });
        };
    }
    return _orderHelper;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kBgColor;
        
        [self createUI];
        _chooseSingle = YES;

    }
    return self;
}

- (void)createUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kWhiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.right.bottom.equalTo(self);
    }];
    
    [bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.right.bottom.equalTo(bgView);
    }];
}

#pragma mark -- 回收信息是否符合
- (void)singleSelected:(UIButton *)btn {
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 0) {
            self.noBtn.selected = NO;
        } else {
            self.yesBtn.selected = NO;
        }
        _chooseSingle = !_chooseSingle;
    }
}

//- (void)setDataSource:(NSMutableArray *)dataSource {
//    _dataSource = dataSource;
//    NSLog(@"%ld",_dataSource.count);
////    [self.tableView reloadData];
//}

- (void)setModel:(JKRecyceInfoModel *)model {
    _model = model;
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 48;
    } else if (indexPath.row == 2 || indexPath.row == 3) {
        if (self.recyceType == JKRecyceIng) {
            return 100;
        } else {
            return 60;
        }
    } else {
        return 150;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = JKFont(14);
    cell.textLabel.textColor = RGBHex(0x333333);
    cell.detailTextLabel.font = JKFont(14);
    cell.detailTextLabel.textColor = RGBHex(0x999999);
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"处理结果";
        cell.textLabel.font = JKFont(16);
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"设备是否完好";
        
        if (self.recyceType == JKRecyceIng) {
            UIButton *noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [noBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
            [noBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
            [noBtn setTitle:@"  否" forState:UIControlStateNormal];
            [noBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
            [noBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
            noBtn.titleLabel.font = JKFont(14);
            noBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            noBtn.tag = 1;
            noBtn.selected = NO;
            [noBtn addTarget:self action:@selector(singleSelected:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:noBtn];
            [noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).offset(-15);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
            self.noBtn = noBtn;
            
            UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [yesBtn setImage:[UIImage imageNamed:@"ic_choose_off"] forState:UIControlStateNormal];
            [yesBtn setImage:[UIImage imageNamed:@"ic_choose_on"] forState:UIControlStateSelected];
            [yesBtn setTitle:@"  是" forState:UIControlStateNormal];
            [yesBtn setTitleColor:RGBHex(0x999999) forState:UIControlStateNormal];
            [yesBtn setTitleColor:RGBHex(0x333333) forState:UIControlStateSelected];
            yesBtn.titleLabel.font = JKFont(14);
            yesBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            yesBtn.tag = 0;
            yesBtn.selected = YES;
            [yesBtn addTarget:self action:@selector(singleSelected:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:yesBtn];
            [yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(self.noBtn.mas_left).offset(-5);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
            self.yesBtn = yesBtn;
        } else {
            if (self.model.isGood) {
                cell.detailTextLabel.text = @"是";
            } else {
                cell.detailTextLabel.text = @"否";
            }
        }
        
    } else if (indexPath.row == 2) {
        
        if (self.recyceType == JKRecyceIng) {
            UILabel *descriptionLb = [[UILabel alloc] init];
            descriptionLb.text = @"说明";
            descriptionLb.textColor = RGBHex(0x333333);
            descriptionLb.textAlignment = NSTextAlignmentLeft;
            descriptionLb.font = JKFont(14);
            [cell addSubview:descriptionLb];
            [descriptionLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell);
                make.left.equalTo(cell).offset(15);
                make.width.mas_offset(70);
                make.height.mas_equalTo(48);
            }];
            
            UITextView *descriptionLbTV = [[UITextView alloc] init];
            descriptionLbTV.font = JKFont(14);
            descriptionLbTV.textColor = RGBHex(0x666666);
            descriptionLbTV.layer.borderColor = RGBHex(0xdddddd).CGColor;
            descriptionLbTV.layer.borderWidth = 1;
            descriptionLbTV.delegate = self;
            [descriptionLbTV setPlaceholder:@"描述" placeholdColor: RGBHex(0xdddddd)];
            [cell addSubview:descriptionLbTV];
            [descriptionLbTV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(10);
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.left.equalTo(descriptionLb.mas_right);
                make.bottom.equalTo(cell).offset(-10);
            }];
            self.descriptionLbTV = descriptionLbTV;
        } else {
            cell.textLabel.text = @"说明";
            cell.detailTextLabel.text = self.model.explain;
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            cell.detailTextLabel.numberOfLines = 2;
//            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            [cell.detailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(10);
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.left.equalTo(cell.mas_centerX);
                make.bottom.equalTo(cell).offset(-10);
            }];
        }
        
    } else if (indexPath.row == 3) {
        
        if (self.recyceType == JKRecyceIng) {
            UILabel *remarkLb = [[UILabel alloc] init];
            remarkLb.text = @"备注";
            remarkLb.textColor = RGBHex(0x333333);
            remarkLb.textAlignment = NSTextAlignmentLeft;
            remarkLb.font = JKFont(14);
            [cell addSubview:remarkLb];
            [remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell);
                make.left.equalTo(cell).offset(15);
                make.width.mas_offset(70);
                make.height.mas_equalTo(48);
            }];
            
            UITextView *remarkTV = [[UITextView alloc] init];
            remarkTV.font = JKFont(14);
            remarkTV.textColor = RGBHex(0x666666);
            remarkTV.layer.borderColor = RGBHex(0xdddddd).CGColor;
            remarkTV.layer.borderWidth = 1;
            remarkTV.delegate = self;
            [remarkTV setPlaceholder:@"描述" placeholdColor: RGBHex(0xdddddd)];
            [cell addSubview:remarkTV];
            [remarkTV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(10);
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.left.equalTo(remarkLb.mas_right);
                make.bottom.equalTo(cell).offset(-10);
            }];
            self.remarkTV = remarkTV;
        } else {
            cell.textLabel.text = @"备注";
            cell.detailTextLabel.text = self.model.remarks;
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            cell.detailTextLabel.numberOfLines = 2;
//            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            [cell.detailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(10);
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.left.equalTo(cell.mas_centerX);
                make.bottom.equalTo(cell).offset(-10);
            }];
        }
        
    } else if (indexPath.row == 4) {
        [self.pictureLb removeFromSuperview];
        UILabel *pictureLb = [[UILabel alloc] init];
        pictureLb.textColor = RGBHex(0x333333);
        pictureLb.textAlignment = NSTextAlignmentLeft;
        pictureLb.font = JKFont(14);
        [cell addSubview:pictureLb];
        [pictureLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.width.mas_offset(200);
            make.height.mas_equalTo(48);
        }];
        self.pictureLb = pictureLb;
        
        if (self.recyceType == JKRecyceIng) {
            pictureLb.text = @"上传损坏设备照片";
            
            [self.pictureScrollView removeFromSuperview];
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.backgroundColor = kWhiteColor;
            [cell addSubview:scrollView];
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(pictureLb.mas_bottom).offset(5);
                make.left.equalTo(cell.mas_left).offset(15);
                make.right.equalTo(cell.mas_right).offset(-15);
                make.height.mas_equalTo(80);
            }];
            
            scrollView.contentSize = CGSizeMake(90 *(self.imagePhotoURL.count +1), 80);
            self.pictureScrollView = scrollView;
            
            if (self.imagePhotoURL.count == 0) {
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(0, 0, 80, 80);
                addBtn.tag = JKImageTypeRecyceDevicePhoto;
                [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:addBtn];
            } else {
                if (self.imagePhotoURL.count == 9) {
                    for (NSInteger i = 0; i < self.imagePhotoURL.count; i++) {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(90 * i , 0, 80, 80);
                        btn.tag = i;
                        [btn addTarget:self action:@selector(showPhotoImgClick:) forControlEvents:UIControlEventTouchUpInside];
                        [btn setImage:[UIImage imageWithContentsOfFile:self.imagePhotoURL[i]] forState:UIControlStateNormal];
                        [scrollView addSubview:btn];
                        
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                        deleteBtn.tag = i;
                        [deleteBtn addTarget:self action:@selector(deletePhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                    }
                } else {
                    for (NSInteger i = 0; i < self.imagePhotoURL.count; i++) {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(90 * i , 0, 80, 80);
                        btn.tag = i;
                        [btn addTarget:self action:@selector(showPhotoImgClick:) forControlEvents:UIControlEventTouchUpInside];
                        [btn setImage:[UIImage imageWithContentsOfFile:self.imagePhotoURL[i]] forState:UIControlStateNormal];
                        [scrollView addSubview:btn];
                        
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                        deleteBtn.tag = i;
                        [deleteBtn addTarget:self action:@selector(deletePhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        
                        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        addBtn.frame = CGRectMake(90 * (i + 1), 0, 80, 80);
                        addBtn.tag = JKImageTypeRecyceDevicePhoto;
                        [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
                        [addBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [scrollView addSubview:addBtn];
                    }
                }
            }
        } else {
            pictureLb.text = @"损坏设备照片";
            
            [cell addSubview:self.pictureScrollView];
            [self.pictureScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(pictureLb.mas_bottom);
                make.left.equalTo(cell.mas_left).offset(SCALE_SIZE(15));
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.height.mas_equalTo(80);
            }];
            
            self.pictureScrollView.contentSize = CGSizeMake(90 * self.model.brokenUrls.count, 80);
            
            for (NSInteger i = 0; i < self.model.brokenUrls.count; i++) {
                UIImageView *imgV = [[UIImageView alloc] init];
                imgV.frame = CGRectMake(90 * i , 0, 80, 80);
                imgV.userInteractionEnabled = YES;
                imgV.yy_imageURL = [NSURL URLWithString:self.model.brokenUrls[i]];
                imgV.contentMode = UIViewContentModeScaleAspectFit;
                [self.pictureScrollView addSubview:imgV];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0 , 0, 110, 110);
                btn.tag = i;
                [btn addTarget:self action:@selector(brokenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:btn];
            }
        }
        
    } else {
        [self.orderLb removeFromSuperview];
        UILabel *orderLb = [[UILabel alloc] init];
        orderLb.textColor = RGBHex(0x333333);
        orderLb.textAlignment = NSTextAlignmentLeft;
        orderLb.font = JKFont(14);
        [cell addSubview:orderLb];
        [orderLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.width.mas_offset(200);
            make.height.mas_equalTo(48);
        }];
        self.orderLb = orderLb;
        
        if (self.recyceType == JKRecyceIng) {
            orderLb.text = @"上传设备回收单";
            
            [self.orderScrollView removeFromSuperview];
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.backgroundColor = kWhiteColor;
            [cell addSubview:scrollView];
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(orderLb.mas_bottom).offset(5);
                make.left.equalTo(cell.mas_left).offset(15);
                make.right.equalTo(cell.mas_right).offset(-15);
                make.height.mas_equalTo(80);
            }];
            
            scrollView.contentSize = CGSizeMake(90 *(self.imageOrderURL.count +1), 80);
            self.orderScrollView = scrollView;
            
            if (self.imageOrderURL.count == 0) {
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(0, 0, 80, 80);
                addBtn.tag = JKImageTypeRecyceDeviceOrder;
                [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [scrollView addSubview:addBtn];
            } else {
                if (self.imageOrderURL.count == 9) {
                    for (NSInteger i = 0; i < self.imageOrderURL.count; i++) {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(90 * i , 0, 80, 80);
                        btn.tag = i;
                        [btn addTarget:self action:@selector(showOrderImgClick:) forControlEvents:UIControlEventTouchUpInside];
                        [btn setImage:[UIImage imageWithContentsOfFile:self.imageOrderURL[i]] forState:UIControlStateNormal];
                        [scrollView addSubview:btn];
                        
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                        deleteBtn.tag = i;
                        [deleteBtn addTarget:self action:@selector(deleteOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                    }
                } else {
                    for (NSInteger i = 0; i < self.imageOrderURL.count; i++) {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(90 * i , 0, 80, 80);
                        btn.tag = i;
                        [btn addTarget:self action:@selector(showOrderImgClick:) forControlEvents:UIControlEventTouchUpInside];
                        [btn setImage:[UIImage imageWithContentsOfFile:self.imageOrderURL[i]] forState:UIControlStateNormal];
                        [scrollView addSubview:btn];
                        
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.frame = CGRectMake(60, 0, 20, 20);
                        deleteBtn.tag = i;
                        [deleteBtn addTarget:self action:@selector(deleteOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn setImage:[UIImage imageNamed:@"ic_image_delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        
                        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        addBtn.frame = CGRectMake(90 * (i + 1), 0, 80, 80);
                        addBtn.tag = JKImageTypeRecyceDeviceOrder;
                        [addBtn setImage:[UIImage imageNamed:@"ic_image_add"] forState:UIControlStateNormal];
                        [addBtn addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [scrollView addSubview:addBtn];
                    }
                }
            }

        } else {
            orderLb.text = @"设备回收单";
            
            [cell addSubview:self.orderScrollView];
            [self.orderScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(orderLb.mas_bottom);
                make.left.equalTo(cell.mas_left).offset(SCALE_SIZE(15));
                make.right.equalTo(cell.mas_right).offset(-SCALE_SIZE(15));
                make.height.mas_equalTo(80);
            }];
            
            self.orderScrollView.contentSize = CGSizeMake(90 * self.model.recycleUrls.count, 80);
            
            for (NSInteger i = 0; i < self.model.recycleUrls.count; i++) {
                UIImageView *imgV = [[UIImageView alloc] init];
                imgV.frame = CGRectMake(90 * i , 0, 80, 80);
                imgV.userInteractionEnabled = YES;
                imgV.yy_imageURL = [NSURL URLWithString:self.model.recycleUrls[i]];
                imgV.contentMode = UIViewContentModeScaleAspectFit;
                [self.orderScrollView addSubview:imgV];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0 , 0, 110, 110);
                btn.tag = i;
                [btn addTarget:self action:@selector(recycleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:btn];
            }
        }
        
    }
    
    return cell;
}

- (void)photoBtnClick:(UIButton *)btn {
    [self.photoHelper showImagePickerControllerWithMaxCount:(9 - self.imagePhotoArr.count) WithViewController:[self View:self]];
}

- (void)brokenBtnClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.model.brokenUrls withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)showPhotoImgClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imagePhotoURL withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)deletePhotoBtnClick:(UIButton *)btn {
    [self.imagePhotoURL removeObjectAtIndex:btn.tag];
    [self.imagePhotoArr removeObjectAtIndex:btn.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

- (void)orderBtnClick:(UIButton *)btn {
    [self.orderHelper showImagePickerControllerWithMaxCount:(9 - self.imageOrderArr.count) WithViewController:[self View:self]];
}

- (void)recycleBtnClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.model.recycleUrls withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)showOrderImgClick:(UIButton *)btn {
    JKShowImagePagesView *sipV = [[JKShowImagePagesView alloc] init];
    sipV.frame = [UIScreen mainScreen].bounds;
    [sipV showGuideViewWithImages:self.imageOrderURL withTag:btn.tag];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: sipV];
}

- (void)deleteOrderBtnClick:(UIButton *)btn {
    [self.imageOrderURL removeObjectAtIndex:btn.tag];
    [self.imageOrderArr removeObjectAtIndex:btn.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- view对应的UIViewController
- (UIViewController *)View:(UIView *)view {
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

#pragma mark -- cell的分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    
    NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![text isEqualToString:tem]) {
        return NO;
    }
    
    return YES;
}

@end
