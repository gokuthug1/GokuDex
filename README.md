# ⚡ GokuDex Ultimate

> **The Definitive, Aura-Charged Roblox Explorer**  
> Unified, modernized, and supercharged by merging the best of **GokuDex**, **Dex++**, and **VEX Explorer**.

---

## 🚀 Quick Launch

Execute the following in your executor:

```lua
loadstring(game:HttpGet("https://github.com/gokuthug1/GokuDex/raw/refs/heads/main/GokuDex.lua"))()
```

---

## ✨ What Makes GokuDex Ultimate?

GokuDex Ultimate combines the blazing-fast virtualized rendering engine of VEX with the developer console, notebook, and modular docking of Dex++, all wrapped in Goku's signature Super Saiyan Aura remaster.

### 🌟 Key Features

- ⚡ **VTree 60+ FPS Virtualization**: Smoothly browses hierarchies with over 500,000+ instances without frame drops or freezes.
- 🛡️ **140+ RiskyServices Blacklist**: Completely immune to game kicks, anti-cheat detections, and permission crashes when scanning `game` or internal services.
- 🎯 **In-Game Click-to-Select**:
  - **Click Part to Select**: Click any 3D model/part in the workspace to instantly focus it in the Explorer.
  - **Click UI to Select**: Click any 2D ScreenGui element on screen to highlight it in the tree.
- 📞 **Method Caller**: Live reflection of Roblox API methods with dynamic, type-safe argument parsing (Instances, strings, numbers, booleans, Vector3, CFrame, Color3, tables) and formatted return value inspector.
- 📡 **Remote Caller & Spy**: Call/fire any `RemoteEvent` or `RemoteFunction` with custom parameters, preview invocation syntax, and copy executable Lua snippets.
- 🔍 **Script Constant & Upvalue Scanner**: Deep scan loaded scripts in memory for webhooks, API tokens, passwords, hidden remotes, strings, and upvalues.
- 🏷️ **Tag & Attribute Editors**: Full CRUD management for CollectionService tags and Luau instance attributes (all modern data types supported).
- 🧊 **Interactive 3D Model Previewer**: 3D Viewport frame with 360° orbit camera, mouse zoom, pan, and lighting controls.
- ⚖️ **Diff Viewer**: Side-by-side comparison of any two instances to highlight modified, added, or removed properties.
- 💻 **Developer Console & Command Line**: Live console log (Output, Info, Warning, Error) with an embedded Luau execution command line and history.
- 📝 **Notebook / Scratchpad**: Multi-line script scratchpad with syntax font, line counters, Run Code execution, and persistent file saving (`gokudex_notes.txt`).
- 🔌 **Plugin Architecture**: Automatically loads custom user plugins from `gokudex/plugins` and `dex/plugins`.
- 💾 **Universal Decompiler & SaveInstance**: Multi-tier decompiler fallbacks (native, bytecode dump, remote API) and universal place saving (.rbxl).
- 🎨 **Goku Super Saiyan Aura Remaster**:
  - **Goku Super Saiyan (Default)**: Vibrant Orange (`#FF9826`) & Super Saiyan Blue (`#4DACFF`) with Dark Shell (`#0B0E15`)
  - **Goku Super Saiyan Blue**: Royal Sapphire & Divine Cyan
  - **Goku Ultra Instinct**: Silver Hair & Cyan Aura
  - **Goku Super Saiyan Rosé**: Deep Magenta & Violet
  - **Goku Super Saiyan God**: Crimson Flame & Solar Gold
  - Plus **Dex++ Slate**, **Classic Crimson**, and 40+ built-in color themes!
- 🪟 **Layout Presets**:
  - **Dual Docked**: Explorer pinned to left, Properties pinned to right
  - **Explorer Only**: Focused hierarchy view
  - **Properties Only**: Focused inspector view
  - **Floating Windows**: Draggable, resizable, independent windows

---

## ⌨️ Controls & Shortcuts

| Key / Action | Description |
| :--- | :--- |
| `Insert` (or configured toggle key) | Show / Hide GokuDex windows |
| `Ctrl` + Click | Multi-select instances in tree |
| `Shift` + Click | Range-select instances |
| `F2` | Rename selected instance |
| `Delete` | Destroy selected instance |
| `Ctrl` + `D` | Duplicate selected instance |
| `Ctrl` + `C` / `Ctrl` + `V` | Copy / Paste instance |
| `Right-Click` | Open comprehensive context menu |
| Top Center Badge (`⚡ GOKUDEX`) | Open Quick Access menu |

---

## 🔌 Creating Plugins

Place `.lua` or `.luau` files in your executor's `workspace/gokudex/plugins` folder. Plugins receive an API table:

```lua
return function(API)
    local Explorer = API.Explorer
    local UI = API.UI
    local Services = API.Services
    local Theme = API.Theme

    -- Create custom window or extend GokuDex
    print("[GokuDex Plugin] Loaded successfully!")
end
```

---

## 🛡️ Executor Compatibility

GokuDex Ultimate features a hardened environment bridge supporting:

| Executor | Native Support | Decompiler | SaveInstance |
| :--- | :---: | :---: | :---: |
| **Wave** | ✅ | ✅ | ✅ |
| **Synapse Z** | ✅ | ✅ | ✅ |
| **Hydrogen** | ✅ | ✅ | ✅ |
| **Delta** | ✅ | ✅ | ✅ |
| **Codex** | ✅ | ✅ | ✅ |
| **Arceus X** | ✅ | ✅ | ✅ |
| **Solara** | ✅ | ⚠️ (Fallback) | ⚠️ (Fallback) |
| **Celery** | ✅ | ⚠️ (Fallback) | ⚠️ (Fallback) |
| **Macsploit** | ✅ | ✅ | ✅ |
| **Appleware** | ✅ | ✅ | ✅ |
| **Roblox Studio** | ✅ | N/A | N/A |

---


### 👤 Credits
- **gokuthug1**: GokuDex creator & ultimate unified remaster
- **Chillz**: Dex++
- **Vex & Team**: VEX Explorer
