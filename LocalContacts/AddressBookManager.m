//
//  AddressBookManager.m
//  LocalContacts
//
//  Created by Takaaki Tanaka on 2015/10/03.
//  Copyright © 2015年 Takaaki Tanaka. All rights reserved.
//

@import AddressBook;

#import "AddressBookManager.h"

static NSDictionary * __GetContactForABPerson(ABRecordRef person) {
    NSMutableDictionary *personInfo = [NSMutableDictionary dictionary];
    NSDate *personModificationDate = (__bridge_transfer NSDate *)ABRecordCopyValue(person, kABPersonModificationDateProperty);
    personInfo[@"personModificationDate"] = personModificationDate;
    personInfo[@"creationDate"] = (__bridge_transfer NSDate *)ABRecordCopyValue(person, kABPersonCreationDateProperty);
    personInfo[@"recordID"] = @(ABRecordGetRecordID(person));

    //personInfo[@"birthday"] = (__bridge_transfer NSDate *)ABRecordCopyValue(person, kABPersonBirthdayProperty);
    //personInfo[@"department"] = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonDepartmentProperty);

    personInfo[@"firstName"] = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    personInfo[@"firstNamePhonetic"] = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
    personInfo[@"lastName"] = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    personInfo[@"lastNamePhonetic"] = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
    
    //contact.jobTitle = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonJobTitleProperty);
    //contact.nickname = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonNicknameProperty);
    //contact.note = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonNoteProperty);
    //contact.organization = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
    //contact.prefix = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonPrefixProperty);
    //contact.suffix = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonSuffixProperty);
    //NSManagedObjectContext *context = contact.managedObjectContext;
    //contact.addresses = __SCCreateAddressesForABPerson(person, context);
    //contact.dates = __SCCreateDatesForABPerson(person, context);
    {
        ABMultiValueRef multiValue = ABRecordCopyValue(person, kABPersonEmailProperty);
        if (multiValue) {
            NSMutableOrderedSet *emails = [NSMutableOrderedSet orderedSet];
            for (CFIndex i = 0; i < ABMultiValueGetCount(multiValue); i++) {
                NSString *value = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, i);
                NSString *label = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(multiValue, i);
                NSMutableDictionary *email = [NSMutableDictionary dictionary];
                email[@"value"] = value;
                email[@"label"] = label;
                [emails insertObject:email atIndex:i];
            }
            CFRelease(multiValue);
            personInfo[@"emails"] = emails;
        }
    }
    
    {
        ABMultiValueRef multiValue = ABRecordCopyValue(person, kABPersonPhoneProperty);
        if (multiValue) {
            NSMutableOrderedSet *phones = [NSMutableOrderedSet orderedSet];
            for (CFIndex i = 0; i < ABMultiValueGetCount(multiValue); i++) {
                NSString *value = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, i);
                NSString *label = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(multiValue, i);
                NSMutableDictionary *phone = [NSMutableDictionary dictionary];
                phone[@"value"] = value;
                phone[@"label"] = label;
                [phones insertObject:phone atIndex:i];
            }
            CFRelease(multiValue);
            personInfo[@"phones"] = phones;
        }
    }
    //contact.groups = nil;
    //contact.instantMessages = __SCCreateInstantMessagesForABPerson(person, context);
    //contact.image = __SCCreateImageForABPerson(person, context);
    //contact.thumbnail = __SCCreateThumbnailForABPerson(person, context);
    return personInfo;
}

@interface AddressBookManager ()

@property (readwrite) NSArray *contacts;

@end

@implementation AddressBookManager

- (void)requestAccessWithQueue:(NSOperationQueue *)queue completionHandler:(void (^)(BOOL, NSError *))completionHandler {
    __block ABAddressBookRef addressBook = NULL;
    __block BOOL granted = NO;
    __block NSError *error = nil;
    void (^finallyBlock)(void) = ^{
        if (addressBook) {
            CFRelease(addressBook);
        }
        if (completionHandler) {
            if (queue) {
                [queue addOperationWithBlock:^{
                    completionHandler(granted, error);
                }];
            } else {
                completionHandler(granted, error);
            }
        }
    };
    CFErrorRef cfError = NULL;
    addressBook = ABAddressBookCreateWithOptions(NULL, &cfError);
    if (!addressBook) {
        error = (__bridge_transfer NSError *)cfError;
        finallyBlock();
        return;
    }
    ABAddressBookRequestAccessCompletionHandler completion = ^(bool inGranted, CFErrorRef inCfError) {
        granted = inGranted;
        error = (__bridge_transfer NSError *)inCfError;
        finallyBlock();
    };
    ABAddressBookRequestAccessWithCompletion(addressBook, completion);
}

- (void)synchronizeRecordsWithQueue:(NSOperationQueue *)queue completionHandler:(void (^)(NSError *errorOrNil))completionHandler {
    AddressBookManager * __weak weakSelf = self;
    void (^block)(void) = ^{
        __block ABAddressBookRef addressBook = NULL;
        __block NSError *error = nil;
        void (^finallyBlock)(void) = ^{
            if (!error) {
//                [SCSettings sharedSettings].lastLocalSyncDate = addressBook ? [NSDate date] : nil;
            }
            if (addressBook) {
                CFRelease(addressBook);
            }
            if (completionHandler) {
                if (queue) {
                    [queue addOperationWithBlock:^{
                        completionHandler(error);
                    }];
                } else {
                    completionHandler(error);
                }
            }
            @synchronized(weakSelf) {
//                if (weakSelf.progress == progress) {
//                    weakSelf.progress = nil;
//                }
            }
        };
        
        CFErrorRef cfError = NULL;
        addressBook = ABAddressBookCreateWithOptions(NULL, &cfError);
        if (!addressBook) {
            if (cfError
                && CFEqual(CFErrorGetDomain(cfError), ABAddressBookErrorDomain)
                && (CFErrorGetCode(cfError) == kABOperationNotPermittedByUserError)) {
                // Continue the process to delete all local contacts
                CFRelease(cfError);
                cfError = NULL;
            } else {
                error = (__bridge_transfer NSError *)cfError;
                finallyBlock();
                return;
            }
        }
        // synchronize contacts
        {
            self.contacts = [NSArray array];
            
            NSArray *abRecoreds = addressBook ? (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook) : nil;
            for (id abRecord in abRecoreds) {

                ABRecordRef abPerson = (__bridge ABRecordRef)abRecord;
                NSNumber *identifier = @(ABRecordGetRecordID(abPerson));
                NSMutableDictionary *person = [NSMutableDictionary dictionary];
                if (person) {
                    __SCUpdateContactForABPerson(contact, abPerson);
                    [contactsByIdentifier removeObjectForKey:identifier];
                } else {
                    contact = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:privateQueueContext];
                    __SCUpdateContactForABPerson(contact, abPerson);
                }
            }
            for (SCContact *contact in contactsByIdentifier.allValues) {
                SC_RETURN_IF_CANCELLED();
                [privateQueueContext deleteObject:contact];
            }
        }
        {
            SC_RETURN_IF_CANCELLED();
            NSString *entityName = [storeManager entityNameForClass:[SCGroup class]];
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
            request.predicate = [NSPredicate predicateWithFormat:@"(localIdentifier != NULL) && (sharedIdentifier == NULL)"];
            NSArray *groups = [privateQueueContext executeFetchRequest:request error:&error];
            SC_RETURN_IF_NIL(groups);
            SC_RETURN_IF_CANCELLED();
            NSMutableDictionary *groupsByIdentifier = [NSMutableDictionary dictionary];
            for (SCGroup *group in groups) {
                groupsByIdentifier[group.localIdentifier] = group;
            }
            SC_RETURN_IF_CANCELLED();
            NSArray *abRecords = addressBook ? (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBook) : nil;
            for (id abRecord in abRecords) {
                SC_RETURN_IF_CANCELLED();
                ABRecordRef abGroup = (__bridge ABRecordRef)abRecord;
                NSNumber *identifier = @(ABRecordGetRecordID(abGroup));
                SCGroup *group = groupsByIdentifier[identifier];
                if (group) {
                    __SCUpdateGroupForABGroup(group, abGroup);
                    [groupsByIdentifier removeObjectForKey:identifier];
                } else {
                    group = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:privateQueueContext];
                    __SCUpdateGroupForABGroup(group, abGroup);
                }
            }
            for (SCGroup *group in groupsByIdentifier.allValues) {
                SC_RETURN_IF_CANCELLED();
                [privateQueueContext deleteObject:group];
            }
        }
        
#undef SC_RETURN_IF_CANCELLED
#undef SC_RETURN_IF_NIL
        
    };
}

@end
