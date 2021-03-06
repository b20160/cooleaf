//
//  NPEventSeriesDateCell.m
//  Cooleaf
//
//  Created by Dirk R on 4/5/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "NPEventSeriesDateCell.h"
#import "NPSeriesEvent.h"

static UIImage *gCheckboxOn;
static UIImage *gCheckboxOff;

@interface NPEventSeriesDateCell ()
{
	NPSeriesEvent *_npSeriesEvent;
//	UIImageView *_checkboxImg;
//	UILabel *_dateLabel;
	NSDateFormatter *_dateFormatter;
	NSDateFormatter *_dateFormatter0;

}
@property (weak, nonatomic) IBOutlet UIImageView *checkboxImg;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation NPEventSeriesDateCell

+ (void)load
{
	gCheckboxOn = [UIImage imageNamed:@"CheckboxChecked"];
	gCheckboxOff = [UIImage imageNamed:@"CheckboxUnchecked"];
}

- (void)awakeFromNib {
	DLog(@"Series Event From Cell %@",_event);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setEvent:(NPSeriesEvent *)event
{
	_npSeriesEvent = event;
	DLog(@"event = %@", event);
	DLog(@"_npseriesevent = %@",_npSeriesEvent);
	if (!_dateFormatter0)
	{
		_dateFormatter0 = [NSDateFormatter new];
		_dateFormatter0.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
		_dateFormatter0.dateFormat = @"yyyy'-'MM'-'dd' 'HH':'mm':'ss' 'z";
	}

	NSDate *eventTime = [_dateFormatter0 dateFromString:_npSeriesEvent.startTime];

	if (!_dateFormatter)
	{
		_dateFormatter = [NSDateFormatter new];
		_dateFormatter.dateStyle = NSDateFormatterLongStyle;
		_dateFormatter.timeStyle = NSDateFormatterShortStyle;
	}
	_dateLabel.text = [_dateFormatter stringFromDate:eventTime];
	
	_checkboxImg.image = _npSeriesEvent.isAttending ? gCheckboxOn : gCheckboxOff;
	if (_npSeriesEvent.isJoinable) {
		[_checkboxImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doActionToggleAttending:)]];
		_dateLabel.textColor = [UIColor blackColor];
	}

	
}


- (void)doActionToggleAttending:(id)sender
{
	_npSeriesEvent.isAttending = !_npSeriesEvent.isAttending;
	_checkboxImg.image = _npSeriesEvent.isAttending ? gCheckboxOn : gCheckboxOff;
}



@end
