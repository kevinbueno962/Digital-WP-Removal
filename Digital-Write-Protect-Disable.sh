#!/bin/bash

echo "🌟 Digital Write Protect Disable 🌟"
echo "Checking Chromebook WP status..."

# Get WP status
wp_status=$(crossystem wpsw_cur 2>/dev/null || echo "unknown")
echo "Current WP status: $wp_status"

if [ "$wp_status" = "1" ]; then
    echo "WP is ENABLED. Attempting to disable..."

    # Try EC disable first
    if command -v ectool >/dev/null 2>&1; then
        echo "Sending EC command to disable digital WP..."
        sudo ectool fwwp --disable && echo "✅ EC WP disable command sent."
    else
        echo "⚠️ ectool not found, trying flashrom..."
        if command -v flashrom >/dev/null 2>&1; then
            sudo flashrom -p internal --wp-disable && echo "✅ flashrom WP disable attempted."
        else
            echo "❌ No EC tools found. Cannot disable digital WP."
        fi
    fi

    echo "⚠️ Reboot required for changes to take effect."

else
    echo "WP already disabled or not detectable on this device. Nothing to do."
fi

echo "🎉 Script finished!"
