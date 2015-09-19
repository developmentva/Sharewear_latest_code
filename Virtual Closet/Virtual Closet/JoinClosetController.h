//
//  JoinClosetController.h
//  Virtual Closet
//
//  Created by Apple on 18/09/14.
//  Copyright (c) 2014 VibrantAppz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerParsing.h"
#import "Macro.h"
@interface JoinClosetController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *ClosetIDArray;;
    NSMutableArray *ClosetnameArray;
     NSMutableArray *CreatedAtArray;
     NSMutableArray *FBIDArray;
     NSMutableArray *ObjectIDArray;
     NSMutableArray *PrivacyType;
     NSMutableArray *SatatusArray;
     NSMutableArray *UpdatedArray;
     NSMutableArray *ClosetIconArray;
    NSMutableArray *TotalTickArray,*SearchTotalTickArray;
    NSMutableArray *SelectedClosetArrray;
    NSMutableArray *SearchArray;
    __weak IBOutlet UITextField *Searchtext;
    BOOL isSearching;
    NSString *searchString;
}
@property(nonatomic,strong)IBOutlet UITableView *Table;
@end
