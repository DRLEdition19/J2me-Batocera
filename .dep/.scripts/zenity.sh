#!/bin/bash
# install-zenity-appimage.sh
#
# This script downloads the Zenity AppImage, makes it executable,
# creates a system-wide symlink to /usr/bin/zenity,
# and ensures the symlink is recreated on boot via /userdata/system/custom.sh.

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Please run with sudo or as root."
  exit 1
fi

# Define variables
ZENITY_URL="https://github.com/Samueru-sama/Zenity-GTK3-AppImage/releases/download/continuous/Zenity-3.44-x86_64.AppImage"
INSTALL_DIR="/userdata/system/pro/zenity"
ZENITY_APPIMAGE="$INSTALL_DIR/Zenity.AppImage"
SYMLINK="/usr/bin/zenity"
CUSTOM_SH="/userdata/system/custom.sh"

# Create installation directory
echo "Creating installation directory at $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"

# Download the Zenity AppImage
echo "Downloading Zenity AppImage from $ZENITY_URL..."
curl -L -o "$ZENITY_APPIMAGE" "$ZENITY_URL"

# Ensure the AppImage is executable
echo "Making Zenity AppImage executable..."
chmod +x "$ZENITY_APPIMAGE"

# Create the symlink for the **current session** (immediate effect)
echo "Manually symlinking Zenity for the current session..."
ln -sf "$ZENITY_APPIMAGE" "$SYMLINK"

# Ensure custom.sh exists and add symlink logic for **future reboots**
echo "Ensuring Zenity symlink is recreated on boot..."
if [ ! -f "$CUSTOM_SH" ]; then
  echo "#!/bin/bash" > "$CUSTOM_SH"
  chmod +x "$CUSTOM_SH"
fi

# Check if symlink creation is already in custom.sh
if ! grep -q "ln -sf $ZENITY_APPIMAGE $SYMLINK" "$CUSTOM_SH"; then
  echo "" >> "$CUSTOM_SH"
  echo "# Ensure Zenity symlink is recreated on boot" >> "$CUSTOM_SH"
  echo "ln -sf $ZENITY_APPIMAGE $SYMLINK" >> "$CUSTOM_SH"
  echo "Zenity symlink setup added to $CUSTOM_SH."
else
  echo "Zenity symlink setup already exists in $CUSTOM_SH."
fi

# Confirm installation
echo "Installation complete!"
echo "---------------------------------------------"
echo "Zenity AppImage has been installed at $ZENITY_APPIMAGE."
echo "A symlink has been created at $SYMLINK (immediate effect)."
echo "The file $CUSTOM_SH has been updated to ensure the symlink is recreated on boot."
echo "No reboot is required! You can use Zenity right away."
echo "---------------------------------------------"

# Test if Zenity works immediately
DISPLAY=:0.0 zenity --info --text="Zenity is now installed and working on Batocera!" &

exit 0
