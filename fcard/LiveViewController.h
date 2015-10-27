//
//  ViewController.h


#import <UIKit/UIKit.h>

@class KxMovieDecoder;

@interface LiveViewController : UIViewController

+ (id) movieViewControllerWithContentPath: (NSString *) path
                               parameters: (NSDictionary *) parameters
                                     test: (NSString *) path;

@property (readonly) BOOL playing;

- (void) play;
- (void) pause;

@end
