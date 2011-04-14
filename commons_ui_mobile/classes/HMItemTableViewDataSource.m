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

// __author__    = João Magalhães <joamag@hive.pt>
// __version__   = 1.0.0
// __revision__  = $LastChangedRevision: 2390 $
// __date__      = $LastChangedDate: 2009-04-02 08:36:50 +0100 (qui, 02 Abr 2009) $
// __copyright__ = Copyright (c) 2008 Hive Solutions Lda.
// __license__   = GNU General Public License (GPL), Version 3

#import "HMItemTableViewDataSource.h"

@implementation HMItemTableViewDataSource

@synthesize itemTableViewProvider = _itemTableViewProvider;
@synthesize itemSpecification = _itemSpecification;

- (id)init {
    // calls the super
    self = [super init];

    // returns self
    return self;
}

- (id)initWithItemTableViewProvider:(NSObject<HMItemTableViewProvider> *)itemTableViewProvider {
    // calls the default contructor
    self = [self init];

    // sets the attributes
    self.itemTableViewProvider = itemTableViewProvider;

    // returns self
    return self;
}

- (void)dealloc {
    // releases the item specification
    [_itemSpecification release];

    // calls the supper
    [super dealloc];
}

- (void)initStructures {
    // calls the super
    [super initStructures];

    // sets the item dirty
    _itemDirty = YES;
}

- (void)flushItemSpecification {
    // flushes the item specification
    [self flushItemGroup:self.listItemGroup transient:NO];
}

- (void)flushItemSpecificationTransient:(BOOL)transient {
    // flushes the item specification
    [self flushItemGroup:self.listItemGroup transient:transient];
}

- (void)flushItemGroup:(HMItemGroup *)itemGroup transient:(BOOL)transient {
    // retrieves the item group enumerator
    NSEnumerator *itemGroupEnumerator = [itemGroup.items objectEnumerator];

    // allocates the object
    id object;

    // iterates over the item group, flushing
    // the item group's items
    while((object = [itemGroupEnumerator nextObject])) {
        // casts the object
        HMItem *item = (HMItem *)object;

        // retrieves the cell for the item
        HMTableViewCell *cell = (HMTableViewCell *) [self.cellIdentifierMap objectForKey:item.identifier];

        // continues in case the cell is
        // transient and the flush is not transient
        if(cell.transient && !transient) {
            continue;
        }

        // flushes the item group in case the
        // object if of that kind
        if([object isKindOfClass:[HMItemGroup class]]) {
            // casts the object
            itemGroup = (HMItemGroup *)object;

            // flushes the item group
            [self flushItemGroup:itemGroup transient:transient];
        } else {
            // sets the cell's description and data in the item
            item.description = transient ? cell.descriptionTransient : cell.description;
            item.data = transient ? cell.dataTransient : cell.data;
        }
    }
}

- (void)updateItemSpecification {
    // in case the item dirty flag is
    // not set
    if(_itemDirty == NO) {
        // returns immeditely
        return;
    }

    // retrieves the item specification from the item table view provider
    self.itemSpecification = [self.itemTableViewProvider getItemSpecification];

    // unsets the item dirty flag
    _itemDirty = NO;
}

- (void)updateItemSpecificationForce {
    // retrieves the item specification from the item table view provider
    self.itemSpecification = [self.itemTableViewProvider getItemSpecification];

    // unsets the item dirty flag
    _itemDirty = NO;
}

- (HMNamedItemGroup *)headerNamedItemGroup {
    // retrieves the header named item group from the item specification
    HMNamedItemGroup *headerItemGroup = (HMNamedItemGroup *) [self.itemSpecification getItem:@"header"];

    // returns the header item group
    return headerItemGroup;
}

- (HMItemGroup *)listItemGroup {
    // retrieves the list item group from the item specification
    HMItemGroup *listItemGroup = (HMItemGroup *) [self.itemSpecification getItem:@"list"];

    // returns the list item group
    return listItemGroup;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // sets the table view
    self.tableView = tableView;

    // updates the item (if necessary)
    [self updateItemSpecification];

    // retrieves the menu item group items size
    NSInteger menuItemGroupItemsSize = [self.listItemGroup.items count];

    // returns the menu item group items size
    return menuItemGroupItemsSize;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[[NSArray alloc] init] autorelease];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // creates the cell identifier
    static NSString *cellIdentifier = @"Cell";

    // retrieves the table cell item
    HMTableCellItem *tableCellItem = (HMTableCellItem *) [self.listItemGroup getItemAtIndexPath:indexPath];

    // retrieves the table view cell for the table cell item identifier
    HMTableViewCell *tableViewCell = [self.cellIdentifierMap objectForKey:tableCellItem.identifier];

    // in case the cell is not defined in the cuurrent cache
    // need to create a new cell
    if(tableViewCell == nil) {
        // prints a debug message
        NSLog(@"Creating UITableViewCell with identifier: %@", tableCellItem.identifier);

        // retrieves the object class name
        const char *objectClassName = object_getClassName(tableCellItem);

        // retrieves the object class name string
        NSString *objectClassNameString = [NSString stringWithCString:objectClassName encoding:NSASCIIStringEncoding];

        if([objectClassNameString isEqualToString:@"HMTableCellItem"]) {
            // creates the new cell with the given reuse identifier
            tableViewCell = [[[HMTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        } else if([objectClassNameString isEqualToString:@"HMStringTableCellItem"]) {
            // casts the table cell item to a string table cell item
            HMStringTableCellItem *stringTableCellItem = (HMStringTableCellItem *) tableCellItem;

            // creates the appropriate string table view cell
            if(stringTableCellItem.multipleLines == NO) {
                if(stringTableCellItem.name) {
                    HMColumnStringTableViewCell *columnStringTableViewCell = [[[HMColumnStringTableViewCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];
                    columnStringTableViewCell.selectableEdit = stringTableCellItem.selectableEdit;
                    columnStringTableViewCell.defaultValue = stringTableCellItem.defaultValue;
                    columnStringTableViewCell.secure = stringTableCellItem.secure;
                    columnStringTableViewCell.editableCell = stringTableCellItem.editableCell;
                    columnStringTableViewCell.clearable = stringTableCellItem.clearable;
                    columnStringTableViewCell.returnType = stringTableCellItem.returnType;
                    columnStringTableViewCell.autocapitalizationType = stringTableCellItem.autocapitalizationType;
                    columnStringTableViewCell.returnDisablesEdit = stringTableCellItem.returnDisablesEdit;
                    columnStringTableViewCell.focusEdit = stringTableCellItem.focusEdit;
                    tableViewCell = columnStringTableViewCell;
                } else {
                    HMPlainStringTableViewCell *plainStringTableViewCell = [[[HMPlainStringTableViewCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];
                    plainStringTableViewCell.selectableEdit = stringTableCellItem.selectableEdit;
                    plainStringTableViewCell.defaultValue = stringTableCellItem.defaultValue;
                    plainStringTableViewCell.secure = stringTableCellItem.secure;
                    plainStringTableViewCell.editableCell = stringTableCellItem.editableCell;
                    plainStringTableViewCell.clearable = stringTableCellItem.clearable;
                    plainStringTableViewCell.returnType = stringTableCellItem.returnType;
                    plainStringTableViewCell.autocapitalizationType = stringTableCellItem.autocapitalizationType;
                    plainStringTableViewCell.returnDisablesEdit = stringTableCellItem.returnDisablesEdit;
                    plainStringTableViewCell.focusEdit = stringTableCellItem.focusEdit;
                    tableViewCell = plainStringTableViewCell;
                }
            } else {
                if(stringTableCellItem.name) {
                    HMColumnMultilineStringTableViewCell *columnMultilineStringTableViewCell = [[[HMColumnMultilineStringTableViewCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];
                    columnMultilineStringTableViewCell.selectableEdit = stringTableCellItem.selectableEdit;
                    columnMultilineStringTableViewCell.defaultValue = stringTableCellItem.defaultValue;
                    columnMultilineStringTableViewCell.secure = stringTableCellItem.secure;
                    columnMultilineStringTableViewCell.editableCell = stringTableCellItem.editableCell;
                    columnMultilineStringTableViewCell.clearable = stringTableCellItem.clearable;
                    columnMultilineStringTableViewCell.returnType = stringTableCellItem.returnType;
                    columnMultilineStringTableViewCell.autocapitalizationType = stringTableCellItem.autocapitalizationType;
                    columnMultilineStringTableViewCell.returnDisablesEdit = stringTableCellItem.returnDisablesEdit;
                    columnMultilineStringTableViewCell.focusEdit = stringTableCellItem.focusEdit;
                    tableViewCell = columnMultilineStringTableViewCell;
                } else {
                    HMPlainMultilineStringTableViewCell *plainMultilineStringTableViewCell = [[[HMPlainMultilineStringTableViewCell alloc] initWithReuseIdentifier:cellIdentifier] autorelease];
                    plainMultilineStringTableViewCell.selectableEdit = stringTableCellItem.selectableEdit;
                    plainMultilineStringTableViewCell.defaultValue = stringTableCellItem.defaultValue;
                    plainMultilineStringTableViewCell.secure = stringTableCellItem.secure;
                    plainMultilineStringTableViewCell.editableCell = stringTableCellItem.editableCell;
                    plainMultilineStringTableViewCell.clearable = stringTableCellItem.clearable;
                    plainMultilineStringTableViewCell.autocapitalizationType = stringTableCellItem.autocapitalizationType;
                    plainMultilineStringTableViewCell.returnType = stringTableCellItem.returnType;
                    plainMultilineStringTableViewCell.returnDisablesEdit = stringTableCellItem.returnDisablesEdit;
                    plainMultilineStringTableViewCell.focusEdit = stringTableCellItem.focusEdit;
                    tableViewCell = plainMultilineStringTableViewCell;
                }
            }
        }
    }

    // retrieves the table view cell's colors
    HMColor *nameColor = tableCellItem.nameColor;
    HMColor *descriptionColor = tableCellItem.descriptionColor;
    HMColor *backgroundColor = tableCellItem.backgroundColor;

    // sets the cell's attributes
    tableViewCell.item = tableCellItem;
    tableViewCell.data = tableCellItem.data;
    tableViewCell.name = tableCellItem.name;
    tableViewCell.description = tableCellItem.description;
    tableViewCell.nameFont = tableCellItem.nameFont;
    tableViewCell.nameFontSize = tableCellItem.nameFontSize;
    tableViewCell.descriptionFont = tableCellItem.descriptionFont;
    tableViewCell.descriptionFontSize = tableCellItem.descriptionFontSize;
    tableViewCell.icon = tableCellItem.icon;
    tableViewCell.highlightedIcon = tableCellItem.highlightedIcon;
    tableViewCell.selectable = tableCellItem.selectable;
    tableViewCell.accessoryTypeString = tableCellItem.accessoryType;
    tableViewCell.accessoryValue = tableCellItem.accessoryValue;
    tableViewCell.selectableName = tableCellItem.selectableName;
    tableViewCell.height = tableCellItem.height;
    tableViewCell.insertableRow = tableCellItem.insertableRow;
    tableViewCell.deletableRow = tableCellItem.deletableRow;
    tableViewCell.nameColor = [UIColor colorWithRed:nameColor.red green:nameColor.green blue:nameColor.blue alpha:nameColor.alpha];
    tableViewCell.descriptionColor = [UIColor colorWithRed:descriptionColor.red green:descriptionColor.green blue:descriptionColor.blue alpha:descriptionColor.alpha];
    tableViewCell.backgroundColor = [UIColor colorWithRed:backgroundColor.red green:backgroundColor.green blue:backgroundColor.blue alpha:backgroundColor.alpha];

    // inserts the item cell into the cell list
    [self.cellList addObject:tableViewCell];

    // inserts the item cell identifier association into the map
    [self.cellIdentifierMap setObject:tableViewCell forKey:tableCellItem.identifier];

    // returns the cell
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // returns in case the editing style is not delete
    if(editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }

    // retrieves the table cell item
    HMTableCellItem *tableCellItem = (HMTableCellItem *) [self.listItemGroup getItemAtIndexPath:indexPath];

    // in case the row is not deletable
    if(!tableCellItem.deletableRow) {
        // returns without
        // performing any action
        return;
    }

    // creates an array with the index path
    NSArray *indexPathArray = [NSArray arrayWithObject:indexPath];

    // peforms the specified delete action type
    switch(tableCellItem.deleteActionType) {
        // deletes the row
        case HMTableCellItemDeleteActionTypeDelete:
            // removes the item from the list item group
            [self.listItemGroup removeItemAtIndexPath:indexPath];

            // deletes the row
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            [tableView endUpdates];
            break;
        // clears the row
        case HMTableCellItemDeleteActionTypeClear:
            // clears the table cell item's
            // description and data
            tableCellItem.description = @"";
            tableCellItem.data = nil;

            // reloads the row
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            [tableView endUpdates];
            break;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // creates an index path
    NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndex:section];

    // retrieves the section item group
    HMItemGroup *sectionItemGroup = (HMItemGroup *) [self.listItemGroup getItemAtIndexPath:indexPath];

    // retrieves the section item group items count
    NSInteger sectionItemGroupItemsCount = [sectionItemGroup.items count];

    // figures out if the item group is mutable
    BOOL tableMutableSectionItemGroup = [sectionItemGroup isKindOfClass:[HMTableMutableSectionItemGroup class]];

    // decreases the count in case the table is not in edit mode and
    // the section is mutable, in order to hide the add line button
    if(!self.tableView.editing && tableMutableSectionItemGroup) {
        sectionItemGroupItemsCount -= 1;
    }

    // releases the index path
    [indexPath release];

    // returns the section item group items count
    return sectionItemGroupItemsCount;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 0;
}

+ (void)_keepAtLinkTime {
}

@end
