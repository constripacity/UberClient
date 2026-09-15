# UberStrike 4.7.1 Steam client — weapon skins

Team-canonical source for the **4.7.1 Steam client** weapon-skin system: the patched
`Assembly-CSharp` (skin loader + per-id config), the skin art, and the tooling. Built as a
DLL that swaps into a retail UberStrike install (Unity 4.6.5). Skin leaks are fine by policy;
this repo is private regardless.

> **Runtime contract (do not break):** a skin only renders if
> **client dict key `==` served catalog item ID `==` art filename prefix**.
> All three move together or the weapon silently renders stock. IDs are **2010–2075**
> (Hazardous Shotgun = **2010**). The served catalog (the running server's `items.json`) MUST
> use the same IDs as this client — deploy the client and the catalog together.

## How skins load — embed-only

Skin art ships as **`EmbeddedResource`s inside `Assembly-CSharp.dll`** (see
`Assembly-CSharp/WeaponSkins/` + the `<EmbeddedResource>` entries in `Assembly-CSharp.csproj`).
There is **no loose-folder load path** — `WeaponSkinHelper.ReadEmbedded` is the only source, so
a fresh clone compiles and runs with skins visible and no deployment step. A missing embedded
file renders stock (silent), so every skin must have its resource entry.

Per skin the loader resolves, by stem:
```
<stem>.jpg  +  <stem>.alpha.png     JPEG colour + lossless mask (preferred)
<stem>.png                          single RGBA PNG (fallback)
<stem>_Icon.png                     shop icon (ProxyItem)
```

## Editing skins — one file, one block per id

All per-skin config lives in **`Assembly-CSharp/WeaponSkinDictionaries.cs`** as one authored
block per id (empty options omitted):

```csharp
{ 2010, new SkinDef { SkinTextures = "2010_HazardousShotgun.png", IconTextures = "2010_HazardousShotgun_Icon.png" } },
{ 2020, new SkinDef { SkinTextures = "2020_Frostbound.png", SkinFlameModes = FlameMode.Helix,
        SkinShaders = new string[] { "Unique/Transparent/Glass-Hangar", "Transparent/Diffuse" },
        SkinFlameTints = new Color(0.13f, 0.28f, 0.50f, 0.5f),
        SkinSleeves = new SleeveSpec { RadiusMult = 2.0f, Ribbons = 3, ... },
        SkinFlames = "2020_Frostbound_BlueFlames.png", IconTextures = "2020_Frostbound_Icon.png" } },
```

`SkinDef` carries the 13 optional attributes (SkinTextures, SkinShellScale, SkinFlameModes,
SkinShaders, SkinShaderResources, SkinMaterialBindings, SkinReflectTints, SkinFlameTints,
SkinSleeves, SkinFlames, IconTextures, TracerOverrides, MuzzleTints). A static constructor in
`WeaponSkinHelper` (a `partial class`) fans `Skins` into the legacy per-attribute dictionaries at
init, so all existing `WeaponSkinHelper.SkinTextures[id]`-style lookups keep working unchanged.
**To add/edit a skin: drop its art in `WeaponSkins/`, add its `<EmbeddedResource>` lines, and add
its `SkinDef` block here.**

## Skin-tool export

`tools/export_skindef.py` emits the paste-in block:
```
python tools/export_skindef.py --id 2010     # print one skin's block
python tools/export_skindef.py --list        # all ids
```
`skindef_block(id, fields)` is the reusable core the skin-creation tool calls for its "export
config" button — omits empty options automatically.

## Build & deploy

1. Build `Assembly-CSharp` (MSBuild). Embedding is unconditional; output ~28 MB with art.
2. Configure the server URL in `ApplicationDataManager` (`WebServiceBaseUrl` / `ImagePath`,
   e.g. `http://<SERVER_IP>:5000/2.0/` and `http://<SERVER_IP>:5000/images/`).
3. Swap the built DLLs into `<Steam>/steamapps/common/UberStrike/UberStrike_Data/Managed/`.
4. **Deploy the matching catalog** — the served `items.json` must carry the same 2010–2075 skin
   IDs (it hot-reloads). Client and catalog out of sync = stock weapons.

## Layout
```
Assembly-CSharp/
  WeaponSkinHelper.cs          skin loader + hooks; 13 dicts (now filled from WeaponSkinDictionaries)
  WeaponSkinDictionaries.cs    per-id SkinDef config (the authored source)
  WeaponSkins/                 skin art (embedded)
  Assembly-CSharp.csproj       <EmbeddedResource> entries
tools/export_skindef.py        export a skin's config as the paste-in block
WEAPON_SKINS.md                loader details, shader/alpha traps
```

## Cross-version note

This is the **MSBuild DLL client** (what the patcher swaps). A separate Unity-project copy
(`UberSteam-client-4-7-1-unity465`) uses a Unity `Resources.Load` loader; keep its skin set and
IDs in lockstep with this client and the served catalog.
