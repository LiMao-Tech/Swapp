//
//  ViewController.m
//  Swapp
//
//  Created by Gawain Tsao on 7/6/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize messageText, sendButton, messageList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self) = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        lastId = 0;
        chatParser =NULL;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    messageList.dataSource = self;
    messageList.delegate = self;
    [self getNewMessages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getNewMessages {
    NSString *url = [NSString stringWithFormat:@"http://www.code-desire.com.tw/LiMao/Upload/Tuantuan/messages.php?past=%d",lastId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];// arc, autorelease omit
                                    [request setURL:[NSURL URLWithString:url]];
                                    [request setHTTPMethod:@"GET"];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(conn){
        receivedData = [NSMutableData data];
    }
//    else{
//        
//    }
}
// three event handlers
- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{//starts XML parser
    if (messages == nil) {
        messages = [[NSMutableArray alloc] init];
    }
    
    chatParser = [[NSXMLParser alloc] initWithData:receivedData];
    [chatParser setDelegate:self];
    [chatParser parse];
    
    [messageList reloadData];
    
    //调用对象消息
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [self methodSignatureForSelector: @selector(timerCallback)]];
    [invocation setTarget:self];
    [invocation setSelector: @selector(timerCallback)];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 invocation:invocation repeats:NO];
}

- (void)timerCallback {
    [self getNewMessages];
}
/*
 chatlist XML
 
 <chat>
    <message added="2010-09-09 07:57:34" id ="8">
        <user>jack</user>
        <text>this is a text</text>
    </message>
 </chat>
 
 */
//遍历XML节点
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"message"]){
        msgAdded = [attributeDict objectForKey:@"added"];
        msgId = [[attributeDict objectForKey:@"id"] intValue];
        msgUser = [[NSMutableString alloc]init];
        msgText = [[NSMutableString alloc]init];
        inUser = NO;
        inText = NO;
    }
    if([elementName isEqualToString:@"user"]){
        inUser = YES;
    }
    if([elementName isEqualToString:@"Text"]){
        inText = YES;
    }
}
//节点有值，call
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(inUser){
        [msgUser appendString:string];
    }
    if(inText){
        [msgText appendString:string];
    }
}
//遇到结束标记，call
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"message"]){
        [messages addObject:[NSDictionary dictionaryWithObjectsAndKeys:msgAdded, @"added", msgUser, @"user", msgText, @"text", nil]];
        
        lastId = msgId;
    }
    if ([elementName isEqualToString:@"user"]) {
        inUser = NO;
    }
    if ([elementName isEqualToString:@"text"]) {
        inText = NO;
    }
}
//message display
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section{
    return (messages == nil) ? 0 : [messages count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[self.messageList dequeueReusableCellWithIdentifier:@"ChatListItem"];
    if(cell == nil){
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:@"ChatListItem" owner:self options:nil];
        cell = (UITableViewCell *)[nib objectAtIndex:0];
    }
    
    NSDictionary *itemAtIndex = (NSDictionary *)[messages objectAtIndex:indexPath.row];
    UILabel *textLabel = (UILabel *)[cell viewWithTag:1];
    textLabel.text = [itemAtIndex objectForKey:@"text"];
    UILabel *userLabel = (UILabel *)[cell viewWithTag:2];
    userLabel.text = [itemAtIndex objectForKey:@"user"];

    return cell;
}
//message send function  worked!
-(IBAction)sendClicked:(id)sender{
    if ([messageText.text length] > 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *url =[NSString stringWithFormat:@"http://www.code-desire.com.tw/LiMao/Upload/Tuantuan/add.php"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"post"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"user=%@&message=%@",[defaults stringForKey:@"user_preference"],messageText.text]dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        
        NSHTTPURLResponse *response = nil;
        NSError *error = [[NSError alloc]init];
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        [self getNewMessages];
    }
    
    messageText.text = @"";
}

@end
