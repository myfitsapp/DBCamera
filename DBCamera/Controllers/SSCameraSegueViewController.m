//
//  SSCameraSegueViewController.m
//  DBCamera
//
//  Created by shams ahmed on 28/10/14.
//  Copyright (c) 2014 PSSD - Daniele Bogo. All rights reserved.
//

#import "SSCameraSegueViewController.h"

static NSString *SSCaptionText = @"Add a caption for this picture?";

@interface SSCameraSegueViewController () <UITextViewDelegate>

- (void)saveImageWithMetaData;
- (BOOL)addCaption;

@end

@implementation SSCameraSegueViewController


#pragma mark - Class
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.imageView.frame = CGRectMake(CGRectGetMinX(self.imageView.frame),
                                      CGRectGetMinY(self.imageView.frame),
                                      CGRectGetWidth(self.imageView.frame),
                                      CGRectGetHeight(self.imageView.frame));
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0,
                                                                 70.0,
                                                                 CGRectGetWidth(self.view.frame),
                                                                 45)
                                        textContainer:nil];
    
    self.textView.backgroundColor = [UIColor darkGrayColor];
    self.textView.text = SSCaptionText;
    self.textView.delegate = self;
    self.textView.textColor = [UIColor whiteColor];
    self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textView.font = [UIFont boldSystemFontOfSize:12.0];

    [self.view addSubview:self.textView];
    
    UIButton *saveButton = [self valueForKey:@"useButton"];
    
    if (saveButton) {
        [saveButton removeTarget:self
                          action:NSSelectorFromString(@"saveImage")
                forControlEvents:UIControlEventTouchUpInside];
        
        [saveButton addTarget:self
                       action:@selector(saveImageWithMetaData)
             forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}


#pragma mark - UIActions
- (void)endTextEditing {
    [self.textView resignFirstResponder];
    
}

- (void)saveImageWithMetaData {
    [self addCaption];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(@"saveImage")];
#pragma clang diagnostic pop

}

- (BOOL)addCaption {
    if (self.textView.text.length > 1 && ![self.textView.text isEqualToString:SSCaptionText]) {
        NSMutableDictionary *metaData = [NSMutableDictionary dictionaryWithDictionary:self.capturedImageMetadata];
        [metaData setValue:self.textView.text forKey:@"SSCaption"];
     
        self.capturedImageMetadata = metaData;
        
        return YES;
    }
    
    return NO;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:SSCaptionText]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor];
        
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(endTextEditing)];
    
    tapGestureRecognizer.numberOfTapsRequired = 1;
    
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.imageView removeGestureRecognizer:self.imageView.gestureRecognizers.firstObject];
    [self.view removeGestureRecognizer:self.view.gestureRecognizers.firstObject];
    
    [self addCaption];
        
}





@end
