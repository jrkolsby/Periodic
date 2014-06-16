//
//  MathView.m
//  Periodic
//
//  Created by James Kolsby on 12/1/13.
//  Copyright (c) 2013 James Kolsby. All rights reserved.
//

#import "MathView.h"
#import "AppDataObject.h"
#import "Element.h"
#import <QuartzCore/QuartzCore.h>

@implementation MathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    
    //Assign the initial height for comparison
    self.initialHeight = self.bounds.size.height;
    
    //Add and configure the background shadow layer
    CALayer *shadowLayer = self.layer;
    shadowLayer.shadowOffset = CGSizeMake(1, 1);
    shadowLayer.shadowColor = [[UIColor colorWithRed:0.149 green:0.165 blue:0.208 alpha:1] CGColor];
    shadowLayer.shadowRadius = 10.0f;
    shadowLayer.shadowOpacity = 0;
    shadowLayer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
    self.shadowLayer = shadowLayer;
    
    //Configure the formula label
    UILabel *chemicalFormulaLabel = (UILabel *)[self viewWithTag:1];
    chemicalFormulaLabel.textAlignment = NSTextAlignmentCenter;
    chemicalFormulaLabel.textColor = [UIColor whiteColor];
    self.chemicalFormulaLabel = chemicalFormulaLabel;

    //Configure the mass label
    UILabel *massLabel = (UILabel *)[self viewWithTag:2];
    massLabel.textAlignment = NSTextAlignmentCenter;
    massLabel.textColor = [UIColor colorWithRed:0.996 green:0.859 blue:0.576 alpha:1];
    massLabel.font = [UIFont fontWithName:@"main-bold" size:[AppDataObject sharedInstance].viewController.fontTwo];
    self.massLabel = massLabel;
    
    //Configure the chemical info label
    UILabel *chemicalInfoLabel = (UILabel *)[self viewWithTag:3];
    chemicalInfoLabel.alpha = 0;
    self.chemicalInfoLabelInitialWidth = chemicalInfoLabel.bounds.size.width;
    self.chemicalInfoLabelInitialY = chemicalInfoLabel.frame.origin.y;
    self.chemicalInfoLabel = chemicalInfoLabel;
}

- (void)updateMath {
    
    /*
      This is where elements from currentElementArray
      are used for all of the calculations
      that the app does.
    */
    
    NSString* elementInfoPath = [[NSBundle mainBundle] pathForResource:@"Element-Info" ofType:@"plist"];
    NSDictionary *elementInfo = [NSDictionary dictionaryWithContentsOfFile:elementInfoPath];
    
    NSString* compoundInfoPath = [[NSBundle mainBundle] pathForResource:@"Compound-Info" ofType:@"plist"];
    NSDictionary *compoundInfo = [NSDictionary dictionaryWithContentsOfFile:compoundInfoPath];
    
    //Make forumula string array from Element array
    
    float massValue = 0;
    
    NSMutableArray *stringArray = [[NSMutableArray alloc] init];
    
    for (Element *element in [AppDataObject sharedInstance].currentElementArray) {
        if (element.amount > 1) {
            [stringArray addObject:[NSString stringWithFormat:@"%@%i", element.symbol, element.amount]];
        } else {
            [stringArray addObject:[NSString stringWithFormat:@"%@", element.symbol]];
        }
        float newMassValue = [[[elementInfo objectForKey:element.symbol] objectForKey:@"mass"] floatValue] * element.amount;
        massValue += newMassValue;
        
        element.percentMass = newMassValue;
    }
    
    //Alphebetize
    [stringArray sortUsingSelector:@selector(compare:)];
    
    //Move Carbon and Hydrogen to the beginning
    NSMutableArray *secondStringArray = [[NSMutableArray alloc] init];
    BOOL carbon = NO;
    for (NSString *currentSymbol in stringArray) {
        NSString *newSymbol = [currentSymbol stringByReplacingOccurrencesOfString:@"[0-9]"
                                                                       withString:@""
                                                                          options:NSRegularExpressionSearch
                                                                            range:NSMakeRange(0, currentSymbol.length)];
        if ([newSymbol isEqualToString:@"C"]) {
            carbon = YES;
            [secondStringArray insertObject:currentSymbol atIndex:0]; //Add Carbon to the beginning
        } else if ([newSymbol isEqualToString:@"H"]) {
            if (carbon) {
                [secondStringArray insertObject:currentSymbol atIndex:1]; //Add Hydrogen second if there is already a carbon
                
                                                                          /*
                                                                            Because the array was sorted alphabetically,
                                                                            Hydrogen will always be be before Carbon if it
                                                                            is in the array. Hence, BOOL carbon.
                                                                          */
            } else {
                [secondStringArray insertObject:currentSymbol atIndex:0]; //Add hydrogen first if there is no carbon
            }
        } else {
            [secondStringArray addObject:currentSymbol]; //Add any other element
        }
    }
    
    //Make the ordered chemical compound string by appending from ordered array
    NSMutableString *compoundString = [[NSMutableString alloc] init];
    for (NSString *currentElementString in secondStringArray) {
        [compoundString appendString:currentElementString];
    }
    
    //Make the raw chemical compound string by appending from raw array
    NSMutableString *rawCompoundString = [[NSMutableString alloc] init];
    for (NSString *currentElementString in stringArray) {
        [rawCompoundString appendString:currentElementString];
    }
    
    //CONFIGURE LABELS
    
    massValue = roundf(massValue * 1000) / 1000; //Round the massValue
    
    if (massValue > 0) {
        self.massLabel.text = [NSString stringWithFormat:@"%@ AMU", [[NSNumber numberWithFloat:massValue] stringValue]]; //Convert float to NSNumber to string
    } else {
        self.massLabel.text = @"";
    }
    
    //Configure strings +compoundString
    NSMutableString *percentMassString = [[NSMutableString alloc] init];
    NSString *compoundName = [[NSString alloc] init];
    NSString *compoundCharge = [[NSString alloc] init];
    
    if ([stringArray count] > 1) {
        
        int i = 1;
        for (Element *element in [AppDataObject sharedInstance].currentElementArray) {
            element.percentMass /= massValue;
            element.percentMass *= 100;
            if (i <= 6 && i < [[AppDataObject sharedInstance].currentElementArray count]) {
                [percentMassString appendString:[NSString stringWithFormat:@"%@ - %0.2f%%\n", element.symbol, element.percentMass]];
            } else if (i <= 6) {
                [percentMassString appendString:[NSString stringWithFormat:@"%@ - %0.2f%%", element.symbol, element.percentMass]];
            }
            i++;
        }

        if ([[[compoundInfo objectForKey:rawCompoundString] objectForKey:@"compoundName"] length] > 0) {
            compoundString = [[compoundInfo objectForKey:rawCompoundString] objectForKey:@"compoundName"];
            compoundName = [NSString stringWithFormat:@"\n%@\n", [[compoundInfo objectForKey:rawCompoundString] objectForKey:@"name"]];
            compoundCharge = [NSString stringWithFormat:@"%@ CHARGE\n", [[compoundInfo objectForKey:rawCompoundString] objectForKey:@"charge"]];
        } else {
            compoundName = @"\n";
            compoundCharge = @"\n";
        }
    } else if ([stringArray count] == 1){
        
        Element *loneWolf = [[AppDataObject sharedInstance].currentElementArray objectAtIndex:0];
        
        compoundName = [NSString stringWithFormat:@"\n%@\n", [[elementInfo objectForKey:loneWolf.symbol] objectForKey:@"name"]];
        compoundCharge = [NSString stringWithFormat:@"%@ PROTONS\n", [[elementInfo objectForKey:loneWolf.symbol] objectForKey:@"atomicNumber"]];
        percentMassString = [NSMutableString stringWithFormat:@"%@ - 100%%\n", loneWolf.symbol];
    }
    
    if (compoundString.length < 14) {
        self.chemicalFormulaLabel.font = [UIFont fontWithName:@"compound-bold" size:[AppDataObject sharedInstance].viewController.fontOne];
    } else if (compoundString.length >= 14) {
        self.chemicalFormulaLabel.font = [UIFont fontWithName:@"compound-bold" size:[AppDataObject sharedInstance].viewController.fontTwo];
    }
    
    self.chemicalFormulaLabel.text = compoundString;
        
    NSMutableAttributedString *percentMassAttributedString = [[NSMutableAttributedString alloc] initWithString:percentMassString];
    NSMutableAttributedString *compoundNameAttributedString = [[NSMutableAttributedString alloc] initWithString:[compoundName uppercaseString]];
    NSMutableAttributedString *compoundChargeAttributedString = [[NSMutableAttributedString alloc] initWithString:compoundCharge];
        
    NSMutableParagraphStyle *percentMassStyle = [[NSMutableParagraphStyle alloc] init];
    [percentMassStyle setLineSpacing:16];
    [percentMassAttributedString addAttribute:NSParagraphStyleAttributeName value:percentMassStyle range:NSMakeRange(0, [percentMassString length])];
    [percentMassAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"main-bold" size:[AppDataObject sharedInstance].viewController.fontThree] range:NSMakeRange(0, [percentMassString length])];
    [percentMassAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.992 green:0.384 blue:0.369 alpha:1] range:NSMakeRange(0, [percentMassString length])];
    
    NSMutableParagraphStyle *compoundNameStyle = [[NSMutableParagraphStyle alloc] init];
    [compoundNameStyle setLineSpacing:10];
    compoundNameStyle.alignment = NSTextAlignmentCenter;
    [compoundNameAttributedString addAttribute:NSParagraphStyleAttributeName value:compoundNameStyle range:NSMakeRange(0, [compoundName length])];
    [compoundNameAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"main-bold" size:[AppDataObject sharedInstance].viewController.fontTwo] range:NSMakeRange(0, [compoundName length])];
    [compoundNameAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.612 green:0.749 blue:0.643 alpha:1] range:NSMakeRange(0, [compoundName length])];
    
    NSMutableParagraphStyle *compoundChargeStyle = [[NSMutableParagraphStyle alloc] init];
    [compoundChargeStyle setLineSpacing:10];
    compoundChargeStyle.alignment = NSTextAlignmentCenter;
    [compoundChargeAttributedString addAttribute:NSParagraphStyleAttributeName value:compoundChargeStyle range:NSMakeRange(0, [compoundCharge length])];
    [compoundChargeAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"main-bold" size:[AppDataObject sharedInstance].viewController.fontThree] range:NSMakeRange(0, [compoundCharge length])];
    [compoundChargeAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.996 green:0.859 blue:0.576 alpha:1] range:NSMakeRange(0, [compoundCharge length])];
    
    NSMutableAttributedString *completeChemicalInfoString = [[NSMutableAttributedString alloc] init];
    [completeChemicalInfoString appendAttributedString:percentMassAttributedString];
    [completeChemicalInfoString appendAttributedString:compoundNameAttributedString];
    [completeChemicalInfoString appendAttributedString:compoundChargeAttributedString];
    

    self.chemicalInfoLabel.numberOfLines = 0;
    self.chemicalInfoLabel.attributedText = completeChemicalInfoString;
    [self.chemicalInfoLabel sizeToFit];
    self.chemicalInfoLabel.frame = CGRectMake(self.chemicalInfoLabel.frame.origin.x,
                                              self.chemicalInfoLabel.frame.origin.y,
                                              self.chemicalInfoLabelInitialWidth,
                                              self.chemicalInfoLabel.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
