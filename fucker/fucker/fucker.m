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
        intptr_t addr = _dyld_get_image_vmaddr_slide(0) + 0x17A3F50 + 0x100000000;
        dispatch_async(dispatch_get_main_queue(), ^{
               NSAlert *alert = [[NSAlert alloc] init];
               [alert setMessageText:@"✅"];
               [alert setInformativeText:@"Cracked by sma11sun"];
               [alert addButtonWithTitle:@"OK"];
               [alert runModal];
        });
        NSLog(@"[-] Understand Target address: %p", (void*)addr);
    //    tiny_hook((void*)addr, fakeHasValidOfflineReplyCode, (void*)&original);
        DobbyHook((void*)addr, fakeHasValidOfflineReplyCode, (void*)&original);
    }
    if (strstr(moduleName, "BCompare") != NULL) {
        intptr_t addr = _dyld_get_image_vmaddr_slide(0) + 0x1027B31 + 0x100000000;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:@"✅"];
            [alert setInformativeText:@"Cracked by sma11sun"];
            [alert addButtonWithTitle:@"OK"];
            [alert runModal];
        });
        NSLog(@"[-] BCompare Target address: %p", (void*)addr);
        uint8_t data[] = {'n'};
        DobbyCodePatch((void*)addr, data, sizeof(data));
//        Licensed to:    中國飄雲閣www.chinapyg.com
//        Quantity:       888888 users
//        Serial number:  =PYG-666=
//        License type:   Pro Edition for Windows/Linux/macOS
//
//        --- BEGIN LICENSE KEY ---
//        6X8KZpymkm3y6KAxZedzGDxSNKGZDKQamWQ6RvdeL5ZQiEUmTz
//        xAQ22uEX5acBZ4cDMwpmLqD423dWqnDqzZceHZ4MYV3B6wLth8
//        DnQu5EeGo83ppyA7BWikDGjAXE5pb4v7jGZGNHB11ojLCVACfe
//        fLUKbn85TWWKuzjC4vJpWE5fvvcWppK1UxpaBL5BfXvgQq6LA6
//        uoHsAz7a4Dw69jFqD8bP4piLxCD8mRnJos2htj436KwgaW951z
//        ZRq8mGumMdsnEG2F8hgQhym7mBmPq63eXyPt9kDwwvEXPPsJTG
//        aUNVUruJTZHEXZAfMprKbsRWBWjiabjt6vTjHdJLmMmmNPHWPT
//        --- END LICENSE KEY -----
    }
    
    
}

@end


