//
//  MNKPDFPaletteController.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 13.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFPaletteViewController.h"
#import "MNKPDFDrawingToolSettings.h"
#import "MNKPDFConstants.h"

@interface MNKPDFPaletteViewController ()

@property (nonatomic, assign) CGFloat widthRange;

@property (nonatomic, strong) NSArray *colors;

@end

@implementation MNKPDFPaletteViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        NSArray *colorsRow1 = @[[UIColor blackColor], [UIColor whiteColor], [UIColor redColor], [UIColor yellowColor], [UIColor blueColor], [UIColor greenColor]];
        NSArray *colorsRow2 = @[[UIColor grayColor], [UIColor orangeColor], [UIColor brownColor], [UIColor purpleColor], [UIColor magentaColor], [UIColor cyanColor]];
        _colors = @[colorsRow1, colorsRow2];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    MNKPDFDrawingToolSettings *settings = [MNKPDFDrawingToolSettings sharedSettings];
    
    _widthRange = MAXIMUM_LINE_WIDTH - MINIMUM_LINE_WIDTH;
    
    CGFloat yOffset = DEFAULT_SPACING + STATUS_BAR_HEIGHT;
    
    NSString *widthText = NSLocalizedString(@"LINE WIDTH", @"width");
    CGSize widthLabelSize = [widthText sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.0f]}];
    CGRect widthLabelFrame = CGRectMake(DEFAULT_SPACING, yOffset, widthLabelSize.width, widthLabelSize.height);
    UILabel *widthLabel = [[UILabel alloc] initWithFrame:widthLabelFrame];
    widthLabel.font = [UIFont systemFontOfSize:18.0f];
    widthLabel.textColor = [UIColor blackColor];
    widthLabel.text = widthText;
    [self.view addSubview:widthLabel];
    
    yOffset += DEFAULT_SPACING + widthLabelSize.height;
    
    CGRect widthSliderFrame = CGRectMake(DEFAULT_SPACING, yOffset, self.view.bounds.size.width - DEFAULT_SPACING * 2, 34.0f);
    UISlider *widthSlider = [[UISlider alloc] initWithFrame:widthSliderFrame];
    widthSlider.value = settings.lineWidth / MAXIMUM_LINE_WIDTH;
    [widthSlider addTarget:self action:@selector(widthChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:widthSlider];
    
    yOffset += DEFAULT_SPACING + widthSliderFrame.size.height;
    
    NSString *alphaText = NSLocalizedString(@"LINE ALPHA", @"alpha");
    CGSize alphaLabelSize = [alphaText sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.0f]}];
    CGRect alphaLabelFrame = CGRectMake(DEFAULT_SPACING, yOffset, alphaLabelSize.width, alphaLabelSize.height);
    UILabel *alphaLabel = [[UILabel alloc] initWithFrame:alphaLabelFrame];
    alphaLabel.font = [UIFont systemFontOfSize:18.0f];
    alphaLabel.textColor = [UIColor blackColor];
    alphaLabel.text = alphaText;
    [self.view addSubview:alphaLabel];
    
    yOffset += DEFAULT_SPACING + alphaLabelSize.height;
    
    CGRect alphaSliderFrame = CGRectMake(DEFAULT_SPACING, yOffset + DEFAULT_SPACING, self.view.bounds.size.width - DEFAULT_SPACING * 2, 34.0f);
    UISlider *alphaSlider = [[UISlider alloc] initWithFrame:alphaSliderFrame];
    alphaSlider.value = settings.lineAlpha / 1.0f;
    [alphaSlider addTarget:self action:@selector(alphaChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:alphaSlider];
    
    yOffset += DEFAULT_SPACING + alphaSliderFrame.size.height;
    
    NSString *colorsText = NSLocalizedString(@"LINE COLOR", @"color");
    CGSize colorsLabelSize = [colorsText sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.0f]}];
    CGRect colorsLabelFrame = CGRectMake(DEFAULT_SPACING, yOffset, colorsLabelSize.width, colorsLabelSize.height);
    UILabel *colorsLabel = [[UILabel alloc] initWithFrame:colorsLabelFrame];
    colorsLabel.font = [UIFont systemFontOfSize:18.0f];
    colorsLabel.textColor = [UIColor blackColor];
    colorsLabel.text = colorsText;
    [self.view addSubview:colorsLabel];
    
    yOffset += DEFAULT_SPACING + colorsLabelSize.height;
    
    for (int i = 0; i < 6; ++i) {
        for (int j = 0; j < 2; ++j) {
            CGRect buttonFrame = CGRectMake(
                                            DEFAULT_SPACING * (i+1) + PALETTE_BUTTON_SIZE.width * i,
                                            yOffset + DEFAULT_SPACING * (j+1) + PALETTE_BUTTON_SIZE.height * j,
                                            PALETTE_BUTTON_SIZE.width, PALETTE_BUTTON_SIZE.height);
            UIColor *currentColor = _colors[j][i];
            [self createPaletteButtonWithFrame:buttonFrame color:currentColor];
        }
    }
    
    yOffset += DEFAULT_SPACING * 4 + PALETTE_BUTTON_SIZE.height * 2;
    
    if (self.mode == MNKPDFPaletteViewControllerModeModal) {
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        NSString *doneButtonText = NSLocalizedString(@"Done", @"done");
        [doneButton setTitle:doneButtonText forState:UIControlStateNormal];
        CGSize buttonSize = [doneButtonText sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.0f]}];
        doneButton.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - buttonSize.width / 2, yOffset, buttonSize.width, buttonSize.height);
        [doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:doneButton];
    }
}

- (void)done {
    
    [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)alphaChanged:(UISlider *)sender {
    
    CGFloat newAlpha = sender.value == 0.0f ? 0.1f : sender.value;
    [MNKPDFDrawingToolSettings sharedSettings].lineAlpha = newAlpha;
}

- (void)widthChanged:(UISlider *)sender {
    
    CGFloat newWidth = MINIMUM_LINE_WIDTH + _widthRange * sender.value;
    [MNKPDFDrawingToolSettings sharedSettings].lineWidth = newWidth;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createPaletteButtonWithFrame:(CGRect) frame color:(UIColor *)color {
    
    UIButton *colorButton = [[UIButton alloc] initWithFrame:frame];
    [colorButton addTarget:self action:@selector(colorChosen:) forControlEvents:UIControlEventTouchUpInside];
    colorButton.backgroundColor = color;
    [self.view addSubview:colorButton];
}

- (void)colorChosen:(UIButton *)sender {
    
    [MNKPDFDrawingToolSettings sharedSettings].lineColor = sender.backgroundColor;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
