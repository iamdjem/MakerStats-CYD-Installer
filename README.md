# MakerStats CYD - Setup Guide

Complete step-by-step guide to set up MakerStats on your ESP32-2432S028 (Cheap Yellow Display).

---

## What You Need

- **ESP32-2432S028** board (Cheap Yellow Display / CYD)
- **USB cable** — Micro-USB, must be a data cable (not charge-only)
- **Computer** with Google Chrome or Microsoft Edge
- **WiFi network** — 2.4 GHz (5 GHz is not supported by ESP32)
- **MakerWorld account** — your username for stats tracking

---

## Step 1: Flash the Firmware

1. Open **Google Chrome** or **Microsoft Edge** on your computer
2. Go to the MakerStats CYD installer page
3. Plug the CYD board into your computer via USB
4. Click **Connect & Install**
5. A popup appears — select the USB serial port (usually "USB Serial" or "CH340")
6. Click **Install MakerStats CYD**
7. Wait ~30 seconds for the firmware to flash
8. When complete, the device reboots automatically

> **Tip:** If no port appears, try a different USB cable. Cheap cables are often charge-only.

> **Tip:** If flashing gets stuck at "Preparing", hold the **BOOT** button on the board while clicking Install, then release after flashing starts.

---

## Step 2: Connect to WiFi

After flashing, the device needs your WiFi credentials:

1. The CYD creates a WiFi hotspot called **"MakerStats"**
2. On your phone or laptop, connect to the **"MakerStats"** WiFi network
3. A captive portal page should open automatically
   - If it doesn't, open a browser and go to `192.168.4.1`
4. Select your **home WiFi network** from the list
5. Enter your **WiFi password**
6. Click **Save**
7. The device restarts and connects to your WiFi

> **Note:** The hotspot auto-closes after ~3 minutes. If you miss it, press the **RST** button on the board to reboot and try again.

> **Note:** The ESP32 only supports **2.4 GHz** WiFi. If your network is 5 GHz only, the device won't connect.

---

## Step 3: Add Your MakerWorld Username

Once connected to WiFi, the device shows a loading screen and fetches data:

1. Wait for the dashboard to appear (this may take 10-30 seconds on first boot)
2. Tap the **gear icon** (Settings) in the top-right corner
3. If no user is configured, tap **+ Add User**
4. Type your **MakerWorld username** using the on-screen keyboard
   - Don't include the `@` symbol — just the username
   - Example: `john_maker` not `@john_maker`
5. Tap the **checkmark** to confirm
6. Your stats will load within a few seconds

---

## Step 4: Configure Settings (Optional)

In the Settings panel you can customize:

| Setting | Description |
|---------|-------------|
| **Refresh interval** | How often stats update (1m / 5m / 15m / 30m / 1h) |
| **Timezone** | Your local timezone for accurate daily resets |
| **Auto Dim** | Automatically dim the screen after 2 minutes of no touch |
| **Brightness** | Screen brightness level (15% / 30% / 50% / 70% / 100%) |
| **Theme** | Cycle through display themes using the theme button on the dashboard header |

---

## Daily Use

- **Stats refresh automatically** based on your chosen interval
- **Tap the screen** to wake it if auto-dim is enabled
- **Tap Refresh** in the header bar to force an immediate update
- The **status bar** shows "Updated HH:MM" after each successful refresh
- **Daily changes** reset at midnight in your configured timezone

---

## Changing Your Username

To track a different MakerWorld user:

1. Open **Settings** (gear icon)
2. Tap **Del** next to the current username
3. Confirm the deletion
4. Tap **+ Add User** and enter the new username

---

## Updating Firmware

### Via Web Flasher (easiest)
1. Visit the installer page again
2. Plug in the CYD via USB
3. Click **Connect & Install** — it will flash the latest version

### Via OTA (wireless, for advanced users)
If the device is connected to WiFi, you can update wirelessly:
```
cd MakerStats-CYD
pio run -e esp32-2432S028-lvgl -t upload --upload-port makerstats-cyd.local
```

---

## Troubleshooting

### No port appears when connecting
- Use a **data-capable USB cable** (not charge-only)
- Try a different USB port on your computer
- On Mac, you may need to install the [CH340 driver](https://sparks.gogo.co.nz/ch340.html)
- On Windows, the driver usually installs automatically

### Device won't connect to WiFi
- Make sure your WiFi is **2.4 GHz** (not 5 GHz)
- Check the password is correct
- Move the device closer to your router
- Press **RST** to reboot and try the WiFi setup again

### Screen shows "WiFi offline"
- Your WiFi network may be down or the device moved out of range
- The device will automatically reconnect when WiFi returns
- To reconfigure WiFi: open Settings and tap **Reset WiFi**, then repeat Step 2

### Stats show "User not found"
- Double-check your MakerWorld username spelling
- The username is case-insensitive
- Make sure your MakerWorld profile is public

### Stats show "Cloudflare challenge" or "HTTP blocked"
- MakerWorld's server temporarily blocked the request
- This is normal — the device will automatically retry
- The status bar shows the countdown until the next retry

### Screen is too bright / too dim
- Open Settings and adjust **Brightness** with the `-` and `+` buttons
- Enable **Auto Dim** if you want the screen to dim when not in use

---

## Hardware Reference

| Component | Detail |
|-----------|--------|
| Board | ESP32-2432S028 (Cheap Yellow Display) |
| Display | 2.8" ILI9341 TFT, 320x240 pixels |
| Touch | XPT2046 resistive touchscreen |
| Chip | ESP32-D0WD-V3, dual-core 240MHz |
| Flash | 4 MB |
| USB | Micro-USB (CH340 serial converter) |
| Power | 5V via USB (can use any USB charger after setup) |
