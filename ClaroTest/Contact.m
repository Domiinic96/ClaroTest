//
//  Contact.m
//  ClaroTest
//
//  Created by Luis Santana on 30/4/26.
//


#import "Contact.h"

@implementation Contact

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.Id forKey:@"Id"]; // 👈 FALTABA
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.lastName forKey:@"lastName"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.imageUrl forKey:@"imageUrl"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.Id = [coder decodeObjectForKey:@"Id"]; // 👈 FALTABA
        self.name = [coder decodeObjectForKey:@"name"];
        self.lastName = [coder decodeObjectForKey:@"lastName"];
        self.phone = [coder decodeObjectForKey:@"phone"];
        self.imageUrl = [coder decodeObjectForKey:@"imageUrl"];
    }
    return self;
}

@end
