# QP-CMSIS-Pack

The QP-CMSIS-Pack project provides the files to generate an [Open-CMSIS-Pack](https://www.open-cmsis-pack.org/)-compatible pack for the popular [QP :tm: Real-Time Embedded Frameworks (RTEFs)](https://www.state-machine.com/products/qp) by [Quantum-Leaps](https://www.state-machine.com/about)

## Description

With QP-CMSIS-Pack, it is possible to create packs for QP Real-Time Embedded Frameworks in both C (QP/C) and C++ (QP/C++) flavors.

The packs are targeted at ARM Cortex-M MCUs. The following ports are supported:
* [Native (Bare-Metal) Ports](https://www.state-machine.com/qpcpp/ports_native.html)
    * [Cooperative QV Kernel](https://www.state-machine.com/qpcpp/arm-cm_qv.html)
    * [Preemptive Non-Blocking QK Kernel](https://www.state-machine.com/qpcpp/arm-cm_qk.html)
    * [Preemptive "Dual-Mode" QXK Kernel](https://www.state-machine.com/qpcpp/arm-cm_qxk.html)
* [Ports to Third-Party RTOS](https://www.state-machine.com/qpcpp/ports_rtos.html)
    * [embOS with local sources](https://www.state-machine.com/qpcpp/embos.html)
    * embOS with external pack
    * FreeRTOS with external pack
    * [ThreadX with local sources](https://www.state-machine.com/qpcpp/threadx.html)
    * [uC-OS2 with local sources](https://www.state-machine.com/qpcpp/uc-os2.html)
    
## Instructions
 
To generate the packs, the scripts in this repo rely on [Bash library for gen-pack scripts](https://github.com/Open-CMSIS-Pack/gen-pack).

1. See the above link and install the prerequisites to run this library.
2. Optional:
    * Download the following packs:
        * [SEGGER.CMSIS-embOS](https://www.segger.com/downloads/embos/)
        * [ARM.CMSIS-FreeRTOS.10.5.1.pack](https://www.keil.com/dd2/pack/)
    * TODO: other steps to setup tools for installing pack in local cache.
3. Clone the current repo.
4. Open a bash shell cd to the folder for the desired product pack (qp or qpcpp).
5. Call the pack generation script `./gen_pack.sh`
    * The script downloads sources from appropriate repositories, creates the output folder and files, performs various checks against the xml schema and file list, and finally, creates the `.pack` archive.
    * Subsequent runs can be called without the downloading repositories using `--no-preproces` switch.
    * The `.pack` archive is available in the output folder: qpcpp/output/Quantum-Leaps.CMSIS-QPCPP.x.y.z.pack for the QP/C++ product.
    
## Installation

Packs can also be installed from the available releases.

The packs are installed using [cpackget](https://github.com/Open-CMSIS-Pack/cpackget). Use one of the two following methods to installed the selected packs:

1. Download the packs from the available releases, then call:
   `cpackget add <path_to_downloaded_pack/Quantum-Leaps.CMSIS-QPCPP.x.y.z.pack>`
2. Specify the path of the released pack when calling `cpackget`:
   `cpackget https://github.com/smartinou/QP-CMSIS-Pack/releases/download/v0.1.0/Quantum-Leaps.CMSIS-QPCPP.x.y.z.pack`

## Testing
TODO
