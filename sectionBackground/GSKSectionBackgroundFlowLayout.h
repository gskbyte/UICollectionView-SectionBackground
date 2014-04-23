//
//  GSKSectionBackgroundFlowLayout.h
//  sectionBackground
//
//  Created by Jose Alcalá Correa on 23.04.14.
//  Copyright (c) 2014 gskbyte. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const GSKElementKindSectionBackground = @"GSKElementKindSectionBackground";

@interface GSKSectionBackgroundFlowLayout : UICollectionViewFlowLayout

@end


@protocol GSKSectionBackgroundFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

@optional

// NO by default
- (BOOL)     collectionView:(UICollectionView*)collectionView
displaysBackgroundAtSection:(NSUInteger)section;

@end