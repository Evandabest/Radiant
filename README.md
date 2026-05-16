# Radiant

Free macOS app that unlocks the full brightness of your MacBook Pro's XDR display.

Apple's XDR displays can output up to 1,600 nits peak brightness, but macOS caps standard content at ~500 nits — reserving the extra range for HDR video. Radiant removes that cap for everything on screen.

## Features

- **XDR Boost** — Push brightness past the macOS SDR limit using hardware gamma table adjustment
- **Eclipse Mode** — Dim your screen below the system minimum for dark rooms
- **Variable Control** — Smooth slider from maximum dim to maximum boost
- **Global Hotkey** — Toggle with Ctrl+Option+Cmd+R
- **Battery Aware** — Auto-disables boost when on battery power
- **Launch at Login** — Starts with your Mac
- **Menu Bar App** — Lives in your menu bar, out of the way

## How It Works

Radiant uses a tiny 1x1 pixel Metal overlay to trigger macOS Extended Dynamic Range (EDR) mode on the display hardware. Once EDR is active, it adjusts the display's gamma response curve via `CGSetDisplayTransferByTable` to boost all content. This operates at the hardware level, so it persists through Mission Control, app switching, and full-screen apps.

For Eclipse mode, a black overlay window with adjustable opacity dims the screen below what macOS normally allows.

## Supported Hardware

- MacBook Pro 14" and 16" with M1 Pro/Max
- MacBook Pro 14" and 16" with M2 Pro/Max
- MacBook Pro 14" and 16" with M3 Pro/Max
- MacBook Pro 14" and 16" with M4 Pro/Max
- Pro Display XDR

Requires macOS 14 Sonoma or later.

## Building from Source

1. Clone the repo
2. Open `Radiant/Radiant.xcodeproj` in Xcode
3. Build and run (Cmd+R)

