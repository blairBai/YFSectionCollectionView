//
//  YFViewController.m
//  YFSectionHeaderCollectionView
//
//  Created by baiyunfei on 01/14/2022.
//  Copyright (c) 2022 baiyunfei. All rights reserved.
//

#import "YFViewController.h"
// util
#import "YFSectionHeaderFlowLayout.h"

#import "Masonry.h"

#pragma mark - Model

@interface YFSectionModel : NSObject

@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, strong) NSArray *list;

@end

@implementation YFSectionModel

@end

#pragma mark - header

@interface YFHeaderView : UICollectionReusableView

@property (nonatomic, copy) void(^on_clickBlock)(void);

// view
@property (nonatomic, strong) UILabel *lbTitle;

@end

@implementation YFHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addGestureRecognizer:({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(on_click)];
            tap;
        })];
    }
    return self;
}

// TODO: Event
- (void)on_click {
    
    if (self.on_clickBlock) {
        self.on_clickBlock();
    }
}

// TODO: Getter
- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [UILabel new];
        _lbTitle.font = [UIFont systemFontOfSize:18];
        _lbTitle.textColor = [UIColor blackColor];
        
        [self addSubview:_lbTitle];
        [_lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
        }];
    }
    
    return _lbTitle;
}

@end

#pragma mark - Cell

@interface YFCollectionViewCell : UICollectionViewCell

// view
@property (nonatomic, strong) UILabel *lbTitle;

@end

@implementation YFCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

// TODO: Getter
- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [UILabel new];
        _lbTitle.font = [UIFont systemFontOfSize:14];
        _lbTitle.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:_lbTitle];
        [_lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
        }];
    }
    
    return _lbTitle;
}

@end

#pragma mark - Main

@interface YFViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

// view
@property (nonatomic, strong) UICollectionView *cvMain;

// data
@property (nonatomic, strong) NSArray<YFSectionModel *> *data;

@end

@implementation YFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Demo";
    
    [self.view addSubview:self.cvMain];
    [self.cvMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([[UIApplication sharedApplication] statusBarFrame].size.height + 44.f);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

// TODO: UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    YFSectionModel *model = [self.data objectAtIndex:section];
    
    return model.isExpand ? model.list.count : 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YFCollectionViewCell.class) forIndexPath:indexPath];
    
    cell.lbTitle.text = [NSString stringWithFormat:@"cell - section:%ld row:%ld", indexPath.section, indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        YFHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YFHeaderView.class) forIndexPath:indexPath];
        
        __weak typeof(self) weakSelf = self;
        header.on_clickBlock = ^{
            NSInteger section = indexPath.section;
            YFSectionModel *model = [weakSelf.data objectAtIndex:section];
            model.isExpand = !model.isExpand;
            [weakSelf.cvMain reloadData];
        };
        
        header.backgroundColor = [UIColor grayColor];
        header.lbTitle.text = [NSString stringWithFormat:@"header - section:%ld", indexPath.section];
        
        return header;
    }
    
    return nil;
}

// TODO: UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 40);
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 50);
}

// TODO: Getter
- (UICollectionView *)cvMain {
    if (!_cvMain) {
        
        YFSectionHeaderFlowLayout *layout = [[YFSectionHeaderFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _cvMain = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _cvMain.delegate = self;
        _cvMain.dataSource = self;
        _cvMain.backgroundColor = [UIColor clearColor];
        
        // regitster
        // cell
        [_cvMain registerClass:YFCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(YFCollectionViewCell.class)];
        
        // header
        [_cvMain registerClass:YFHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YFHeaderView.class)];
    }
    return _cvMain;
}

- (NSArray<YFSectionModel *> *)data {
    if (!_data) {
        _data = ({
            NSMutableArray *arr = [NSMutableArray array];
            
            for (int i = 0; i < 7; i++) {
                YFSectionModel *model = [YFSectionModel new];
                model.isExpand = NO;
                model.list = @[@"", @"", @"", @"", @"", @"", @"", @"", @"", @""];
                
                [arr addObject:model];
            }
            
            arr;
        });
    }
    return _data;
}

@end
