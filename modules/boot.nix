{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  # ANCHOR Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.kernelPackages = pkgs.linux_xanmod_stable_patched;
  boot.loader.limine = {
    enable = true;
    secureBoot.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  # ANCHOR kernel params
  boot.kernelParams = [
    "quiet"
    "loglevel=0"

    "random.trust_cpu=off"
    "random.trust_bootloader=off"

    "skew_tick=1"
    "intel_iommu=on"
    "amd_iommu=force_isolation"
    "efi=disable_early_pci_dma"
    "iommu=force"
    "iommu.passthrough=0"
    "iommu.strict=1"
    "bdev_allow_write_mounted=0"
    "nosmt"
    "nohz_full=1-7"
    "rcu_nocbs=1-7"
    "kthread_cpus=0"
    "irqaffinity=0"

    "mitigations=auto"
    "spectre_v2=on"
    "spectre_bhi=on"
    "spec_store_bypass_disable=on"
    "kvm.nx_huge_pages=force"
    "l1d_flush=on"
    "spec_rstack_overflow=safe-ret"
    "gather_data_sampling=force"
    "reg_file_data_sampling=on"

    "zswap.max_pool_percent=25"
  ];
  # ANCHOR sysctl
  boot.kernel.sysctl = {
    "fs.suid_dumpable" = 0;
    # prevent pointer leaks
    "kernel.kptr_restrict" = 2;
    # restrict kernel log to CAP_SYSLOG capability
    "kernel.dmesg_restrict" = 1;
    # restrict loading TTY line disciplines to the CAP_SYS_MODULE
    "dev.tty.ldisk_autoload" = 0;
    # prevent exploit of use-after-free flaws
    "vm.unprivileged_userfaultfd" = 0;
    # kexec is used to boot another kernel during runtime and can be abused
    # "kernel.kexec_load_disabled" = 1; # done via KEXEC = no;
    # Kernel self-protection
    # SysRq exposes a lot of potentially dangerous debugging functionality to unprivileged users
    # 4 makes it so a user can only use the secure attention key. A value of 0 would disable completely
    "kernel.sysrq" = 176;
    # disable unprivileged user namespaces, Note: Docker, NH, and other apps may need this
    # "kernel.unprivileged_userns_clone" = 0; # commented out because it makes NH and other programs fail
    # restrict all usage of performance events to the CAP_PERFMON capability
    "kernel.perf_event_paranoid" = 3;
    "kernel.unprivileged_bpf_disabled" = 1;

    # Network
    # protect against SYN flood attacks (denial of service attack)
    "net.ipv4.tcp_syncookies" = 1;
    # protection against TIME-WAIT assassination
    "net.ipv4.tcp_rfc1337" = 1;
    # enable source validation of packets received (prevents IP spoofing)
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;

    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    # Protect against IP spoofing
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;

    # prevent man-in-the-middle attacks
    "net.ipv4.icmp_echo_ignore_all" = 1;

    # ignore ICMP request, helps avoid Smurf attacks
    "net.ipv4.conf.all.forwarding" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.default.accept_source_route" = 0;
    # Reverse path filtering causes the kernel to do source validation of
    "net.ipv6.conf.all.forwarding" = 0;
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.default.accept_ra" = 0;

    ## TCP hardening
    # Prevent bogus ICMP errors from filling up logs.
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

    # Disable TCP SACK
    "net.ipv4.tcp_sack" = 0;
    "net.ipv4.tcp_dsack" = 0;
    "net.ipv4.tcp_fack" = 0;

    # Userspace
    # restrict usage of ptrace
    # "kernel.yama.ptrace_scope" = 2;

    # ASLR memory protection (64-bit systems)
    "vm.mmap_rnd_bits" = 32;
    "vm.mmap_rnd_compat_bits" = 16;

    # only permit symlinks to be followed when outside of a world-writable sticky directory
    "fs.protected_symlinks" = 1;
    "fs.protected_hardlinks" = 1;
    # Prevent creating files in potentially attacker-controlled environments
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;

    # Randomize memory
    "kernel.randomize_va_space" = 2;
    # Exec Shield (Stack protection)
    "kernel.exec-shield" = 1;

    ## TCP optimization
    # TCP Fast Open is a TCP extension that reduces network latency by packing
    # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
    # both incoming and outgoing connections:
    "net.ipv4.tcp_fastopen" = 3;
    # Bufferbloat mitigations + slight improvement in throughput & latency
    # "net.ipv4.tcp_congestion_control" = "bbr"; # done via TCP_CONG_BBR = yes; and DEFAULT_BBR = yes;
    "net.core.default_qdisc" = "cake";
    # oops limit to 100
    "kernel.oops_limit" = 100;
    "kernel.warn_limit" = 100;
    "dev.tty.legacy_tiocsti" = 0;
    # harden bpf jit
    "net.core.bpf_jit_harden" = 2;

    # optimizations
    "vm.compaction_proactiveness" = 0;
    "vm.watermark_boost_factor" = 1;
    "vm.min_free_kbytes" = 1048576;
    "vm.watermark_scale_factor" = 500;
    "vm.page_lock_unfairness" = 1;
    "kernel.mm.transparent_hugepage.enabled" = "madvise";
  };
  # ANCHOR Kconfig
  nixpkgs.overlays = [
    (final: prev: {
      linux_xanmod_stable_patched = pkgs.linuxPackagesFor (
        pkgs.linux_xanmod_latest.override (old: {
          stdenv = pkgs.clangStdenv;
          buildLLVM = true;
          argsOverride = {
            NIX_CFLAGS_COMPILE = "-march=znver4 -mtune=znver4";
          };
          kernelPatches = [
            {
              name = "hardened";
              patch = null;
              structuredExtraConfig = with lib.kernel; {
                MEM_SOFT_DIRTY = lib.mkForce no;
                "9P_FSCACHE" = lib.mkForce (freeform null);
                ACPI_HMAT = lib.mkForce (freeform null);
                ATH10K_DFS_CERTIFIED = lib.mkForce (freeform null);
                ATH9K_AHB = lib.mkForce (freeform null);
                ATH9K_DFS_CERTIFIED = lib.mkForce (freeform null);
                ATH9K_PCI = lib.mkForce (freeform null);
                B43_PHY_HT = lib.mkForce (freeform null);
                BCMA_HOST_PCI = lib.mkForce (freeform null);
                CIFS_POSIX = lib.mkForce (freeform null);
                CRC32_SELFTEST = lib.mkForce (freeform null);
                CRYPTO_TEST = lib.mkForce (freeform null);
                EXT3_FS_POSIX_ACL = lib.mkForce (freeform null);
                EXT3_FS_SECURITY = lib.mkForce (freeform null);
                F2FS_FS_SECURITY = lib.mkForce (freeform null);
                GLOB_SELFTEST = lib.mkForce (freeform null);
                SUNRPC_DEBUG = lib.mkForce (freeform null);
                THRUSTMASTER_FF = lib.mkForce (freeform null);
                OCFS2_DEBUG_MASKLOG = lib.mkForce (freeform null);
                POWER_RESET_GPIO = lib.mkForce (freeform null);
                NVME_AUTH = lib.mkForce (freeform null);
                POWER_RESET_GPIO_RESTART = lib.mkForce (freeform null);
                PROC_VMCORE = lib.mkForce (freeform null);
                RTL8XXXU_UNTESTED = lib.mkForce (freeform null);
                SND_USB_CAIAQ_INPUT = lib.mkForce (freeform null);
                VIRTIO_MMIO_CMDLINE_DEVICES = lib.mkForce (freeform null);
                XPOWER_PMIC_OPREGION = lib.mkForce (freeform null);
                ZEROPLUS_FF = lib.mkForce (freeform null);
                NFSD_V4 = lib.mkForce (freeform null);
                NFSD_V4_SECURITY_LABEL = lib.mkForce (freeform null);
                NFS_FSCACHE = lib.mkForce (freeform null);
                NFS_LOCALIO = lib.mkForce (freeform null);
                NFS_SWAP = lib.mkForce (freeform null);
                NFS_V3_ACL = lib.mkForce (freeform null);
                NFS_V4_2 = lib.mkForce (freeform null);
                NFS_V4_SECURITY_LABEL = lib.mkForce (freeform null);
                NF_FLOW_TABLE_PROCFS = lib.mkForce (freeform null);
                NINTENDO_FF = lib.mkForce (freeform null);
                NOVA_CORE = lib.mkForce (freeform null);
                NTFS_FS_POSIX_ACL = lib.mkForce (freeform null);
                NVIDIA_SHIELD_FF = lib.mkForce (freeform null);
                NVME_TARGET_AUTH = lib.mkForce (freeform null);
                NVME_TARGET_PASSTHRU = lib.mkForce (freeform null);
                NVME_TARGET_TCP_TLS = lib.mkForce (freeform null);
                NVME_TCP_TLS = lib.mkForce (freeform null);
                PLAYSTATION_FF = lib.mkForce (freeform null);
                PPP_FILTER = lib.mkForce (freeform null);
                PPP_MULTILINK = lib.mkForce (freeform null);
                RT2800USB_RT53XX = lib.mkForce (freeform null);
                RT2800USB_RT55XX = lib.mkForce (freeform null);
                RTW88_8822BE = lib.mkForce (freeform null);
                RTW88_8822CE = lib.mkForce (freeform null);
                RUST = lib.mkForce (freeform null);
                SCSI_SAS_ATA = lib.mkForce (freeform null);
                SECURITY_PERF_EVENTS_RESTRICT = lib.mkForce (freeform null);
                SLAB_VIRTUAL = lib.mkForce (freeform null);
                SLIP_COMPRESSED = lib.mkForce (freeform null);
                SLIP_SMART = lib.mkForce (freeform null);
                SMARTJOYPLUS_FF = lib.mkForce (freeform null);
                SND_AC97_POWER_SAVE = lib.mkForce (freeform null);
                SND_AC97_POWER_SAVE_DEFAULT = lib.mkForce (freeform null);
                SND_HDA_CODEC_CS8409 = lib.mkForce (freeform null);
                SND_SOC_INTEL_SOUNDWIRE_SOF_MACH = lib.mkForce (freeform null);
                SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES = lib.mkForce (freeform null);
                SND_SOC_SOF_ACPI = lib.mkForce (freeform null);
                SND_SOC_SOF_APOLLOLAKE = lib.mkForce (freeform null);
                SND_SOC_SOF_CANNONLAKE = lib.mkForce (freeform null);
                SND_SOC_SOF_COFFEELAKE = lib.mkForce (freeform null);
                SND_SOC_SOF_COMETLAKE = lib.mkForce (freeform null);
                SND_SOC_SOF_ELKHARTLAKE = lib.mkForce (freeform null);
                SND_SOC_SOF_GEMINILAKE = lib.mkForce (freeform null);
                SND_SOC_SOF_HDA_AUDIO_CODEC = lib.mkForce (freeform null);
                SND_SOC_SOF_HDA_LINK = lib.mkForce (freeform null);
                SND_SOC_SOF_ICELAKE = lib.mkForce (freeform null);
                SND_SOC_SOF_INTEL_TOPLEVEL = lib.mkForce (freeform null);
                SND_SOC_SOF_JASPERLAKE = lib.mkForce (freeform null);
                SND_SOC_SOF_MERRIFIELD = lib.mkForce (freeform null);
                SND_SOC_SOF_PCI = lib.mkForce (freeform null);
                SND_SOC_SOF_TOPLEVEL = lib.mkForce (freeform null);
                SND_SOC_SOF_TIGERLAKE = lib.mkForce (freeform null);
                SQUASHFS = yes;
                VFIO_DEVICE_CDEV = lib.mkForce (freeform null);
                VFIO_NOIOMMU = lib.mkForce (freeform null);
                VFIO_PCI_VGA = lib.mkForce (freeform null);
                STAGING_MEDIA = lib.mkForce (freeform null);
                STRICT_MODULE_RWX = lib.mkForce (freeform null);
                TCG_TIS_SPI_CR50 = lib.mkForce (freeform null);
                TEST_ASYNC_DRIVER_PROBE = lib.mkForce (freeform null);
                TPS68470_PMIC_OPREGION = lib.mkForce (freeform null);
                USB_DWC2_DUAL_ROLE = lib.mkForce (freeform null);
                USB_DWC3_DUAL_ROLE = lib.mkForce (freeform null);
                U_SERIAL_CONSOLE = lib.mkForce (freeform null);
                ACPI_BATTERY = yes;
                ACPI_BUTTON = yes;
                ACPI_TABLE_UPGRADE = no;
                ACPI_VIDEO = yes;
                ACPI_WMI = yes;
                AHCI_CEVA = yes;
                AHCI_DWC = yes;
                AIO = yes;
                AMD_ATL = yes;
                AMD_IOMMU = yes;
                ASN1_ENCODER = yes;
                ATA = yes;
                ATALK = no;
                ATM = no;
                AUTOFS_FS = yes;
                BLOCK = yes;
                BLK_DEV_DM = yes;
                BLK_DEV_IO_TRACE = no;
                BLK_DEV_LOOP = yes;
                BLK_DEV_NVME = yes;
                BLK_DEV_SD = yes;
                BRIDGE = yes;
                BT = yes;
                BT_QCA = lib.mkForce yes;
                BT_BCM = yes;
                BT_BNEP = yes;
                BT_HCIBTUSB = yes;
                BT_HCIUART = lib.mkForce yes;
                BT_INTEL = yes;
                BT_INTEL_PCIE = yes;
                BT_MTK = yes;
                BT_RFCOMM = yes;
                BT_RFCOMM_TTY = yes;
                BTRFS_FS = yes;
                BT_RTL = yes;
                BUG_ON_DATA_CORRUPTION = yes;
                CACHESTAT_SYSCALL = no;
                CAN = no;
                CC_IS_CLANG = yes;
                CEC_CORE = yes;
                CFG80211 = yes;
                CIFS = no;
                CONFIGFS_FS = yes;
                CRAMFS = no;
                CRASH_DUMP = lib.mkForce no;
                CRC16 = yes;
                CRYPTO_AEAD2 = yes;
                CRYPTO_AES = yes;
                CRYPTO_AES_NI_INTEL = yes;
                CRYPTO_DRBG_CTR = lib.mkForce (freeform null);
                CRYPTO_DRBG_HASH = lib.mkForce (freeform null);
                CRYPTO_CTR = yes;
                CRYPTO_DEV_CCP_DD = yes;
                CRYPTO_ECC = yes;
                CRYPTO_ECDH = yes;
                CRYPTO_JITTERENTROPY = yes;
                CRYPTO_LIB_ARC4 = yes;
                CRYPTO_LIB_BLAKE2B = yes;
                CRYPTO_LIB_CHACHA = yes;
                CRYPTO_LIB_CHACHA20POLY1305 = yes;
                CRYPTO_LIB_CURVE25519 = yes;
                CRYPTO_LIB_GF128MUL = yes;
                CRYPTO_LIB_POLY1305 = yes;
                CRYPTO_LIB_SHA256 = yes;
                CRYPTO_LIB_SHA3 = yes;
                CRYPTO_RNG = yes;
                CRYPTO_RNG2 = yes;
                CRYPTO_SHA3 = yes;
                CRYPTO_SHA512 = yes;
                CRYPTO_USER_API = yes;
                CRYPTO_USER_API_HASH = yes;
                CRYPTO_USER_API_SKCIPHER = yes;
                CRYPTO_XTS = yes;
                CRYPTO_ZSTD = yes;
                DAX = yes;
                PAGE_OWNER = no;
                DEBUG_KMEMLEAK = no;
                PTDUMP_DEBUGFS = no;
                DEBUG_NOTIFIERS = yes;
                DEBUG_SG = yes;
                DEBUG_VIRTUAL = yes;
                DEFAULT_BBR = yes;
                DEVMEM = no;
                STRICT_DEVMEM = no;
                DEVPORT = no;
                DM_CRYPT = yes;
                DMI_SYSFS = yes;
                DRM = yes;
                DRM_AMDGPU = yes;
                DRM_BUDDY = yes;
                DRM_DISPLAY_HELPER = yes;
                DRM_EXEC = yes;
                DEVFREQ_THERMAL = lib.mkForce (freeform null);
                DRAGONRISE_FF = lib.mkForce (freeform null);
                DRM_ANALOGIX = lib.mkForce (freeform null);
                DRM_I915_GVT = lib.mkForce (freeform null);
                DRM_I915_GVT_KVMGT = lib.mkForce (freeform null);
                DRM_NOUVEAU_SVM = lib.mkForce (freeform null);
                DRM_NOVA = lib.mkForce (freeform null);
                DRM_PANIC_SCREEN_QR_CODE = lib.mkForce (freeform null);
                EROFS_FS_ZIP_DEFLATE = lib.mkForce (freeform null);
                EROFS_FS_ZIP_ZSTD = lib.mkForce (freeform null);
                EXT2_FS_POSIX_ACL = lib.mkForce (freeform null);
                EXT2_FS_SECURITY = lib.mkForce (freeform null);
                EXT2_FS_XATTR = lib.mkForce (freeform null);
                F2FS_FS_COMPRESSION = lib.mkForce (freeform null);
                FB_3DFX_ACCEL = lib.mkForce (freeform null);
                FB_ATY_CT = lib.mkForce (freeform null);
                FB_ATY_GX = lib.mkForce (freeform null);
                FB_NVIDIA_I2C = lib.mkForce (freeform null);
                FB_RIVA_I2C = lib.mkForce (freeform null);
                FB_SAVAGE_ACCEL = lib.mkForce (freeform null);
                FB_SAVAGE_I2C = lib.mkForce (freeform null);
                FB_SIS_300 = lib.mkForce (freeform null);
                FB_SIS_315 = lib.mkForce (freeform null);
                FSCACHE_STATS = lib.mkForce (freeform null);
                FUNCTION_GRAPH_RETVAL = lib.mkForce (freeform null);
                FUNCTION_PROFILER = lib.mkForce (freeform null);
                GREENASIA_FF = lib.mkForce (freeform null);
                HID_ACRUX_FF = lib.mkForce (freeform null);
                HID_BPF = lib.mkForce (freeform null);
                HOLTEK_FF = lib.mkForce (freeform null);
                INET_ESPINTCP = lib.mkForce (freeform null);
                INET_MPTCP_DIAG = lib.mkForce (freeform null);
                INET_TCP_DIAG = lib.mkForce yes;
                IPW2100_MONITOR = lib.mkForce (freeform null);
                IPW2200_MONITOR = lib.mkForce (freeform null);
                KEXEC_JUMP = lib.mkForce (freeform null);
                MLX5_CORE_EN = lib.mkForce (freeform null);
                MODULE_ALLOW_BTF_MISMATCH = lib.mkForce (freeform null);
                MTD_TESTS = lib.mkForce (freeform null);
                NUMA_BALANCING = lib.mkForce (freeform null);
                INFINIBAND_IPOIB = lib.mkForce (freeform null);
                INFINIBAND_IPOIB_CM = lib.mkForce (freeform null);
                IP_VS_IPV6 = lib.mkForce (freeform null);
                IP_VS_PROTO_AH = lib.mkForce (freeform null);
                IP_VS_PROTO_ESP = lib.mkForce (freeform null);
                IP_VS_PROTO_TCP = lib.mkForce (freeform null);
                IP_VS_PROTO_UDP = lib.mkForce (freeform null);
                JFS_POSIX_ACL = lib.mkForce (freeform null);
                JFS_SECURITY = lib.mkForce (freeform null);
                JOYSTICK_PSXPAD_SPI_FF = lib.mkForce (freeform null);
                JOYSTICK_XPAD_FF = lib.mkForce (freeform null);
                JOYSTICK_XPAD_LEDS = lib.mkForce (freeform null);
                L2TP_ETH = lib.mkForce (freeform null);
                L2TP_IP = lib.mkForce (freeform null);
                L2TP_V3 = lib.mkForce (freeform null);
                LOGIG940_FF = lib.mkForce (freeform null);
                LOGIRUMBLEPAD2_FF = lib.mkForce (freeform null);
                LOGITECH_FF = lib.mkForce (freeform null);
                LOGIWHEELS_FF = lib.mkForce (freeform null);
                MEDIA_ATTACH = lib.mkForce (freeform null);
                DRM_PANEL_BACKLIGHT_QUIRKS = yes;
                DRM_SCHED = yes;
                DRM_SUBALLOC_HELPER = yes;
                DRM_TTM = yes;
                DRM_TTM_HELPER = yes;
                EDAC = yes;
                EDAC_AMD64 = yes;
                EDAC_DECODE_MCE = yes;
                EFI_CUSTOM_SSDT_OVERLAYS = no;
                EFI_DISABLE_PCI_DMA = yes;
                EFIVAR_FS = yes;
                ENCRYPTED_KEYS = yes;
                EXT4_FS = yes;
                FAT_FS = yes;
                FIXED_PHY = yes;
                FORTIFY_SOURCE = yes;
                FUNCTION_TRACER = lib.mkForce no;
                FUSE_FS = yes;
                FWNODE_MDIO = yes;
                GFS2_FS = no;
                GPIO_AMDPT = yes;
                GPIO_GENERIC = yes;
                HARDENED_USERCOPY = yes;
                IO_STRICT_DEVMEM = lib.mkForce (freeform null);
                HAVE_KVM_IRQ_BYPASS = yes;
                HFS_FS = no;
                HFSPLUS_FS = no;
                HIBERNATION = no;
                HID = yes;
                HID_GENERIC = yes;
                HZ = lib.mkForce (freeform "1000");
                HZ_1000 = yes;
                HZ_250 = lib.mkForce no;
                I2C_ALGOBIT = yes;
                I2C_CHARDEV = yes;
                I2C_PIIX4 = yes;
                I2C_SMBUS = yes;
                IA32_EMULATION = no;
                INIT_ON_ALLOC_DEFAULT_ON = yes;
                INIT_ON_FREE_DEFAULT_ON = yes;
                INPUT_EVDEV = yes;
                INPUT_JOYDEV = yes;
                INPUT_KEYBOARD = yes;
                INPUT_LEDS = yes;
                INPUT_MOUSEDEV = yes;
                INPUT_UINPUT = yes;
                INPUT_VIVALDIFMAP = yes;
                INTEL_IOMMU = yes;
                INTEL_IOMMU_DEFAULT_ON = yes;
                INTEL_IOMMU_SVM = yes;
                INTEL_RAPL = lib.mkForce yes;
                INTEL_RAPL_CORE = yes;
                IOMMU_DEFAULT_DMA_STRICT = yes;
                IOMMU_DEFAULT_PASSTHROUGH = no;
                IP_SCTP = no;
                IRQ_BYPASS_MANAGER = yes;
                KALLSYMS_ALL = no;
                KERNEL_ZSTD = yes;
                KEXEC = no;
                KEYBOARD_ATKBD = yes;
                KPROBE_EVENTS = no;
                KSM = lib.mkForce no;
                KSTACK_ERASE = yes;
                KSTACK_ERASE_METRICS = no;
                KSTACK_ERASE_RUNTIME_DISABLE = no;
                KVM = yes;
                KVM_AMD = yes;
                KVM_INTEL = yes;
                KVM_X86 = yes;
                LDISC_AUTOLOAD = no;
                LEDS_CLASS = yes;
                LEGACY_PTYS = no;
                LEGACY_VSYSCALL_NONE = yes;
                LLC = yes;
                LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY = yes;
                MAC80211 = yes;
                MAC_EMUMOUSEBTN = yes;
                MAGIC_SYSRQ = no;
                MD = yes;
                MEDIA_SUPPORT = yes;
                MMC_BLOCK_MINORS = lib.mkForce (freeform null);
                MODULE_COMPRESS = lib.mkForce (freeform null);
                MODULE_COMPRESS_ALL = lib.mkForce (freeform null);
                MODULE_COMPRESS_XZ = lib.mkForce (freeform null);
                MODULE_DECOMPRESS = lib.mkForce (freeform null);
                MODULE_SIG = lib.mkForce (freeform null);
                MOUSE_ELAN_I2C_SMBUS = lib.mkForce (freeform null);
                MPTCP_IPV6 = lib.mkForce (freeform null);
                MTD_COMPLEX_MAPPINGS = lib.mkForce (freeform null);
                NETCONSOLE_DYNAMIC = lib.mkForce (freeform null);
                NFSD_V3_ACL = lib.mkForce (freeform null);
                MICROCODE_LATE_LOADING = no;
                MITIGATION_GDS = yes;
                MITIGATION_RFDS = yes;
                MITIGATION_SPECTRE_BHI = yes;
                MITIGATION_SPECTRE_V2 = yes;
                MITIGATION_TSA = yes;
                MITIGATION_VMSCAPE = yes;
                MODIFY_LDT_SYSCALL = no;
                IOSCHED_BFQ = lib.mkForce no;
                BFQ_GROUP_IOSCHED = lib.mkForce (freeform null);
                MODULES = no;
                MPTCP = lib.mkForce no;
                MT76_CONNAC_LIB = yes;
                MT76_CORE = yes;
                MT7921_COMMON = yes;
                MT7921E = yes;
                MT792x_LIB = yes;
                MZEN4 = yes;
                TLS = lib.mkForce yes;
                NETFILTER = yes;
                INET_DIAG = yes;
                INET_UDP_DIAG = yes;
                INET_RAW_DIAG = yes;
                NFT_REJECT_NETDEV = lib.mkForce yes;
                NET_CLS_BPF = lib.mkForce no;
                BPF_EVENTS = lib.mkForce (freeform null);
                BPF_LSM = lib.mkForce (freeform null);
                BRCMFMAC_PCIE = lib.mkForce (freeform null);
                BRCMFMAC_USB = lib.mkForce (freeform null);
                NET_ACT_BPF = lib.mkForce no;
                BXT_WC_PMIC_OPREGION = lib.mkForce (freeform null);
                CEPH_FSCACHE = lib.mkForce (freeform null);
                CEPH_FS_POSIX_ACL = lib.mkForce (freeform null);
                CIFS_DFS_UPCALL = lib.mkForce (freeform null);
                CIFS_FSCACHE = lib.mkForce (freeform null);
                CIFS_UPCALL = lib.mkForce (freeform null);
                CIFS_XATTR = lib.mkForce (freeform null);
                CLS_U32_MARK = lib.mkForce (freeform null);
                CLS_U32_PERF = lib.mkForce (freeform null);
                ZRAM = lib.mkForce yes;
                NVME_TARGET = lib.mkForce no;
                BONDING = lib.mkForce no;
                NETCONSOLE = lib.mkForce no;
                RTW88 = lib.mkForce no;
                DRM_GMA500 = lib.mkForce no;
                INFINIBAND = lib.mkForce no;
                SEV_GUEST = lib.mkForce no;
                TDX_GUEST_DRIVER = lib.mkForce no;
                CHROMEOS_LAPTOP = lib.mkForce no;
                CHROMEOS_PSTORE = lib.mkForce no;
                CHROMEOS_TBMC = lib.mkForce no;
                CROS_EC = lib.mkForce no;
                CROS_EC_I2C = lib.mkForce (freeform null);
                CROS_EC_ISHTP = lib.mkForce (freeform null);
                CROS_EC_LPC = lib.mkForce (freeform null);
                CROS_EC_SPI = lib.mkForce (freeform null);
                CROS_KBD_LED_BACKLIGHT = lib.mkForce no;
                F2FS_FS = lib.mkForce no;
                ISO9660_FS = lib.mkForce no;
                DRM_HYPERV = lib.mkForce no;
                EXPERT = yes;
                PREEMPT_RT = yes;
                RT_GROUP_SCHED = no;
                NF_TABLES_BRIDGE = lib.mkForce yes;
                KEYBOARD_APPLESPI = lib.mkForce no;
                NVME_TCP = no;
                NVME_FC = no;
                NVME_HOST_AUTH = lib.mkForce no;
                NETFILTER_NETLINK = yes;
                NETFILTER_XT_TARGET_MASQUERADE = yes;
                NET_SCH_CAKE = yes;
                NET_SCH_FQ_CODEL = yes;
                NET_UDP_TUNNEL = yes;
                NF_CONNTRACK = yes;
                NF_DEFRAG_IPV4 = yes;
                NF_DEFRAG_IPV6 = yes;
                NF_NAT = yes;
                NF_REJECT_IPV4 = yes;
                NF_REJECT_IPV6 = yes;
                NFS_FS = lib.mkForce no;
                NF_TABLES = yes;
                NFT_CT = yes;
                NFT_FIB = yes;
                NFT_FIB_INET = yes;
                NFT_FIB_IPV4 = yes;
                NFT_FIB_IPV6 = yes;
                NFT_MASQ = yes;
                NFT_NAT = yes;
                NFT_REJECT = yes;
                NFT_REJECT_INET = yes;
                N_GSM = no;
                N_HDLC = no;
                NI_XGE_MANAGEMENT_ENET = yes;
                NLS_CODEPAGE_437 = lib.mkForce yes;
                NLS_DEFAULT = freeform "utf8";
                NLS_ISO8859_1 = lib.mkForce yes;
                NLS_UTF8 = lib.mkForce yes;
                NTFS3_FS = yes;
                NUMA = lib.mkForce no;
                NVME_CORE = yes;
                OF_MDIO = yes;
                OVERLAY_FS = yes;
                PACKET = yes;
                PAGE_TABLE_CHECK = yes;
                PAGE_TABLE_CHECK_ENFORCED = yes;
                PANIC_ON_OOPS = yes;
                PCI = yes;
                PCI_MSI = yes;
                PERF_EVENTS_INTEL_RAPL = yes;
                PHYLIB = yes;
                PHY_PACKAGE = yes;
                PROC_KCORE = no;
                PROC_MEM_NO_FORCE = yes;
                PROC_PAGE_MONITOR = no;
                PROVIDE_OHCI1394_DMA_INIT = no;
                R8169 = yes;
                RAID6_PQ = yes;
                AIC79XX_DEBUG_ENABLE = lib.mkForce (freeform null);
                AIC7XXX_DEBUG_ENABLE = lib.mkForce (freeform null);
                AIC94XX_DEBUG = lib.mkForce (freeform null);
                RANDOMIZE_KSTACK_OFFSET_DEFAULT = yes;
                RANDSTRUCT_FULL = yes;
                RCU_LAZY = yes;
                RCU_NOCB_CPU = yes;
                RDS = no;
                REALTEK_PHY = yes;
                RESET_ATTACK_MITIGATION = yes;
                RFKILL = yes;
                RTC_DRV_CMOS = yes;
                SATA_ACARD_AHCI = yes;
                SATA_AHCI = yes;
                SATA_AHCI_PLATFORM = yes;
                SCHED_STACK_END_CHECK = yes;
                SCSI = yes;
                SCSI_COMMON = yes;
                SCSI_MOD = yes;
                SECURITY_LOCKDOWN_LSM = lib.mkForce yes;
                SECURITY_LOCKDOWN_LSM_EARLY = yes;
                SENSORS_K10TEMP = yes;
                SENSORS_SPD5118 = yes;
                SERIO = yes;
                SERIO_I8042 = yes;
                SERIO_LIBPS2 = yes;
                SHUFFLE_PAGE_ALLOCATOR = yes;
                SLAB_FREELIST_HARDENED = yes;
                SLAB_FREELIST_RANDOM = yes;
                SLAB_MERGE_DEFAULT = no;
                SND = yes;
                SND_CTL_LED = yes;
                SND_HDA = yes;
                SND_HDA_CODEC_ALC662 = yes;
                SND_HDA_CODEC_HDMI = yes;
                SND_HDA_CODEC_HDMI_ATI = yes;
                SND_HDA_CODEC_HDMI_GENERIC = yes;
                SND_HDA_CODEC_REALTEK = yes;
                SND_HDA_CODEC_REALTEK_LIB = yes;
                SND_HDA_CORE = yes;
                SND_HDA_GENERIC = yes;
                SND_HDA_INTEL = yes;
                SND_HRTIMER = yes;
                SND_HWDEP = yes;
                SND_INTEL_DSP_CONFIG = yes;
                SND_INTEL_SOUNDWIRE_ACPI = yes;
                SND_PCM = yes;
                SND_RAWMIDI = yes;
                SND_SEQ_DEVICE = yes;
                SND_SEQ_DUMMY = yes;
                SND_SEQUENCER = yes;
                SND_TIMER = yes;
                SND_UMP = yes;
                SND_USB_AUDIO = yes;
                SND_USB_UA101 = yes;
                SND_USB_US122L = yes;
                SND_USB_USX2Y = yes;
                SOUND = yes;
                SP5100_TCO = yes;
                STACK_TRACER = lib.mkForce no;
                STAGING = lib.mkForce no;
                STP = yes;
                TCP_CONG_BBR = yes;
                TEE = yes;
                TIPC = no;
                TRANSPARENT_HUGEPAGE = lib.mkForce (freeform null);
                TRANSPARENT_HUGEPAGE_ALWAYS = lib.mkForce (freeform null);
                TRANSPARENT_HUGEPAGE_MADVISE = lib.mkForce (freeform null);
                UBIFS_FS_ADVANCED_COMPR = lib.mkForce (freeform null);
                XEN_SAVE_RESTORE = lib.mkForce (freeform null);
                XFS_ONLINE_SCRUB = lib.mkForce (freeform null);
                XFS_POSIX_ACL = lib.mkForce (freeform null);
                XFS_QUOTA = lib.mkForce (freeform null);
                XFS_RT = lib.mkForce (freeform null);
                TRUSTED_KEYS = yes;
                TUN = yes;
                UDF_FS = lib.mkForce no;
                UHID = yes;
                UPROBE_EVENTS = lib.mkForce no;
                USB_HID = yes;
                USB_XHCI_HCD = yes;
                USB_XHCI_PCI = yes;
                VETH = yes;
                VFAT_FS = yes;
                VLAN_8021Q = yes;
                VXFS_FS = no;
                WATCHDOG_CORE = yes;
                WERROR = lib.mkForce yes;
                WIREGUARD = yes;
                WMI_BMOF = yes;
                X25 = no;
                X86_IOPL_IOPERM = no;
                X86_MSR = no;
                X86_VSYSCALL_EMULATION = no;
                XOR_BLOCKS = yes;
                ZERO_CALL_USED_REGS = yes;
                ZSTD_COMPRESS = yes;
                ZSTD_DECOMPRESS = yes;
                ZSWAP = yes;
                ZSWAP_COMPRESSOR_DEFAULT_ZSTD = yes;
                ZSWAP_DEFAULT_ON = yes;
              };
            }
          ];
        })
      );
    })
  ];

  # ANCHOR ntfs
  boot.supportedFilesystems = [ "ntfs" ];

  boot.tmp.cleanOnBoot = true;
}
