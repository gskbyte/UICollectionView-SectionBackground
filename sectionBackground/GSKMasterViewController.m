//
//  GSKMasterViewController.m
//  sectionBackground
//
//  Created by Jose Alcalá Correa on 23.04.14.
//  Copyright (c) 2014 gskbyte. All rights reserved.
//

#import "GSKMasterViewController.h"

#import "GSKCell.h"
#import "GSKSectionBackground.h"

static const NSUInteger DefaultSections             = 5;
static const NSUInteger ItemsPerSectionMin   = 5;
static const NSUInteger ItemsPerSectionMax   = 5;



@interface GSKMasterViewController ()

@property (nonatomic, strong) NSMutableArray * sections; // array of arrays
@property (nonatomic, strong) NSArray * colors;
@property (nonatomic, strong) NSArray * sectionColors;

@end

@implementation GSKMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // initialize possible colors
    self.colors = @[UIColor.redColor, UIColor.blueColor, UIColor.greenColor, UIColor.yellowColor, UIColor.blackColor, UIColor.lightGrayColor, UIColor.orangeColor, UIColor.purpleColor, UIColor.cyanColor, UIColor.magentaColor];
    self.sectionColors = @[UIColor.brownColor, UIColor.darkGrayColor];
    
    // initialize model, aka add random cells
    self.sections = [NSMutableArray new];
    for(NSUInteger s=0; s<DefaultSections; ++s) {
        NSMutableArray * section = [NSMutableArray new];
        
        NSUInteger numItems = ItemsPerSectionMin + arc4random_uniform(ItemsPerSectionMax-ItemsPerSectionMin);
        for(int i=0; i<numItems; ++i) {
            NSUInteger colorIndex = arc4random_uniform(self.colors.count);
            UIColor * color = self.colors[colorIndex];
            [section addObject:color];
        }
        
        [self.sections addObject:section];
    }
    
    // add buttons to navigation bar
    UIBarButtonItem * addSectionButton = [[UIBarButtonItem alloc] initWithTitle:@"Section" style:UIBarButtonItemStyleBordered target:self action:@selector(addSection)];
    UIBarButtonItem *addItemButton = [[UIBarButtonItem alloc] initWithTitle:@"Item" style:UIBarButtonItemStyleBordered target:self action:@selector(addItemToLastSection)];
    
    self.navigationItem.rightBarButtonItems = @[addSectionButton, addItemButton];
    
    // register collection view cells
    [self.collectionView registerClass:[GSKCell class]
            forCellWithReuseIdentifier:NSStringFromClass([GSKCell class])];
    
    // add and configure layout
    const NSUInteger cellsPerLine = 3;
    const CGFloat viewWidth = self.collectionView.bounds.size.width;
    const CGFloat totalCellWidth = viewWidth * 0.9;
    const CGFloat cellWidth = totalCellWidth / cellsPerLine;
    const CGFloat cellHeight = cellWidth / 1.6180339887; // golden ratio
    const CGFloat spacing = (viewWidth - totalCellWidth) / (cellsPerLine+1) / 2;
    
    GSKSectionBackgroundFlowLayout * layout = [[GSKSectionBackgroundFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellWidth, cellHeight);
    layout.minimumLineSpacing = spacing;
    layout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    layout.minimumInteritemSpacing = 0;
    
    [self.collectionView registerClass:[GSKSectionBackground class]
            forSupplementaryViewOfKind:GSKElementKindSectionBackground
                   withReuseIdentifier:NSStringFromClass([GSKSectionBackground class])];
    
    self.collectionView.collectionViewLayout = layout;
}

- (void) addSection
{
    [self.sections addObject: [NSMutableArray new]];
    NSUInteger sectionIndex = self.sections.count-1;
    
    NSIndexSet * index = [NSIndexSet indexSetWithIndex:sectionIndex];
    [self.collectionView insertSections:index];
    
    [self addItemToLastSection];
}

- (void) addItemToLastSection
{
    NSUInteger colorIndex = arc4random_uniform(self.colors.count);
    UIColor * color = self.colors[colorIndex];
    
    NSUInteger sectionIndex = self.sections.count-1;
    NSMutableArray * section = self.sections[sectionIndex];
    NSUInteger itemIndex = section.count;
    [section addObject:color];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:itemIndex
                                                inSection:sectionIndex];
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.sections[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GSKCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GSKCell class])
                                                               forIndexPath:indexPath];
    cell.backgroundColor = self.sections[indexPath.section][indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    GSKSectionBackground * background = [collectionView dequeueReusableSupplementaryViewOfKind:GSKElementKindSectionBackground
                                                                                      withReuseIdentifier:NSStringFromClass([GSKSectionBackground class])
                                                                                             forIndexPath:indexPath];
    background.backgroundColor = self.sectionColors[indexPath.section%self.sectionColors.count];
    
    return background;
}

- (BOOL)     collectionView:(UICollectionView*)collectionView
displaysBackgroundAtSection:(NSUInteger)section
{
    return section%3!=0;
}


@end
