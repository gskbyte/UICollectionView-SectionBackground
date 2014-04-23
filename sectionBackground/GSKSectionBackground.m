//
//  GSKSectionBackground.m
//  sectionBackground
//
//  Created by Jose Alcalá Correa on 23.04.14.
//  Copyright (c) 2014 gskbyte. All rights reserved.
//

#import "GSKSectionBackground.h"

@implementation GSKSectionBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor brownColor];
        self.layer.cornerRadius = 7.5;
    }
    return self;
}

@end
