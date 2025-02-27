{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkMerge
    mkIf
  ;
  inherit (config.Tow-Boot) buildUBoot;
in
{
  device = {
    manufacturer = "PINE64";
    name = "PineTab2";
    identifier = "pine64-pinetab2";
    productPageURL = "https://www.pine64.org/pinetab2/";
    supportLevel = "supported";
  };

  hardware = {
    soc = "rockchip-rk3566";
    SPISize = 16 * 1024 * 1024; # 16 MiB
  };

  Tow-Boot = {
    defconfig = "rk3566-pinetab2_defconfig";
    phone-ux = {
      enable = true;
      blind = true;
      wip = {
        led_R = "led-red";
        led_G = "led-green";
        led_B = "led-blue";
        mmcSD   = "1";
        mmcEMMC = "0";
      };
    };
    config = mkMerge [
      [
      (helpers: with helpers; {
        TOW_BOOT_QUIRK_ROCKCHIP_DISABLE_DOWNLOAD_MODE = lib.mkIf (!config.Tow-Boot.buildUBoot) yes;
      })
      (helpers: with helpers; {
        CMD_POWEROFF = lib.mkForce yes;
      })
      (helpers: with helpers; {
        # NOTE: works around an issue with the config, where we hit:
        #     mmc fail to send stop cmd
        #     ** fs_devread read error - block
        MMC_IO_VOLTAGE = yes;
        MMC_SDHCI_SDMA = yes;
        MMC_SPEED_MODE_SET = yes;
        MMC_UHS_SUPPORT = yes;
        MMC_HS400_ES_SUPPORT = yes;
        MMC_HS400_SUPPORT = yes;
      })
      ]
      # Requires Tow-Boot patches
      (mkIf (!buildUBoot) [(helpers: with helpers;{
        BUTTON_GPIO = yes;
        BUTTON_ADC = yes;
        LED_GPIO = yes;
        VIBRATOR_GPIO = yes;
        USB_GADGET_MANUFACTURER = freeform ''"Pine64"'';
      })])
    ];
  };
  documentation.sections.installationInstructions = builtins.readFile ./INSTALLING.md;
}
