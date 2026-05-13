#include "display.h"

#include "nbgl_use_case.h"

int ui_display_metadata_consent(const char *title, const char *trusted_name, action_validate_cb callback) {
    if (title == NULL || trusted_name == NULL || callback == NULL) {
        return -1;
    }

    nbgl_useCaseChoice(NULL, title, trusted_name, "Approve", "Reject", callback);
    return 0;
}
