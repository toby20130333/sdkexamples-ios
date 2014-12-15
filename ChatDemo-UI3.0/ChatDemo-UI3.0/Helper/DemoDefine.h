//
//  DemoDefine.h
//  ChatDemo-UI3.0
//
//  Created by dhcdht on 14-11-13.
//  Copyright (c) 2014年 easemob.com. All rights reserved.
//

#ifndef ChatDemo_UI3_0_DemoDefine_h
#define ChatDemo_UI3_0_DemoDefine_h

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define KNOTIFICATION_APPLYCHANGE @"applyChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]


#endif
