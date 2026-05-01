//
//  Contact.h
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


#import <Foundation/Foundation.h>

@interface Contact : NSObject <NSSecureCoding>

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *imageUrl;


@end
