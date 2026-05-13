#pragma once

#include <stdbool.h>  // bool

#if defined(TARGET_NANOX) || defined(TARGET_NANOS2)
#define ICON_APP_BOILERPLATE C_app_boilerplate_14px
#define ICON_APP_HOME        C_home_boilerplate_14px
#define ICON_APP_WARNING     C_icon_warning
#elif defined(TARGET_STAX) || defined(TARGET_FLEX)
#define ICON_APP_BOILERPLATE C_app_boilerplate_64px
#define ICON_APP_HOME        ICON_APP_BOILERPLATE
#define ICON_APP_WARNING     C_Warning_64px
#elif defined(TARGET_APEX_P)
#define ICON_APP_BOILERPLATE C_app_boilerplate_48px
#define ICON_APP_HOME        ICON_APP_BOILERPLATE
#define ICON_APP_WARNING     LARGE_WARNING_ICON
#endif

/**
 * Callback to reuse action with approve/reject in step FLOW.
 */
typedef void (*action_validate_cb)(bool);

/**
 * Display a consent screen for metadata-based encryption/decryption.
 *
 * @param title consent screen title.
 * @param trusted_name metadata trusted name to display.
 * @param callback approval callback.
 *
 * @return 0 if the screen was queued, negative integer otherwise.
 */
int ui_display_metadata_consent(const char *title, const char *trusted_name, action_validate_cb callback);

/**
 * Display address on the device and ask confirmation to export.
 *
 * @return 0 if success, negative integer otherwise.
 *
 */
int ui_display_address(void);

/**
 * Display transaction information on the device and ask confirmation to sign.
 *
 * @return 0 if success, negative integer otherwise.
 *
 */
int ui_display_transaction(void);

/**
 * Display blind-sign transaction information on the device and ask confirmation to sign.
 *
 * @return 0 if success, negative integer otherwise.
 *
 */
int ui_display_blind_signed_transaction(void);

/**
 * Display token transaction information on the device and ask confirmation to sign.
 *
 * @return 0 if success, negative integer otherwise.
 *
 */
int ui_display_token_transaction(void);
