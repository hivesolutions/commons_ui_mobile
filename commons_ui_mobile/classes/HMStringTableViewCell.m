// Hive Mobile
// Copyright (C) 2008 Hive Solutions Lda.
//
// This file is part of Hive Mobile.
//
// Hive Mobile is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Hive Mobile is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Hive Mobile. If not, see <http://www.gnu.org/licenses/>.

// __author__    = Tiago Silva <tsilva@hive.pt>
// __version__   = 1.0.0
// __revision__  = $LastChangedRevision: 2390 $
// __date__      = $LastChangedDate: 2009-04-02 08:36:50 +0100 (qui, 02 Abr 2009) $
// __copyright__ = Copyright (c) 2008 Hive Solutions Lda.
// __license__   = GNU General Public License (GPL), Version 3

#import "HMStringTableViewCell.h"

@implementation HMStringTableViewCell

@synthesize textField = _textField;

- (id)initWithReuseIdentifier:(NSString *)cellIdentifier {
    // invokes the parent constructor
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];

    // returns self
    return self;
}

- (void)dealloc {
    // releases the text field
    [_textField release];

    // releases the string value
    [_stringValue release];

    // calls the super
    [super dealloc];
}

- (void)createEditing {
    // calls the super
    [super createEditing];

    // creates the text field and adds it to the edit view
    CGRect editViewFrame = self.editView.frame;
    CGRect textFieldFrame = CGRectMake(HM_STRING_TABLE_VIEW_CELL_X_MARGIN, HM_STRING_TABLE_VIEW_CELL_Y_MARGIN, editViewFrame.size.width - HM_STRING_TABLE_VIEW_CELL_X_MARGIN * 2, HM_STRING_TABLE_VIEW_CELL_HEIGHT);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldFrame];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textField.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.placeholder = self.defaultValue;
    textField.delegate = self;

    // adds the textfield as subview
    [self.editView addSubview:textField];

    // sets the attributes
    self.textField = textField;

    // releases the objects
    [textField release];
}

- (void)showEditing {
    // calls the super
    [super showEditing];

    // disables cell highlighting
    self.selectionStyle = UITableViewCellEditingStyleNone;

    // updates the string value
    self.stringValue = self.detailTextLabel.text;

    // hides the text field
    self.textField.hidden = NO;
}

- (void)hideEditing {
    // hides the keyboard
    [self.textField resignFirstResponder];

    // enables cell highlighting
    self.selectionStyle = UITableViewCellSelectionStyleBlue;

    // updates the string value
    self.stringValue = self.textField.text;

    // hides the text field
    self.textField.hidden = YES;

    // calls the super
    [super hideEditing];
}

- (void)blurEditing {
    // hides the keyboard
    [self.textField resignFirstResponder];

    // updates the string value
    self.stringValue = self.textField.text;

    // calls the super
    [super blurEditing];
}

- (NSString *)stringValue {
    return _stringValue;
}

- (void)setStringValue:(NSString *)stringValue {
    // in case the object is the same
    if(stringValue == _stringValue) {
        // returns immediately
        return;
    }

    // releases the object
    [_stringValue release];

    // sets and retains the object
    _stringValue = [stringValue retain];

    // updates the detail text label text
    self.detailTextLabel.text = _stringValue;

    // updates the text field text
    self.textField.text = _stringValue;

    // updates the description
    self.description = _stringValue;
}

- (NSString *)defaultValue {
    return _defaultValue;
}

- (void)setDefaultValue:(NSString *)defaultValue {
    // in case the object is the same
    if(defaultValue == _defaultValue) {
        // returns immediately
        return;
    }

    // releases the object
    [_defaultValue release];

    // sets and retains the object
    _defaultValue = [defaultValue retain];

    // updates the text field's placeholder
    self.textField.placeholder = _defaultValue;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // focuses the editing
    [self focusEditing];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // blurs the editing
    [self blurEditing];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // hides the keyboard
    [self.textField resignFirstResponder];

    // returns yes
    return YES;
}

@end
