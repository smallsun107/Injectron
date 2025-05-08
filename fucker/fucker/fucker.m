//
//  fucker.m
//  fucker
//
//  Created by sma11sun on 2025/5/7.
//

#import "fucker.h"
#import <mach-o/dyld.h>
#import <Cocoa/Cocoa.h>
#import "dobby/dobby.h"

@implementation fucker

static int (*original)(void* _this);

int fakeHasValidOfflineReplyCode(void* _this) {
    NSLog(@"[+] Called hasValidOfflineReplyCode");
    return 1;
}

+ (void) load{
    NSLog(@"[-] Dobby hook dylib successfully loaded and ready");
    
    const char *moduleName = _dyld_get_image_name(0);
    NSLog(@"[-] moduleName: %s",moduleName);
    if (strstr(moduleName, "Understand") != NULL){
        [self showAlert];
        intptr_t addr = _dyld_get_image_vmaddr_slide(0) + 0x17A3F50 + 0x100000000;
        NSLog(@"[-] Understand Target address: %p", (void*)addr);
    //    tiny_hook((void*)addr, fakeHasValidOfflineReplyCode, (void*)&original);
        DobbyHook((void*)addr, fakeHasValidOfflineReplyCode, (void*)&original);
    }
    if (strstr(moduleName, "BCompare") != NULL) {
        [self showAlert];
        intptr_t addr = _dyld_get_image_vmaddr_slide(0) + 0x1027B31 + 0x100000000;
        NSLog(@"[-] BCompare Target address: %p", (void*)addr);
        uint8_t data[] = {'n'};
        DobbyCodePatch((void*)addr, data, sizeof(data));
    }
    
    
}

+ (void) showAlert{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"✅"];
        [alert setInformativeText:@"Cracked by sma11sun"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
    });
}

@end


