{
  lib,
  pkgs,
  ...
}:

{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  # ANCHOR Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.kernelPackages = pkgs.linux_patched;
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

    "mitigations=auto,nosmt"
    "spectre_v2=auto"
    "spec_store_bypass_disable=on"
    "kvm.nx_huge_pages=force"
    "l1d_flush=on"
    "spec_rstack_overflow=safe-ret"
    "gather_data_sampling=force"
    "reg_file_data_sampling=on"
    "module.sig_enforce=1"

    "zswap.max_pool_percent=25"

    "debugfs=off"
    "hash_pointers=always"
    "page_alloc.shuffle=1"
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
    "kernel.sysrq" = 0;
    # disable unprivileged user namespaces, Note: Docker, NH, and other apps may need this
    # "kernel.unprivileged_userns_clone" = 1;
    "kernel.apparmor_restrict_unprivileged_userns" = 0;
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
    "net.ipv4.tcp_congestion_control" = "bbr";
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

    # Disable io_uring, a large source of security vulnerabilities
    "kernel.io_uring_disabled" = 2;

    # Enable strict reverse path filtering (that is, do not attempt to route
    # packets that "obviously" do not belong to the iface's network; dropped
    # packets are logged as martians).
    "net.ipv4.conf.all.log_martians" = true;
    "net.ipv4.conf.default.log_martians" = true;

    # Ignore broadcast ICMP (mitigate SMURF)
    "net.ipv4.icmp_echo_ignore_broadcasts" = true;
  };
  # ANCHOR Kconfig
  nixpkgs.overlays = [
    (
      final: prev:
      let
        reflex = pkgs.fetchpatch {
          name = "reflex-governor.patch";
          url = "https://raw.githubusercontent.com/firelzrd/reflex/refs/heads/main/patches/0001-linux7.1-reflex-v0.3.2.patch";
          sha256 = "sha256-5lXzVn5NE5vxBOYjvDM4TgPCfq0zIUIxf39L7zfgpzw=";
        };
        nap = pkgs.fetchpatch {
          name = "nap.patch";
          url = "https://raw.githubusercontent.com/firelzrd/nap/refs/heads/main/patches/stable/0001-6.18.3-nap-v0.5.0.patch";
          sha256 = "sha256-A8QNSB2UyCnKeJGxao2iomJk251/if/4SxD8BNQcEGg=";
        };
        adios = pkgs.fetchpatch {
          name = "adios.patch";
          url = "https://github.com/firelzrd/adios/raw/refs/heads/main/patches/stable/0001-linux6.19.3-ADIOS-3.2.0.patch";
          sha256 = "sha256-UNx97J4UfcDSO6g1JRwGOQa1Zen147WEfgPwASf2c1M=";
        };
        adios_default = pkgs.fetchpatch {
          name = "adios-default.patch";
          url = "https://raw.githubusercontent.com/firelzrd/adios/refs/heads/main/patches/0002-Make-ADIOS-the-Default-I-O-scheduler.patch";
          sha256 = "sha256-6GYtxKtTEGJ4gvdHH1lk50r49/8RxR4i7SggA8Gr85o=";
        };
        override = pkgs.linux_xanmod_latest.override (old: {
          stdenv = pkgs.clangStdenv;
          buildLLVM = true;
          argsOverride = {
            NIX_CFLAGS_COMPILE = "-march=znver4 -mtune=znver4";
          };
          kernelPatches = [
            {
              name = "reflex-governor";
              patch = reflex;
              structuredExtraConfig = with lib.kernel; {
                CPU_FREQ_GOV_REFLEX = yes;
              };
            }
            {
              name = "nap";
              patch = nap;
              structuredExtraConfig = with pkgs.lib.kernel; {
                CPU_IDLE_GOV_NAP = yes;
              };
            }
            {
              name = "adios";
              patch = adios;
            }
            {
              name = "adios-default";
              patch = adios_default;
            }
            {
              name = "sakura";
              patch = null;
              structuredExtraConfig = with lib.kernel; {
                "9P_FSCACHE" = lib.mkForce (freeform null);
                ACPI_BATTERY = yes;
                ACPI_BUTTON = yes;
                ACPI_CONFIGFS = no;
                ACPI_HMAT = lib.mkForce (freeform null);
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
                ATM = no;
                AUTOFS_FS = yes;
                BFQ_GROUP_IOSCHED = lib.mkForce (freeform null);
                BLK_DEV_FD = no;
                BLK_DEV_LOOP = yes;
                BLK_DEV_NVME = yes;
                BLK_DEV_SD = yes;
                BLK_DEV_WRITE_MOUNTED = no;
                BLOCK = yes;
                BONDING = lib.mkForce no;
                BPF_EVENTS = lib.mkForce (freeform null);
                BPF_LSM = lib.mkForce (freeform null);
                BRIDGE = yes;
                BTRFS_FS = yes;
                BUG_ON_DATA_CORRUPTION = yes;
                CACHESTAT_SYSCALL = no;
                CAN = no;
                CC_IS_CLANG = yes;
                CEC_CORE = yes;
                CEPH_FSCACHE = lib.mkForce (freeform null);
                CHECKPOINT_RESTORE = lib.mkForce no;
                CHROMEOS_LAPTOP = lib.mkForce no;
                CHROMEOS_PSTORE = lib.mkForce no;
                CHROMEOS_TBMC = lib.mkForce no;
                CIFS = no;
                CIFS_DFS_UPCALL = lib.mkForce (freeform null);
                CIFS_FSCACHE = lib.mkForce (freeform null);
                CIFS_POSIX = lib.mkForce (freeform null);
                CIFS_UPCALL = lib.mkForce (freeform null);
                CIFS_XATTR = lib.mkForce (freeform null);
                CONFIGFS_FS = yes;
                COREDUMP = no;
                CPU_IDLE_GOV_HALTPOLL = yes;
                CPU_IDLE_GOV_LADDER = yes;
                CPU_IDLE_GOV_TEO = yes;
                CRAMFS = no;
                CRASH_DUMP = lib.mkForce no;
                CRC16 = yes;
                CRC32_SELFTEST = lib.mkForce (freeform null);
                CROS_EC = lib.mkForce no;
                CROS_EC_I2C = lib.mkForce (freeform null);
                CROS_EC_ISHTP = lib.mkForce (freeform null);
                CROS_EC_LPC = lib.mkForce (freeform null);
                CROS_EC_SPI = lib.mkForce (freeform null);
                CROS_KBD_LED_BACKLIGHT = lib.mkForce no;
                CRYPTO_AEAD2 = yes;
                CRYPTO_AES = yes;
                CRYPTO_AES_NI_INTEL = yes;
                CRYPTO_CTR = yes;
                CRYPTO_DEV_CCP_DD = yes;
                CRYPTO_ECC = yes;
                CRYPTO_ECDH = yes;
                CRYPTO_JITTERENTROPY = yes;
                CRYPTO_LIB_BLAKE2B = yes;
                CRYPTO_LIB_GF128MUL = yes;
                CRYPTO_LIB_SHA256 = yes;
                CRYPTO_LIB_SHA3 = yes;
                CRYPTO_RNG = yes;
                CRYPTO_RNG2 = yes;
                CRYPTO_SHA3 = yes;
                CRYPTO_SHA512 = yes;
                CRYPTO_TEST = lib.mkForce (freeform null);
                CRYPTO_USER_API = yes;
                CRYPTO_USER_API_HASH = yes;
                CRYPTO_USER_API_SKCIPHER = yes;
                CRYPTO_XTS = yes;
                CRYPTO_ZSTD = yes;
                DAX = yes;
                DEBUG_KMEMLEAK = no;
                DEBUG_NOTIFIERS = yes;
                DEBUG_SG = yes;
                DEBUG_VIRTUAL = yes;
                DEVMEM = no;
                DEVPORT = no;
                DM_CRYPT = module;
                DMI_SYSFS = yes;
                DRM = yes;
                DRM_AMDGPU = yes;
                DRM_BUDDY = yes;
                DRM_DISPLAY_HELPER = yes;
                DRM_EXEC = yes;
                DRM_GMA500 = lib.mkForce no;
                DRM_HYPERV = lib.mkForce no;
                DRM_I915_GVT = lib.mkForce (freeform null);
                DRM_I915_GVT_KVMGT = lib.mkForce (freeform null);
                DRM_NOUVEAU_SVM = lib.mkForce (freeform null);
                DRM_NOVA = lib.mkForce (freeform null);
                DRM_PANEL_BACKLIGHT_QUIRKS = yes;
                DRM_PANIC_SCREEN_QR_CODE = lib.mkForce (freeform null);
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
                EXPERT = yes;
                EXT3_FS_POSIX_ACL = lib.mkForce (freeform null);
                EXT3_FS_SECURITY = lib.mkForce (freeform null);
                EXT4_FS = yes;
                F2FS_FS = lib.mkForce no;
                F2FS_FS_COMPRESSION = lib.mkForce (freeform null);
                F2FS_FS_SECURITY = lib.mkForce (freeform null);
                FAT_FS = yes;
                FB = lib.mkForce no;
                FB_3DFX_ACCEL = lib.mkForce (freeform null);
                FB_ATY_CT = lib.mkForce (freeform null);
                FB_ATY_GX = lib.mkForce (freeform null);
                FB_EFI = lib.mkForce (freeform null);
                FB_NVIDIA_I2C = lib.mkForce (freeform null);
                FB_RIVA_I2C = lib.mkForce (freeform null);
                FB_SAVAGE_ACCEL = lib.mkForce (freeform null);
                FB_SAVAGE_I2C = lib.mkForce (freeform null);
                FB_SIS_300 = lib.mkForce (freeform null);
                FB_SIS_315 = lib.mkForce (freeform null);
                FB_VESA = lib.mkForce (freeform null);
                FTRACE = lib.mkForce no;
                FTRACE_SYSCALLS = lib.mkForce (freeform null);
                FIXED_PHY = yes;
                FORTIFY_SOURCE = yes;
                FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER = lib.mkForce (freeform null);
                FSCACHE_STATS = lib.mkForce (freeform null);
                FUNCTION_GRAPH_RETVAL = lib.mkForce (freeform null);
                FUNCTION_PROFILER = lib.mkForce (freeform null);
                FUNCTION_TRACER = lib.mkForce (freeform null);
                FUSE_FS = yes;
                FWNODE_MDIO = yes;
                GFS2_FS = no;
                GLOB_SELFTEST = lib.mkForce (freeform null);
                GPIO_AMDPT = yes;
                GPIO_GENERIC = yes;
                HARDENED_USERCOPY = yes;
                HAVE_KVM_IRQ_BYPASS = yes;
                HFS_FS = no;
                HFSPLUS_FS = no;
                HIBERNATION = no;
                HID = yes;
                HID_BPF = lib.mkForce (freeform null);
                HID_GENERIC = yes;
                HWPOISON_INJECT = no;
                HZ = lib.mkForce (freeform "1000");
                HZ_1000 = yes;
                HZ_250 = lib.mkForce no;
                I2C_ALGOBIT = yes;
                I2C_CHARDEV = yes;
                I2C_PIIX4 = yes;
                I2C_SMBUS = yes;
                IA32_EMULATION = yes;
                INET_DIAG = no;
                INET_DIAG_DESTROY = lib.mkForce (freeform null);
                INET_MPTCP_DIAG = lib.mkForce (freeform null);
                INET_RAW_DIAG = lib.mkForce (freeform null);
                INET_TCP_DIAG = lib.mkForce (freeform null);
                INET_UDP_DIAG = lib.mkForce (freeform null);
                INFINIBAND = lib.mkForce no;
                INFINIBAND_IPOIB = lib.mkForce (freeform null);
                INFINIBAND_IPOIB_CM = lib.mkForce (freeform null);
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
                IOSCHED_BFQ = lib.mkForce no;
                IO_STRICT_DEVMEM = lib.mkForce (freeform null);
                IP_SCTP = no;
                IRQ_BYPASS_MANAGER = yes;
                ISO9660_FS = lib.mkForce no;
                KALLSYMS_ALL = no;
                KERNEL_ZSTD = yes;
                KEXEC = no;
                KEXEC_JUMP = lib.mkForce (freeform null);
                KEYBOARD_APPLESPI = lib.mkForce no;
                KEYBOARD_ATKBD = yes;
                KPROBES = lib.mkForce no;
                KSM = lib.mkForce no;
                KSTACK_ERASE = yes;
                KSTACK_ERASE_METRICS = no;
                KSTACK_ERASE_RUNTIME_DISABLE = no;
                KVM = yes;
                KVM_AMD = yes;
                KVM_X86 = yes;
                LDISC_AUTOLOAD = no;
                LEDS_CLASS = yes;
                LEGACY_PTYS = no;
                LEGACY_VSYSCALL_NONE = yes;
                LLC = yes;
                LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY = yes;
                MAC_EMUMOUSEBTN = yes;
                MAGIC_SYSRQ = no;
                MD = yes;
                MEDIA_SUPPORT = yes;
                NET_DROP_MONITOR = lib.mkForce (freeform null);
                RING_BUFFER_BENCHMARK = lib.mkForce (freeform null);
                SCHED_TRACER = lib.mkForce (freeform null);
                TLS_DEVICE = lib.mkForce (freeform null);
                VGA_SWITCHEROO = lib.mkForce (freeform null);
                MEM_SOFT_DIRTY = lib.mkForce (freeform null);
                MICROCODE_LATE_LOADING = no;
                MITIGATION_GDS = yes;
                MITIGATION_RFDS = yes;
                MITIGATION_SPECTRE_BHI = yes;
                MITIGATION_SPECTRE_V2 = yes;
                MITIGATION_TSA = yes;
                MITIGATION_VMSCAPE = yes;
                MODULE_SIG = lib.mkForce yes;
                MPTCP = lib.mkForce no;
                MPTCP_IPV6 = lib.mkForce (freeform null);
                MT7921E = module;
                MTD_PHRAM = no;
                MTD_SLRAM = no;
                NET_ACT_BPF = lib.mkForce no;
                NET_CLS_BPF = lib.mkForce no;
                NETCONSOLE = lib.mkForce no;
                NETCONSOLE_DYNAMIC = lib.mkForce (freeform null);
                NETFILTER = yes;
                NETFILTER_NETLINK = yes;
                NETFILTER_XT_TARGET_MASQUERADE = module;
                NET_SCH_CAKE = yes;
                NET_SCH_FQ_CODEL = yes;
                NF_CONNTRACK = yes;
                NF_DEFRAG_IPV4 = yes;
                NF_DEFRAG_IPV6 = yes;
                NF_NAT = yes;
                NF_REJECT_IPV4 = yes;
                NF_REJECT_IPV6 = yes;
                NFS_FS = lib.mkForce no;
                NFS_FSCACHE = lib.mkForce (freeform null);
                NFS_LOCALIO = lib.mkForce (freeform null);
                NFS_SWAP = lib.mkForce (freeform null);
                NFS_V3_ACL = lib.mkForce (freeform null);
                NFS_V4_2 = lib.mkForce (freeform null);
                NFS_V4_SECURITY_LABEL = lib.mkForce (freeform null);
                NF_TABLES = yes;
                NF_TABLES_BRIDGE = lib.mkForce yes;
                NFT_CT = yes;
                NFT_FIB = yes;
                NFT_FIB_INET = yes;
                NFT_FIB_IPV4 = yes;
                NFT_FIB_IPV6 = yes;
                NFT_MASQ = yes;
                NFT_NAT = yes;
                NFT_REJECT = yes;
                NFT_REJECT_INET = yes;
                NFT_REJECT_NETDEV = lib.mkForce yes;
                N_GSM = no;
                N_HDLC = no;
                NI_XGE_MANAGEMENT_ENET = yes;
                NLS_CODEPAGE_437 = lib.mkForce yes;
                NLS_DEFAULT = freeform "utf8";
                NLS_ISO8859_1 = lib.mkForce yes;
                NLS_UTF8 = lib.mkForce yes;
                NO_HZ = no;
                NO_HZ_FULL = lib.mkOverride 60 no;
                NO_HZ_IDLE = yes;
                NOVA_CORE = lib.mkForce (freeform null);
                NTFS3_FS = module;
                NUMA = lib.mkForce no;
                NUMA_BALANCING = lib.mkForce (freeform null);
                NVME_AUTH = lib.mkForce (freeform null);
                NVME_FC = no;
                NVME_HOST_AUTH = lib.mkForce no;
                NVME_TARGET = lib.mkForce no;
                NVME_TARGET_AUTH = lib.mkForce (freeform null);
                NVME_TARGET_PASSTHRU = lib.mkForce (freeform null);
                NVME_TARGET_TCP_TLS = lib.mkForce (freeform null);
                NVME_TCP = no;
                NVME_TCP_TLS = lib.mkForce (freeform null);
                PACKET = yes;
                PAGE_OWNER = no;
                PAGE_TABLE_CHECK = yes;
                PAGE_TABLE_CHECK_ENFORCED = yes;
                PANIC_ON_OOPS = yes;
                POWER_RESET_GPIO = lib.mkForce (freeform null);
                POWER_RESET_GPIO_RESTART = lib.mkForce (freeform null);
                PREEMPT = no;
                PREEMPT_LAZY = yes;
                PREEMPT_RT = yes;
                PROC_KCORE = no;
                PROC_MEM_NO_FORCE = yes;
                PROC_VMCORE = lib.mkForce (freeform null);
                PROVIDE_OHCI1394_DMA_INIT = no;
                PTDUMP_DEBUGFS = no;
                PUNIT_ATOM_DEBUG = no;
                RANDOMIZE_KSTACK_OFFSET_DEFAULT = yes;
                RANDSTRUCT_FULL = yes;
                RCU_BOOST = yes;
                RCU_BOOST_DELAY = freeform "0";
                RCU_DOUBLE_CHECK_CB_TIME = yes;
                RCU_EXPERT = yes;
                RCU_EXP_KTHREAD = yes;
                RCU_FANOUT = freeform "64";
                RCU_FANOUT_LEAF = freeform "16";
                RCU_LAZY = yes;
                RCU_NOCB_CPU = yes;
                RESET_ATTACK_MITIGATION = yes;
                RT_GROUP_SCHED = no;
                RTW88 = lib.mkForce no;
                RTW88_8822BE = lib.mkForce (freeform null);
                RTW88_8822CE = lib.mkForce (freeform null);
                RUST = lib.mkForce (freeform null);
                SCHED_STACK_END_CHECK = yes;
                SECURITY_LOCKDOWN_LSM = lib.mkForce yes;
                SECURITY_LOCKDOWN_LSM_EARLY = yes;
                SEV_GUEST = lib.mkForce no;
                SHUFFLE_PAGE_ALLOCATOR = yes;
                SLAB_FREELIST_HARDENED = yes;
                SLAB_FREELIST_RANDOM = yes;
                SLAB_MERGE_DEFAULT = no;
                SLUB = yes;
                SLUB_DEBUG = yes;
                SMB_SERVER = no;
                SQUASHFS = yes;
                STACK_TRACER = lib.mkForce (freeform null);
                STAGING = lib.mkForce no;
                STAGING_MEDIA = lib.mkForce (freeform null);
                STRICT_DEVMEM = no;
                SUNRPC_DEBUG = lib.mkForce no;
                TDX_GUEST_DRIVER = lib.mkForce no;
                TIPC = no;
                TLS = lib.mkForce no;
                TRANSPARENT_HUGEPAGE = lib.mkForce (freeform null);
                TRANSPARENT_HUGEPAGE_ALWAYS = lib.mkForce (freeform null);
                TRANSPARENT_HUGEPAGE_MADVISE = lib.mkForce (freeform null);
                TRUSTED_KEYS = yes;
                UDF_FS = lib.mkForce no;
                VFAT_FS = yes;
                WATCHDOG_CORE = yes;
                WERROR = lib.mkForce yes;
                X25 = no;
                X86_CPUID = no;
                X86_FRED = yes;
                X86_IOPL_IOPERM = no;
                X86_MSR = no;
                X86_POSTED_MSI = yes;
                X86_VSYSCALL_EMULATION = no;
                XEN_SAVE_RESTORE = lib.mkForce (freeform null);
                XFS_ONLINE_SCRUB_STATS = no;
                XOR_BLOCKS = yes;
                ZERO_CALL_USED_REGS = yes;
                ZRAM = lib.mkForce yes;
                ZSTD_COMPRESS = yes;
                ZSTD_DECOMPRESS = yes;
                ZSWAP = yes;
                ZSWAP_COMPRESSOR_DEFAULT_ZSTD = yes;
                ZSWAP_DEFAULT_ON = yes;
              };
            }
          ];
        });
      in
      {
        linux_patched = pkgs.linuxPackagesFor override;
      }
    )
  ];

  boot.tmp.cleanOnBoot = true;
}
