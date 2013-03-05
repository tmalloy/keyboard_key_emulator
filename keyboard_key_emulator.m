
#import <Cocoa/Cocoa.h>
#import <IOKit/hidsystem/IOHIDLib.h>
#import <IOKit/hidsystem/ev_keymap.h>


#include <stdio.h>
#include <string.h>


static io_connect_t get_event_driver(void)
{
    static  mach_port_t sEventDrvrRef = 0;
    mach_port_t masterPort, service, iter;
    kern_return_t    kr;

    if (!sEventDrvrRef)
    {
        // Get master device port
        kr = IOMasterPort( bootstrap_port, &masterPort );
        check( KERN_SUCCESS == kr);

        kr = IOServiceGetMatchingServices( masterPort, IOServiceMatching( kIOHIDSystemClass ), &iter );
        check( KERN_SUCCESS == kr);

        service = IOIteratorNext( iter );
        check( service );

        kr = IOServiceOpen( service, mach_task_self(),
                kIOHIDParamConnectType, &sEventDrvrRef );
        check( KERN_SUCCESS == kr );

        IOObjectRelease( service );
        IOObjectRelease( iter );
    }
    return sEventDrvrRef;
}


static void HIDPostAuxKey( const UInt8 auxKeyCode )
{
    NXEventData   event;
    kern_return_t kr;
    IOGPoint      loc = { 0, 0 };

    // Key press event
    UInt32      evtInfo = auxKeyCode << 16 | NX_KEYDOWN << 8;
    bzero(&event, sizeof(NXEventData));
    event.compound.subType = NX_SUBTYPE_AUX_CONTROL_BUTTONS;
    event.compound.misc.L[0] = evtInfo;
    kr = IOHIDPostEvent( get_event_driver(), NX_SYSDEFINED, loc, &event, kNXEventDataVersion, 0, FALSE );
    check( KERN_SUCCESS == kr );

    // Key release event
    evtInfo = auxKeyCode << 16 | NX_KEYUP << 8;
    bzero(&event, sizeof(NXEventData));
    event.compound.subType = NX_SUBTYPE_AUX_CONTROL_BUTTONS;
    event.compound.misc.L[0] = evtInfo;
    kr = IOHIDPostEvent( get_event_driver(), NX_SYSDEFINED, loc, &event, kNXEventDataVersion, 0, FALSE );
    check( KERN_SUCCESS == kr );

}


int main(int argc, char *argv[])
{
#ifdef VOLUME_UP
    HIDPostAuxKey(NX_KEYTYPE_SOUND_UP);
#elif VOLUME_DOWN
    HIDPostAuxKey(NX_KEYTYPE_SOUND_DOWN);
#elif VOLUME_MUTE
    HIDPostAuxKey(NX_KEYTYPE_MUTE);
#elif MUSIC_PREVIOUS
    HIDPostAuxKey(NX_KEYTYPE_PREVIOUS);
#elif MUSIC_PLAYPAUSE
    HIDPostAuxKey(NX_KEYTYPE_PLAY);
#elif MUSIC_NEXT
    HIDPostAuxKey(NX_KEYTYPE_NEXT);
#else

    if (argc != 2) {
        printf("Takes only 1 argument");
        return 1;
    }

    if (strcmp(argv[1], "previous") == 0) {
        HIDPostAuxKey(NX_KEYTYPE_PREVIOUS);
    } else if (strcmp(argv[1], "playpause") == 0) {
        HIDPostAuxKey(NX_KEYTYPE_PLAY);
    } else if (strcmp(argv[1], "next") == 0) {
        HIDPostAuxKey(NX_KEYTYPE_NEXT);
    } else if (strcmp(argv[1], "volumeup") == 0) {
        HIDPostAuxKey(NX_KEYTYPE_SOUND_UP);
    } else if (strcmp(argv[1], "volumedown") == 0) {
        HIDPostAuxKey(NX_KEYTYPE_SOUND_DOWN);
    } else if (strcmp(argv[1], "volumemute") == 0) {
        HIDPostAuxKey(NX_KEYTYPE_MUTE);
    } else {
        printf("Invalid parameter\n");
    }

    
    return 0;
#endif
}
