//
//  GSKSectionBackgroundFlowLayout.m
//  sectionBackground
//
//  Created by Jose Alcalá Correa on 23.04.14.
//  Copyright (c) 2014 gskbyte. All rights reserved.
//

#import "GSKSectionBackgroundFlowLayout.h"

@interface GSKSectionBackgroundFlowLayout ()

@end

@implementation GSKSectionBackgroundFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    
    // 1. get visible sections
    NSMutableSet * displayedSections = [NSMutableSet new];
    NSInteger lastIndex = -1;
    for(UICollectionViewLayoutAttributes * attr in attributes) {
        lastIndex = attr.indexPath.section;
        [displayedSections addObject:@(lastIndex)];
    }
    
    // 2. compute rects for sections that display it, and add attributes for those that intersect
    for(NSNumber * section in displayedSections) {
        BOOL displaysBackground = YES;
        if([self.collectionView.delegate respondsToSelector:@selector(collectionView:displaysBackgroundAtSection:)]) {
            id<GSKSectionBackgroundFlowLayoutDelegate> delegate = (id<GSKSectionBackgroundFlowLayoutDelegate>) self.collectionView.delegate;
            displaysBackground = [delegate collectionView:self.collectionView displaysBackgroundAtSection:section.unsignedIntegerValue];
        }
        UICollectionViewLayoutAttributes * attr = [self layoutAttributesForBackgroundAtSection:section.unsignedIntegerValue];
        [attributes addObject:attr];
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:GSKElementKindSectionBackground]) {
        return [self layoutAttributesForBackgroundAtSection:indexPath.section];
    } else {
        return [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForBackgroundAtSection:(NSUInteger)section
{
    NSIndexPath * indexPath =[NSIndexPath indexPathForItem:0
                                                 inSection:section];
    UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:GSKElementKindSectionBackground
                                                                                                             withIndexPath:indexPath];
    attr.hidden = NO;
    attr.zIndex = -1; // to send them behind
    
    UICollectionViewLayoutAttributes * firstAttr = [self layoutAttributesForItemAtIndexPath:indexPath]; // it will be already (section,0)
    
    CGRect frame;
    frame.origin.x = firstAttr.frame.origin.x - self.sectionInset.left;
    frame.origin.y = firstAttr.frame.origin.y - self.sectionInset.top;
    
    frame.size.width = self.collectionView.bounds.size.width;
    
    NSUInteger numItems = [self.collectionView numberOfItemsInSection:section];
    
    CGFloat cellsPerLine = floorf(self.collectionView.bounds.size.width / self.itemSize.width);
    NSUInteger numLines = ceilf(numItems / (float)cellsPerLine);
    
    frame.size.height = numLines * firstAttr.size.height + (numLines-1)*self.minimumLineSpacing +
    self.sectionInset.top + self.sectionInset.bottom;
    
    attr.frame = frame;
    
    return attr;
}

@end
