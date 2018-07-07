//
//  DSLNoDataCell.m
//  Pods
//
//  Created by zhaoke.hzk on 2017/11/2.
//
//

#import "DSLNoDataCell.h"
#import "GTNoDataModel.h"
#import "Masonry.h"

@interface DSLNoDataCell ()


@property (nonatomic , strong)UIImageView* noDataImageView;
@property (nonatomic , strong)UILabel* showNoDataLab;

@end

@implementation DSLNoDataCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        
        self.noDataImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        self.showNoDataLab = [UILabel labelWithFont:[UIFont systemFontOfSize:14]
                                            bgColor:nil
                                          textColor:[UIColor grayColor]
                                       textAligment:NSTextAlignmentCenter];
        
        self.contentView.addRelatedViews(@[self.noDataImageView,
                                           self.showNoDataLab]);
        [self addViewContraints];
        
    }
    return self;
    
}

-(void)addViewContraints{
    
    __weak __typeof(self) weakself = self;
    [self.noDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(39);
        make.centerX.mas_equalTo(weakself);
    }];
    [self.showNoDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.noDataImageView.mas_bottom).with.offset(6);
          make.centerX.mas_equalTo(weakself);
    }];
}

-(void)configurItems:(id)content{
    
    GTNoDataModel* model = content;
    [self.noDataImageView setImage:[UIImage imageNamed:model.imageName]];
    self.showNoDataLab.text = model.noDataText;
}


+(CGFloat)heightForContent:(id)content{
    return 180;
}

@end
