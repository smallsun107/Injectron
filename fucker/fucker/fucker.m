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

#define PAGEZERO 0x100000000

uintptr_t findFrameworkBaseAddress(const char *frameworkName) {
    uint32_t imageCount = _dyld_image_count();
    for (uint32_t i = 0; i < imageCount; ++i) {
        const char *imageName = _dyld_get_image_name(i);
        if (imageName && strstr(imageName, frameworkName)) {
            const struct mach_header *header = _dyld_get_image_header(i);
            intptr_t slide = _dyld_get_image_vmaddr_slide(i);
            uintptr_t baseAddr = (uintptr_t)header + slide;
            NSLog(@"[-] Found %s", imageName);
            NSLog(@"[-] Slide: 0x%lx, Base address: 0x%lx", slide, baseAddr);
            return baseAddr;
        }
    }
    NSLog(@"[!] Framework not found: %s", frameworkName);
    return 0;
}


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
        // __ZN20HeliosLicenseManager24hasValidOfflineReplyCodeEv
        void *addr = DobbySymbolResolver("Understand", "__ZN20HeliosLicenseManager24hasValidOfflineReplyCodeEv");
//        intptr_t addr = _dyld_get_image_vmaddr_slide(0) + 0x17A3D70 + 0x100000000;
        NSLog(@"[-] Understand Target address: %p", (void*)addr);
    //    tiny_hook((void*)addr, fakeHasValidOfflineReplyCode, (void*)&original);
        DobbyHook((void*)addr, fakeHasValidOfflineReplyCode, (void*)&original);
    }
    
    if (strstr(moduleName, "BCompare") != NULL) {
        [self showAlert];
        intptr_t addr = _dyld_get_image_vmaddr_slide(0) + 0x1027B31 + PAGEZERO;
        NSLog(@"[-] BCompare Target address: %p", (void*)addr);
        uint8_t data[] = {'n'};
        DobbyCodePatch((void*)addr, data, sizeof(data));
    }
    
    if (strstr(moduleName,"Proxyman") != NULL) {
        [self showAlert];
        intptr_t addr = _dyld_get_image_vmaddr_slide(0) + 0x154F5 + PAGEZERO;
        NSLog(@"[-] Proxyman Target address: %p", (void*)addr);
        uint8_t data[] = { 0x41, 0xC6, 0x47, 0x70, 0x02 };
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


