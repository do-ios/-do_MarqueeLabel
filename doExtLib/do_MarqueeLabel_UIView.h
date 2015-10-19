//
//  do_MarqueeLabel_View.h
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "do_MarqueeLabel_IView.h"
#import "do_MarqueeLabel_UIModel.h"
#import "doIUIModuleView.h"

@interface do_MarqueeLabel_UIView : UIView<do_MarqueeLabel_IView, doIUIModuleView>
//可根据具体实现替换UIView
{
	@private
		__weak do_MarqueeLabel_UIModel *_model;
}

@end
