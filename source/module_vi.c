#include "module_vi.h"

#include <switch.h>

#include "module_switch.h"

static const JanetAbstractType vi_display_type =
{
    "vi/display", JANET_ATEND_NAME
};

static Janet module_vi_default_display(int32_t argc, Janet* argv)
{
    janet_fixarity(argc, 0);

    ViDisplay* disp = janet_abstract(&vi_display_type, sizeof(ViDisplay));
    memset(disp, 0, sizeof(ViDisplay));

    Result rc = viOpenDefaultDisplay(disp);
    if(R_FAILED(rc))
        janet_panicf("failed to open default display: code %#x", rc);
    
    return janet_wrap_abstract(disp);
}

static Janet module_vi_close_display(int32_t argc, Janet* argv)
{
    janet_fixarity(argc, 1);

    ViDisplay* disp = janet_getabstract(argv, 0, &vi_display_type);

    Result rc = viCloseDisplay(disp);
    if(R_FAILED(rc))
        janet_panicf("failed to close display: code %#x", rc);
    
    return janet_wrap_nil();
}

static Janet module_vi_vsync_event(int32_t argc, Janet* argv)
{
    janet_fixarity(argc, 1);

    ViDisplay* disp = janet_getabstract(argv, 0, &vi_display_type);

    Event* evt = janet_abstract(&switch_event_type, sizeof(Event));
    memset(evt, 0, sizeof(Event));

    Result rc = viGetDisplayVsyncEvent(disp, evt);
    if(R_FAILED(rc))
        janet_panicf("failed to get display's vsync event: code %#x", rc);
    
    return janet_wrap_abstract(evt);
}

const JanetReg vi_cfuns[] =
{
    {
        "vi/default-display", module_vi_default_display,
        "(vi/default-display)\n\nOpens the Switch's default display."
    },
    {
        "vi/close-display", module_vi_close_display,
        "(vi/close-display display)\n\nCloses a display."
    },
    {
        "vi/vsync-event", module_vi_vsync_event,
        "(vi/vsync-event)\n\nGets the VSync event of the specified display."
    },
    {NULL, NULL, NULL}
};
