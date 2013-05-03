#import "QPickerElement.h"
#import "QPickerTableViewCell.h"
#import "QPickerTabDelimitedStringParser.h"

@implementation QPickerElement
{
@private
    NSMutableArray *_items;
    UIPickerView *_pickerView;
    QPickerTableViewCell *_cell;
}

@synthesize items = _items;
@synthesize valueParser = _valueParser;

- (QPickerElement *)init
{
    if (self = [super init]) {
        self.valueParser = [QPickerTabDelimitedStringParser new];
        self.keepSelected = YES;
    }
    return self;
}

- (QPickerElement *)initWithTitle:(NSString *)title items:(NSArray *)items value:(id)value
{
    if ((self = [super initWithTitle:title Value:value])) {
        _items = [NSMutableArray arrayWithArray:items];
        self.valueParser = [QPickerTabDelimitedStringParser new];
    }
    return self;
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller
{
    _cell = [tableView dequeueReusableCellWithIdentifier:QPickerTableViewCellIdentifier];
    if (_cell == nil) {
        _cell = [[QPickerTableViewCell alloc] init];
    }
    [_cell applyAppearanceForElement:self];

    UIPickerView *pickerView = nil;
    [_cell prepareForElement:self inTableView:tableView pickerView:&pickerView];
    _pickerView = pickerView;
    
    _cell.imageView.image = self.image;
    
    return _cell;
}

- (void)fetchValueIntoObject:(id)obj
{
	if (_key != nil) {
        [obj setValue:_value forKey:_key];
    }
}

- (NSArray *)selectedIndexes
{
    NSMutableArray *selectedIndexes = [NSMutableArray arrayWithCapacity:_pickerView.numberOfComponents];
    for (int component = 0; component < _pickerView.numberOfComponents; component++) {
        [selectedIndexes addObject:[NSNumber numberWithInteger:[_pickerView selectedRowInComponent:component]]];
    }
    return selectedIndexes;
}

- (void)reloadAllComponents
{
    [_pickerView reloadAllComponents];
}

- (void)reloadComponent:(NSInteger)index
{
    [_pickerView reloadComponent:index];
    NSArray *componentsValues = [self.valueParser componentsValuesFromObject:self.value];
    NSUInteger rowIndex = [_items[index] indexOfObject:componentsValues[index]];
    if (rowIndex == NSNotFound) {
        rowIndex = 0;
    }
    [_pickerView selectRow:rowIndex inComponent:index animated:YES];
    [_cell prepareForElement:self];
}

@end
