#import "ViewController.h"
#import "MNKPDFDocument.h"
#import "MNKPDFViewController.h"

@interface ViewController () <MNKPDFViewControllerDelegate>

@end

@implementation ViewController

- (IBAction)openPDF:(UIButton *)sender {
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
    NSString *outputFilePath = [documentsPath stringByAppendingPathComponent:@"NewDocument.pdf"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"pdf"];
    MNKPDFDocument *document = [MNKPDFDocument documentWithFilePath:filePath];
    MNKPDFViewController *viewController = [[MNKPDFViewController alloc] initWithDocument:document outputFilePath:outputFilePath];
    NSLog(@"%@", outputFilePath);
    viewController.delegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)dismissPDFViewController:(MNKPDFViewController *)viewController {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

@end