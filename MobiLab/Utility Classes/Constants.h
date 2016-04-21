//
//  Constants.h
//  MobiLab
//
//  Created by Ahmet Abak on 16/04/16.
//  Copyright © 2016 Ahmet Abak. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define CLIENT_ID       @"e53a5ab47eaa632"
#define CLIENT_SECRET   @"e923b929832a26c4712b368fb281112b380ec734"

#define IS_LANDSCAPE (([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) ? YES : NO)

typedef enum SectionTYPE
{
    ST_HOT,
    ST_TOP,
    ST_USER
} SectionTYPE;
#endif /* Constants_h */
