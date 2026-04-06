{
  config,
  lib,
  ...
}:

{
  # ANCHOR Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
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

    "intel_iommu=on"
    "amd_iommu=force_isolation"
    "efi=disable_early_pci_dma"
    "iommu=force"
    "iommu.passthrough=0"
    "iommu.strict=1"
    "bdev_allow_write_mounted=0"

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
    # "kernel.sysrq" = 0; # done via MAGIC_SYSRQ = no;
    # disable unprivileged user namespaces, Note: Docker, NH, and other apps may need this
    # "kernel.unprivileged_userns_clone" = 0; # commented out because it makes NH and other programs fail
    # restrict all usage of performance events to the CAP_PERFMON capability
    # "kernel.perf_event_paranoid" = 3; # done via SECURITY_PERF_EVENTS_RESTRICT = yes;
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
    # "net.core.default_qdisc" = "cake"; # done via NET_SCH_CAKE = yes; and DEFAULT_NET_SCH = "cake";
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
  # ANCHOR blacklisted modules
  boot.kernelPatches = [
    {
      name = "hardened";
      patch = null;
      structuredConfig = with lib.kernel; {
        # Memory
        INIT_ON_ALLOC_DEFAULT_ON = yes;
        INIT_ON_FREE_DEFAULT_ON = yes;
        SLAB_MERGE_DEFAULT = no;
        SHUFFLE_PAGE_ALLOCATOR = yes;
        HARDENED_USERCOPY = yes;
        HARDENED_USERCOPY_PAGESPAN = yes;
        STRICT_DEVMEM = yes;
        IO_STRICT_DEVMEM = yes;
        RANDSTRUCT_FULL = yes;
        SLAB_VIRTUAL = yes;
        FORTIFY_SOURCE = yes;
        UBSAN_BOUNDS = yes;
        SLAB_FREELIST_RANDOM = yes;
        SLAB_FREELIST_HARDENED = yes;

        # Kernel
        KALLSYMS = no;
        BUG_ON_DATA_CORRUPTION = yes;
        GCC_PLUGIN_STACKLEAK = yes;
        STACKLEAK_TRACK_MIN_SIZE = 128;
        HZ_1000 = yes;

        # CPU
        PAGE_TABLE_ISOLATION = yes;
        LEGACY_VSYSCALL_NONE = yes;
        RANDOMIZE_KSTACK_OFFSET_DEFAULT = yes;
        MZEN3 = yes;
        MODIFY_LDT_SYSCALL = no;

        # CPU mitigations
        MITIGATION_SPECTRE_V2 = yes;
        MITIGATION_SPECTRE_BHI = yes;
        MITIGATION_GDS = yes;
        MITIGATION_RFDS = yes;

        # Policies
        SECURITY_LOCKDOWN_LSM = yes;
        SECURITY_LOCKDOWN_LSM_EARLY = yes;
        LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY = yes;
        DEBUG_FS = no;
        PANIC_ON_OOPS = yes;
        MAGIC_SYSRQ = no;
        SECURITY_PERF_EVENTS_RESTRICT = yes;
        KEXEC = no;
        TCP_CONG_BBR = yes;
        DEFAULT_BBR = yes;
        NET_SCH_CAKE = yes;
        DEFAULT_NET_SCH = "cake";

        # IOMMU
        IOMMU_DEFAULT_DMA_STRICT = yes;
        IOMMU_DEFAULT_PASSTHROUGH = no;
        INTEL_IOMMU = yes;
        INTEL_IOMMU_DEFAULT_ON = yes;
        AMD_IOMMU = yes;

        # ZSwap
        ZSWAP = yes;
        ZSWAP_DEFAULT_ON = yes;
        ZSWAP_COMPRESSOR_DEFAULT_ZSTD = yes;
        ZSWAP_ZPOOL_DEFAULT_ZSMALLOC = yes;

        # Disable modules
        IP_DCCP = no;
        IP_SCTP = no;
        RDS = no;
        TIPC = no;
        N_HDLC = no;
        AX25 = no;
        NETROM = no;
        X25 = no;
        ROSE = no;
        DECNET = no;
        ECONET = no;
        AF_802154 = no;
        IPX = no;
        ATALK = no;
        CAN = no;
        ATM = no;

        CRAMFS = no;
        VXFS_FS = no;
        JFFS2_FS = no;
        HFS_FS = no;
        HFSPLUS_FS = no;
        UDF_FS = no;
        CIFS = no;
        NFS_FS = no;
        NFSV3 = no;
        NFSV4 = no;
        KSMBD = no;
        GFS2_FS = no;

        VIDEO_VIVID = no;
        N_GSM = no;

        LEGACY_PTYS = no;
        LDISC_AUTOLOAD = no;
      };
    }
  ];
  # ANCHOR modules
  boot.kernelModules = [
    "jitterentropy_rng"
    "hid_t150"
  ];
  # ANCHOR extra module packagess
  boot.extraModulePackages = [
    config.boot.kernelPackages.hid-t150
  ];
  # ANCHOR initrd
  boot.initrd.kernelModules = [
    "zstd"
    "zsmalloc"
  ];
  # ANCHOR ntfs
  boot.supportedFilesystems = [ "ntfs" ];

  boot.tmp.cleanOnBoot = true;
}
