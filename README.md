# ⚡ GokuDex Ultimate

> **The Definitive, Aura-Charged Roblox Explorer**  
> 100% Native, Fully Self-Contained, and Supercharged by merging the best of **GokuDex**, **Dex++**, and **VEX Explorer**.

---

## 🚀 Quick Launch

Execute the master standalone build directly in your executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/gokuthug1/GokuDex/refs/heads/main/GokuDex.lua"))()
```

---

## 🛡️ 100% Native Architecture

GokuDex Ultimate has been completely re-engineered to be **100% native and self-contained in this repository**:

- 🔒 **Zero External HTTP Dependencies**: No external web APIs (`plusgiant5.com`), third-party scrapers, or third-party GitHub repositories (`AZYsGithub`, `CloneTrooper1019`, `luau/SynSaveInstance`, `secretisadev`). Everything is contained directly within `gokuthug1/GokuDex`.
- ⚡ **Instant 0.05s Startup**: No blocking network requests or remote API timeouts. The full Roblox API and Reflection Metadata are embedded natively and decode in milliseconds.
- 💻 **100% In-Process Native Decompiler**:
  - Automatically utilizes native executor `decompile()`.
  - Direct `.Source` extraction for readable scripts and Studio testing.
  - Native Luau bytecode inspector that decodes string literals, identifiers, and proto structures locally without ever sending bytecode to external servers.
- 💾 **100% Native SaveInstance & Serializer**:
  - Leverages native executor `saveinstance()` / `save_instance()`.
  - Built-in pure-Luau place serializer (`NativeSerializer.lua`) that builds and saves `.rbxlx` XML place files offline.
- 🛡️ **Native Anti-Cheat & Memory Shield**:
  - Hooks and stabilizes `gcinfo()` and `collectgarbage("count")` to prevent anti-cheats from detecting explorer memory spikes.
  - Intercepts `UserInputService:GetFocusedTextBox` and `ContentProvider:PreloadAsync` to conceal GokuDex interfaces from game scripts.

---

## 📁 Repository Structure

Everything needed to develop, run, and extend GokuDex is hosted directly in this repository:

```
GokuDex/
├── GokuDex.lua              # Master standalone release (100% self-contained, pre-bundled)
├── README.md                # Documentation & quick launch
└── Modules/                 # Individual native modules
    ├── Explorer.lua         # Hierarchy tree engine & VTree virtualization
    ├── Properties.lua       # Real-time reflection property inspector & editor
    ├── ScriptViewer.lua     # Script notepad, constant dumper & code runner
    ├── Console.lua          # Live developer console & Luau command bar
    ├── SaveInstance.lua     # SaveInstance configuration UI & manager
    ├── ModelViewer.lua      # 3D Viewport model & mesh previewer with orbit camera
    ├── SettingsWindow.lua   # Layout manager, docking presets & theme customizer
    ├── Lib.lua              # Core UI framework, windowing & drawing primitives
    ├── Bypasses.lua         # Native anti-detection, GC spoofing & UI concealment
    ├── Decompiler.lua       # In-process decompiler bridge & bytecode inspector
    └── NativeSerializer.lua # Pure-Luau .rbxlx XML place & model serializer
```

---

## ✨ Key Features

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
| **Solara** | ✅ | ✅ (Native Bytecode Inspector) | ✅ (Native Serializer) |
| **Celery** | ✅ | ✅ (Native Bytecode Inspector) | ✅ (Native Serializer) |
| **Macsploit** | ✅ | ✅ | ✅ |
| **Appleware** | ✅ | ✅ | ✅ |
| **Roblox Studio** | ✅ | ✅ (Native Source) | ✅ (Native Serializer) |

---

### 👤 Credits
- **gokuthug1**: GokuDex creator & ultimate unified remaster
- **Chillz**: Dex++
- **Vex & Team**: VEX Explorer
