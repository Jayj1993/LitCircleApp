//
//  CommentsVC.m
//  LitCircle
//
//  Created by Afzal Sheikh on 1/9/17.
//  Copyright © 2017 Afzal Sheikh. All rights reserved.
//

#import "CommentsVC.h"
#import "CommentsTVC.h"
@interface CommentsVC (){
    
    UIActivityIndicatorView *spinner;
    BOOL isFetching;
    int offset;
    NSMutableArray *allComments;
    UIRefreshControl *refreshControl;
    
}

@end

@implementation CommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    allComments = [[NSMutableArray alloc]init];
    
    offset = 1;
    
    
    
    
    [self setUpControls];
    [self registerKeyBoardNotification];
    
    [self getAllEvents];
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView DataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return allComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"CCell";
    
    CommentsTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setCommentData:[allComments objectAtIndex:indexPath.row]];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1.0f;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleNone;
}


-(void)getAllEvents{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@/%i/%i",kServerURLGETComments,self.selectedPost.video_id,offset] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"what's here %@",json);
        
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            
            NSArray *Users = [json objectForKey:@"result"];
            if (Users.count>0) {
                
                for (int i=0; i<Users.count; i++) {
                    
                    LitComments *user = [[LitComments alloc]initWithDictionary:[Users objectAtIndex:i]];
                    [allComments addObject:user];
                    
                }
                
                
            }
           
            
            if (allComments.count>0) {
                offset = (int)allComments.count + 1;
                [self.tblComment reloadData];
                
            }
            
            
        }
        else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [Utilities showAlertView:@"" message:kErrorMessage];
        }
        
        [_txtComment becomeFirstResponder];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities showAlertView:@"" message:kErrorMessage];
        [_txtComment becomeFirstResponder];
    }];
    
    
    
    
}


-(void)loadMoreEvents{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@/%i/%i",kServerURLGETComments,self.selectedPost.video_id,offset] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"what's here %@",json);
        
        if (offset==1) {
            
            [refreshControl endRefreshing];
            [allComments removeAllObjects];
            
        }
        else{
            
            isFetching = NO;
            [spinner stopAnimating];
            [spinner setHidden:YES];
            self.tblComment.tableFooterView = nil;
        }
        
        
        
        
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            
            
            NSArray *Users = [json objectForKey:@"result"];
            if (Users.count>0) {
                
                
                
                for (int i=0; i<Users.count; i++) {
                    
                    LitComments *user = [[LitComments alloc]initWithDictionary:[Users objectAtIndex:i]];
                    [allComments addObject:user];
                    
                }
                
                if (allComments.count>0) {
                    offset = (int)allComments.count + 1;
                    [self.tblComment reloadData];
                }
                
                
            }
            
            
            
            
        }
        else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [Utilities showAlertView:@"" message:kErrorMessage];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utilities showAlertView:@"" message:kErrorMessage];
    }];
    
    
    
    
}


#pragma mark - Methods -
-(void)setUpControls{
    
    spinner   = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    
    [self.tblComment addSubview:refreshControl];
    [refreshControl addTarget:self
                       action:@selector(getFreshData)
             forControlEvents:UIControlEventValueChanged];
}

-(void)getFreshData{
    
    offset = 1;
    [self loadMoreEvents];
    
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
    
    CGPoint newoffset = self.tblComment.contentOffset;
    CGRect bounds = self.tblComment.bounds;
    CGSize size = self.tblComment.contentSize;
    UIEdgeInsets inset = self.tblComment.contentInset;
    
    float y = newoffset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    if(y > h + reload_distance) {
        
        if (offset<10) {
            
            return;
        }
        
        if (isFetching==NO) {
            
            NSLog(@"load more data");
            
            spinner.frame=CGRectMake(0, 0, 310, 44);
            [spinner startAnimating];
            [spinner setHidden:NO];
            self.tblComment.tableFooterView = spinner;
            isFetching = YES;
            [self loadMoreEvents];
            
            
            
            
        }
        
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LitComments *cmment = [allComments objectAtIndex:indexPath.row];
    float size = [Utilities getLabelHeight:cmment.comments];
    return size + 50;

}


- (IBAction)btnBackPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSendPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([_txtComment.text isEqualToString:@"Write a Comment..."] || [_txtComment.text isEqualToString:@""]) {
        
        [Utilities showAlertView:@"" message:@"Please enter some text to comment"];
        return;
    }
    LitComments *comment = [[LitComments alloc]init];
    comment.first_name = [SharedManager sharedManager].user.first_name;
    comment.last_name = [SharedManager sharedManager].user.last_name;
    comment.profile_image = [SharedManager sharedManager].user.profile_image;
    comment.comments = _txtComment.text;
    
    [allComments addObject:comment];
    
    if (allComments.count>1) {
        
        [allComments exchangeObjectAtIndex:0 withObjectAtIndex:[allComments indexOfObject:comment]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[allComments indexOfObject:comment] inSection:0];
        [self.tblComment beginUpdates];
        [self.tblComment
         insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationBottom];
        [self.tblComment endUpdates];
    }
    else{
        
        [self.tblComment reloadData];
    }
    
    
    [self postComment];
    
    
}
-(void)postComment{
    
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID] forKey:@"user_id"];
    [dict setObject:[NSNumber numberWithInt:self.selectedPost.video_id] forKey:@"video_id"];
    [dict setObject:_txtComment.text forKey:@"comments"];
    
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:kServerURLPostComment parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        
        
        if ([[json objectForKey:@"status"]boolValue]==YES) {
            
           
            
        }
        else{
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
       
    }];

   _txtComment.text = @"";
    
}
-(void)registerKeyBoardNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"what's here %f",kbSize.height);
    
    self.bottomConstraint.constant = kbSize.height;
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    self.bottomConstraint.constant = 0.0f;
    
}


#pragma mark - UITextView Delegate -


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([_txtComment.text isEqualToString:@"Write a Comment..."]) {
        _txtComment.text = @"";
        _txtComment.textColor = [UIColor blackColor];
    }
    
    
    return YES;
}



- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if(_txtComment.text.length == 0){
        _txtComment.textColor = [UIColor darkGrayColor];
        _txtComment.text = @"Write a Comment...";
        [_txtComment resignFirstResponder];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)activeScrollView {
    
    [_txtComment resignFirstResponder];
        
    
}



@end
