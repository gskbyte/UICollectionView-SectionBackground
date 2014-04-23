//
//  GSKCell.m
//  sectionBackground
//
//  Created by Jose Alcalá Correa on 23.04.14.
//  Copyright (c) 2014 gskbyte. All rights reserved.
//

#import "GSKCell.h"

@implementation GSKCell

- (void) didMoveToWindow
{
    [super didMoveToWindow];
    self.layer.cornerRadius = 5;
}

@end
