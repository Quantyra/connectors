# Quantyra connectors

Open hardware connectors: editable CAD, printable meshes and practical print notes. Current main contains **post-v1.0.0 prototype additions**; the v1.0.0 release covers the original paired sleeve only. All dimensions are in **mm**.

| Component | Use | Print |
| --- | --- | --- |
| [Paired pin sleeve V2](connectors/paired-pin-sleeve/README.md) | Two straight LED leads contacting opposing individual male jumper pins | [STL](connectors/paired-pin-sleeve/stl/sleeve_pair_v2.stl) |
| [Three-channel TO-92 formed-tail prototype](connectors/three-pin-sleeve/README.md) | Preformed parallel tails at 2.54 mm pitch; not native 1.27 mm pitch. **Untested prototype.** | [STL](connectors/three-pin-sleeve/stl/to92-formed-254.stl) |
| [Three-channel TO-220 narrow-blade prototype](connectors/three-pin-sleeve/README.md) | Bounded distal straight blades near 2.54 mm pitch; shoulders outside. **Untested prototype.** | [STL](connectors/three-pin-sleeve/stl/to220-narrow-254.stl) |

Choose the component's instructions before slicing or assembly. Only the original enclosed paired V2 has a user-reported basic functional demonstration with a yellow LED that works and flashes. The three-channel models have CAD/mesh checks only, with no physical fit or electrical demonstration and no supplied G-code.

The unchanged [v1.0.0 citation metadata](CITATION.cff) describes the original release; cite the exact commit and component paths for subsequent prototypes.

Hardware, CAD, STL, G-code and documentation are licensed under [CERN-OHL-S-2.0](LICENSE). See the [licensing guide](docs/licensing.md), [citation metadata](CITATION.cff), [integrity manifest](manifest.json) and [SHA-256 checksums](SHA256SUMS).

Source Location: https://github.com/Quantyra/connectors
