//
//  CallSessionViewController.m
//  ChatDemo-UI2.0
//
//  Created by dhcdht on 14-10-29.
//  Copyright (c) 2014年 dhcdht. All rights reserved.
//

#import "CallSessionViewController.h"

#define kAlertViewTag_Close 1000

@interface CallSessionViewController ()<UIAlertViewDelegate, ICallManagerDelegate>
{
    NSString *_chatter;
    
    int _callType;
    UIImageView *_bgImageView;
    UILabel *_statusLabel;
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    
    UIButton *_silenceButton;
    UILabel *_silenceLabel;
    UIButton *_speakerOutButton;
    UILabel *_outLabel;
    UIButton *_hangupButton;
    UIButton *_answerButton;
}

@property (strong, nonatomic) EMCallSession *callSession;

@end

@implementation CallSessionViewController

@synthesize callSession = _callSession;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _callType = CallNone;
        _callSession = nil;
        
        [[EMSDKFull sharedInstance].callManager addDelegate:self delegateQueue:nil];
    }
    return self;
}

- (instancetype)initCallOutWithChatter:(NSString *)chatter
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _callType = CallOut;
        _chatter = chatter;
    }
    
    return self;
}

- (instancetype)initCallInWithSession:(EMCallSession *)callSession
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _callType = CallIn;
        _chatter = callSession.chatter;
        _callSession = callSession;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_callType == CallOut) {
        [self _callOutWithChatter:_chatter];
    }
    [self _setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[EMSDKFull sharedInstance].callManager removeDelegate:self];
}

#pragma mark - private

- (void)_layouSubviews
{
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bgImageView.contentMode = UIViewContentModeScaleToFill;
    _bgImageView.image = [UIImage imageNamed:@"callBg.png"];
    [self.view addSubview:_bgImageView];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 80)];
    _statusLabel.font = [UIFont systemFontOfSize:15.0];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_statusLabel];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50) / 2, CGRectGetMaxY(_statusLabel.frame) + 20, 50, 50)];
    _headerImageView.image = [UIImage imageNamed:@"chatListCellHead"];
    [self.view addSubview:_headerImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerImageView.frame) + 5, self.view.frame.size.width, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:14.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_nameLabel];
    
    CGFloat tmpWidth = self.view.frame.size.width / 2;
    _silenceButton = [[UIButton alloc] initWithFrame:CGRectMake((tmpWidth - 40) / 2, self.view.frame.size.height - 230, 40, 40)];
    [_silenceButton setImage:[UIImage imageNamed:@"call_silence"] forState:UIControlStateNormal];
    [_silenceButton setImage:[UIImage imageNamed:@"call_silence_h"] forState:UIControlStateSelected];
    [_silenceButton addTarget:self action:@selector(silenceAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_silenceButton];
    
    _silenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_silenceButton.frame), CGRectGetMaxY(_silenceButton.frame) + 5, 40, 20)];
    _silenceLabel.backgroundColor = [UIColor clearColor];
    _silenceLabel.textColor = [UIColor whiteColor];
    _silenceLabel.font = [UIFont systemFontOfSize:13.0];
    _silenceLabel.textAlignment = NSTextAlignmentCenter;
    _silenceLabel.text = @"静音";
    [self.view addSubview:_silenceLabel];
    
    _speakerOutButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth + (tmpWidth - 40) / 2, self.view.frame.size.height - 230, 40, 40)];
    [_speakerOutButton setImage:[UIImage imageNamed:@"call_out"] forState:UIControlStateNormal];
    [_speakerOutButton setImage:[UIImage imageNamed:@"call_out_h"] forState:UIControlStateSelected];
    [_speakerOutButton addTarget:self action:@selector(speakerOutAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_speakerOutButton];
    
    _outLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_speakerOutButton.frame), CGRectGetMaxY(_speakerOutButton.frame) + 5, 40, 20)];
    _outLabel.backgroundColor = [UIColor clearColor];
    _outLabel.textColor = [UIColor whiteColor];
    _outLabel.font = [UIFont systemFontOfSize:13.0];
    _outLabel.textAlignment = NSTextAlignmentCenter;
    _outLabel.text = @"免提";
    [self.view addSubview:_outLabel];
    
    _hangupButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, self.view.frame.size.height - 120, 200, 40)];
    [_hangupButton setTitle:@"挂断" forState:UIControlStateNormal];
    [_hangupButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];;
    [_hangupButton addTarget:self action:@selector(hangupAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hangupButton];
    
    _answerButton = [[UIButton alloc] initWithFrame:CGRectMake(tmpWidth + (tmpWidth - 100) / 2, self.view.frame.size.height - 120, 100, 40)];
    [_answerButton setTitle:@"接听" forState:UIControlStateNormal];
    [_answerButton setBackgroundColor:[UIColor colorWithRed:191 / 255.0 green:48 / 255.0 blue:49 / 255.0 alpha:1.0]];;
    [_answerButton addTarget:self action:@selector(answerAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)_setupSubviews
{
    [self _layouSubviews];
    
    if (_callType == CallIn) {
        _statusLabel.text = @"等待接听...";
        _nameLabel.text = _chatter;
        
        CGFloat tmpWidth = self.view.frame.size.width / 2;
        _hangupButton.frame = CGRectMake((tmpWidth - 100) / 2, self.view.frame.size.height - 120, 100, 40);
        [self.view addSubview:_answerButton];
        _silenceButton.hidden = YES;
        _silenceLabel.hidden = YES;
        _speakerOutButton.hidden = YES;
        _outLabel.hidden = YES;
    }
    else if (_callType == CallOut)
    {
        _statusLabel.text = @"正在建立连接...";
        _nameLabel.text = _chatter;
        
        [_answerButton removeFromSuperview];
        _hangupButton.frame = CGRectMake((self.view.frame.size.width - 200) / 2, self.view.frame.size.height - 120, 200, 40);
        _silenceButton.hidden = NO;
        _silenceLabel.hidden = NO;
        _speakerOutButton.hidden = NO;
        _outLabel.hidden = NO;
    }
    
    
    if (_callSession) {
//        _statusLabel.text = @"通话进行中...";
//        _nameLabel.text = _chatter;
//        
//        [_answerButton removeFromSuperview];
//        _hangupButton.frame = CGRectMake((self.view.frame.size.width - 200) / 2, self.view.frame.size.height - 120, 200, 40);
//        _silenceButton.hidden = NO;
//        _silenceLabel.hidden = NO;
//        _speakerOutButton.hidden = NO;
//        _outLabel.hidden = NO;
    }
}

- (void)_callOutWithChatter:(NSString *)chatter
{
    EMError *error = nil;
    _callSession = [[EMSDKFull sharedInstance].callManager asyncCallAudioWithChatter:chatter timeout:100 error:&error];
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:error.description delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = kAlertViewTag_Close;
        [alertView show];
    }
}

- (void)_close
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callControllerClose" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertViewTag_Close)
    {
        [self _close];
    }
}

#pragma mark - ICallManagerDelegate

- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
{
    if (callSession.status == eCallSessionStatusIncoming)
    {
        [self showHint:@"有新的语音请求，当前正在通话中，自动拒绝"];
        
        [[EMSDKFull sharedInstance].callManager asyncRejectCallSessionWithId:callSession.sessionId chatter:callSession.chatter];
        
    }
    else if ([_callSession.sessionId isEqualToString:callSession.sessionId])
    {
        UIAlertView *alertView = nil;
        if (error) {
            _statusLabel.text = @"连接失败";
            alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:error.description delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertView.tag = kAlertViewTag_Close;
            [alertView show];
        }
        else{
            if (callSession.status == eCallSessionStatusDisconnected) {
                if (reason == eCallReason_Hangup || reason == eCallReason_Reject)
                {
                    _statusLabel.text = @"通话已挂断";
                    
                    [_answerButton removeFromSuperview];
                    [_hangupButton removeFromSuperview];
                    [self _close];
                }
            }
            
            if (reason == eCallReason_Null) {
                if(callSession.status == eCallSessionStatusIncoming)
                {
                    [self showHint:@"正在通话，自动拒接"];
                    
                    //TODO
                    
                }
                else if (callSession.status == eCallSessionStatusConnecting)
                {
                    [self _setupSubviews];
                }
            }
            else
            {
                
            }
        }
    }
}

#pragma mark - action

- (void)silenceAction:(id)sender
{
    _silenceButton.selected = !_silenceButton.selected;
}

- (void)speakerOutAction:(id)sender
{
    _speakerOutButton.selected = !_speakerOutButton.selected;
}

- (void)hangupAction:(id)sender
{
    [[EMSDKFull sharedInstance].callManager asyncRejectCallSessionWithId:_callSession.sessionId chatter:_callSession.chatter];
    
    [self _close];
}

- (void)answerAction:(id)sender
{
    [[EMSDKFull sharedInstance].callManager asyncAcceptCallSessionWithId:_callSession.sessionId chatter:_callSession.chatter];
}

@end
