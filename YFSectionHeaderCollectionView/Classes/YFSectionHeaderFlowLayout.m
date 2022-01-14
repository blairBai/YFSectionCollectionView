//
//  YFSectionHeaderFlowLayout.m
//  FBSnapshotTestCase
//
//  Created by BYF on 1/14/22.
//

#import "YFSectionHeaderFlowLayout.h"

@implementation YFSectionHeaderFlowLayout

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray *superArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    NSMutableIndexSet *noneHeaderSections = [NSMutableIndexSet indexSet];
    
    for (UICollectionViewLayoutAttributes *attributes in superArray)
    {
        
        if (attributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            [noneHeaderSections addIndex:attributes.indexPath.section];
        }
    }
    
    //遍历superArray，将当前屏幕中拥有的header的section从数组中移除，得到一个当前
    for (UICollectionViewLayoutAttributes *attributes in superArray)
    {
        //如果当前的元素是一个header，将header所在的section从数组中移除
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
        {
            [noneHeaderSections removeIndex:attributes.indexPath.section];
        }
    }
    
    //遍历当前屏幕中没有header的section数组
    [noneHeaderSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        //如果当前分区确实有因为离开屏幕而被系统回收的header
        if (attributes)
        {
            //将该header结构信息重新加入到superArray中去
            [superArray addObject:attributes];
        }
    }];
    
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        
        //如果当前item是header
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
        {
            //得到当前header所在分区的cell的数量
            NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:attributes.indexPath.section];
            //得到第一个item的indexPath
            NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:attributes.indexPath.section];
            //得到最后一个item的indexPath
            NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:MAX(0, numberOfItemsInSection-1) inSection:attributes.indexPath.section];
            //得到第一个item和最后一个item的结构信息
            UICollectionViewLayoutAttributes *firstItemAttributes, *lastItemAttributes;
            if (numberOfItemsInSection>0)
            {
                // cell有值
                firstItemAttributes = [self layoutAttributesForItemAtIndexPath:firstItemIndexPath];
                lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastItemIndexPath];
            }else
            {
                // 没有cell
                firstItemAttributes = [UICollectionViewLayoutAttributes new];
                CGFloat y = CGRectGetMaxY(attributes.frame)+self.sectionInset.top;
                firstItemAttributes.frame = CGRectMake(0, y, 0, 0);
                lastItemAttributes = firstItemAttributes;
            }
            
            //获取当前header的frame
            CGRect rect = attributes.frame;
            
            CGFloat offset = self.collectionView.contentOffset.y;
            
            CGFloat headerY = firstItemAttributes.frame.origin.y - rect.size.height - self.sectionInset.top;
            
            CGFloat maxY = MAX(offset,headerY);
            
            CGFloat headerMissingY = CGRectGetMaxY(lastItemAttributes.frame) + self.sectionInset.bottom - rect.size.height;
            
            rect.origin.y = MIN(maxY,headerMissingY);
            
            attributes.frame = rect;
            
            attributes.zIndex = 7;
        }
    }
    
    return [superArray copy];
    
}

//return YES;表示一旦滑动就实时调用上面这个layoutAttributesForElementsInRect:方法
- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}

@end
