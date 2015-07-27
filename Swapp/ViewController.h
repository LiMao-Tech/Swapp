//
//  ViewController.h
//  Swapp
//
//  Created by Gawain Tsao on 7/6/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>{//drive the message display; get called back
    //UI elements
    IBOutlet UITextField *messageText;
    IBOutlet UIButton *sendButton;
    IBOutlet UITableView *messageList;
    //XML buffer
    NSMutableData *receivedData;
    NSMutableArray *messages;
    int lastId;
    //watchdog
    NSTimer *timer;
    //XML parser variables; holds lots of states
    NSXMLParser *chatParser;
    NSString *msgAdded;
    NSMutableString *msgUser;
    NSMutableString *msgText;
    int msgId;
    Boolean inText;
    Boolean inUser;
}
//property
@property (nonatomic,strong) UITextField *messageText;
@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) UITableView *messageList;
//click handler
- (IBAction)sendClicked:(id)sender;

@end

