//
//  Constants.h
//  MobiLab
//
//  Created by Ahmet Abak on 16/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define CLIENT_ID       @"your-id"
#define CLIENT_SECRET   @"your-secret"

#define IS_LANDSCAPE (([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) ? YES : NO)

typedef enum SectionTYPE
{
    ST_HOT,
    ST_TOP,
    ST_USER
} SectionTYPE;
#endif /* Constants_h */
