//
//  PickerViewController.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "PickerViewController.h"
#import "CommonDefine.h"
#import "MultiPhotoTableViewCell.h"
#import "ImageMultiPhotoModel.h"
#import "InfoAnnexInfoModel.h"

@interface PickerViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *selectedPhotosDict; // 选择后的图片

@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    ImageMultiPhotoModel *model = [ImageMultiPhotoModel new];
    model.url = @"https://n.sinaimg.cn/tech/transform/650/w436h214/20190428/F3fs-hwfpcxm6920745.gif";
    model.typeId = 12000;
    NSMutableArray *items = [NSMutableArray arrayWithObjects:model, nil];
    [self.selectedPhotosDict setObject:items forKey:@"12000"];
}

-(void)initView {
    self.view.backgroundColor = RGB(240, 240, 240);
    self.tableView.frame = CGRectMake(0, 1, KScreenWidth, KScreenHeight-kTopHeight-BottomHeight-TopHeight-50);
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[MultiPhotoTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (void)initData {
    for (int i=0; i< 6; i++) {
        InfoAnnexInfoModel *model = [InfoAnnexInfoModel new];
        model.ID = 12000+i;
        model.displayName = NSStringFormat(@"%zd",model.ID);
        model.isRequired  = i / 2;
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoAnnexInfoModel *model = self.dataArray[indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%ld", (long)model.ID];
    NSArray *selectedPhotosArray = self.selectedPhotosDict[key];
    NSInteger lineCount = 1;
    CGFloat cellHeight = (KScreenWidth - 2 * 4 - 15 * 2) / 3 + 9;
    cellHeight = (cellHeight/4) * 3;
    lineCount = (selectedPhotosArray.count) / 3 + 1;
    CGFloat height = cellHeight * lineCount + 37;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoAnnexInfoModel *model = self.dataArray[indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%ld", (long)model.ID];
    // 配置cell
    MultiPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleLable.attributedText = [self isRequiredWithModel:model];
    cell.photosArray = self.selectedPhotosDict[key];
    cell.parentViewController = self;
    cell.isEditing = self.isCanEditing;
    // 允许选择视频
    cell.canSelectVideo = YES;
    // 设置本地图片可选取的数量,网络图片/本地图片不区分使用上面的设置方式，区分使用下面的
    cell.imageMaxCount = 999;
    kWeakSelf(self)
    cell.imageCountChange = ^(NSMutableArray *imageArray) {
        for (ImageMultiPhotoModel *photoModel in imageArray) {
            photoModel.typeId = model.ID;
        }
        // 保存数据
        NSString *key = [NSString stringWithFormat:@"%ld", (long)model.ID];
        [weakself.selectedPhotosDict setValue:imageArray forKey:key];
        // 刷新对应cell
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}

#pragma mark - Setting - -
- (NSMutableAttributedString *)isRequiredWithModel:(InfoAnnexInfoModel *)model {
    if(model.isRequired){
        NSString *titleString = [NSString stringWithFormat:@"*%@",model.displayName];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:titleString];
        NSRange markRange = NSMakeRange(0, 1);
        // 更改字符颜色
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:markRange];
        return attString;
    }
    return [[NSMutableAttributedString alloc]initWithString:model.displayName];
}


#pragma mark - getter
- (NSMutableDictionary *)selectedPhotosDict {
    if(!_selectedPhotosDict){
        _selectedPhotosDict = [NSMutableDictionary dictionary];
    }
    return _selectedPhotosDict;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)selectedPhotosArray {
    NSMutableArray *photosArray = [NSMutableArray array];
    for (NSArray *items in _selectedPhotosDict.allValues) {
        [photosArray addObjectsFromArray:items];
    }
    // 校验必填项
    BOOL allRequired = YES;
    for (int i = 0; i < self.dataArray.count; i ++) {
        InfoAnnexInfoModel *model = self.dataArray[i];
        if(model.isRequired){
            NSString *key = [NSString stringWithFormat:@"%zd", model.ID];
            NSArray *imagesArray = [self.selectedPhotosDict valueForKey:key];
            if(!imagesArray || imagesArray.count < 1){
                allRequired = NO;
                break;
            }
        }
    }
    return photosArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
