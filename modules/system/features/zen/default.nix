{ self, inputs, ... }: {
  flake.nixosModules.zen-browser = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.zen-browser;
    ef  = self.lib.palette;

    extension = shortId: guid: {
      name = guid;
      value = {
        install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
        installation_mode = "normal_installed";
      };
    };

    extensions = [
      (extension "ublock-origin" "uBlock0@raymondhill.net")
      (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
      (extension "sponsorblock" "sponsorBlocker@ajay.app")
      (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
      (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
      (extension "darkreader" "addon@darkreader.org")
    ];

    lockedPrefs = {
      "extensions.autoDisableScopes" = 0;
      "extensions.pocket.enabled" = false;

      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.archive.enabled" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "app.shield.optoutstudies.enabled" = false;
      "browser.discovery.enabled" = false;

      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.topsites.contile.enabled" = false;
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;

      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;
      "privacy.donottrackheader.enabled" = true;
      "dom.security.https_only_mode" = true;
    };

    defaultPrefs = {
      "browser.aboutConfig.showWarning" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.contentblocking.category" = "strict";

      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "widget.use-xdg-desktop-portal.mime-handler" = 1;

      "media.ffmpeg.vaapi.enabled" = true;
      "gfx.webrender.all" = true;

      "ui.systemUsesDarkTheme" = 1;
      "layout.css.prefers-color-scheme.content-override" = 0;
      "browser.theme.toolbar-theme" = 0;
      "browser.theme.content-theme" = 0;

      "zen.theme.accent-color" = ef.green;
      "zen.view.compact.hide-toolbar" = true;
      "zen.workspaces.enabled" = true;
    };

    renderPrefs = fn: attrs:
      concatLines (mapAttrsToList
        (name: value: "${fn}(${builtins.toJSON name}, ${builtins.toJSON value});")
        attrs);

    nixSearch = name: url: alias: {
      Name = name;
      URLTemplate = url;
      IconURL = "https://wiki.nixos.org/favicon.ico";
      Alias = alias;
    };
  in {
    options.sys.zen-browser = {
      enable = mkEnableOption "Zen browser (policies, extensions, thème Everforest)";
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [
        (pkgs.wrapFirefox
          inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
          {
            extraPrefs = concatLines [
              (renderPrefs "lockPref" lockedPrefs)
              (renderPrefs "defaultPref" defaultPrefs)
            ];

            extraPolicies = {
              DisableTelemetry = true;
              DisableFirefoxStudies = true;
              DisablePocket = true;
              DontCheckDefaultBrowser = true;
              HardwareAcceleration = true;
              DisplayBookmarksToolbar = "newtab";
              DisplayMenuBar = "default-off";
              OfferToSaveLogins = false;
              PasswordManagerEnabled = false;

              EnableTrackingProtection = {
                Value = true;
                Locked = true;
                Cryptomining = true;
                Fingerprinting = true;
              };

              FirefoxHome = {
                Search = true;
                TopSites = false;
                SponsoredTopSites = false;
                Highlights = false;
                Pocket = false;
                SponsoredPocket = false;
                Snippets = false;
              };

              UserMessaging = {
                ExtensionRecommendations = false;
                SkipOnboarding = true;
              };

              ExtensionSettings = builtins.listToAttrs extensions;

              SearchEngines = {
                Default = "DuckDuckGo";
                Add = [
                  (nixSearch "nixpkgs packages" "https://search.nixos.org/packages?query={searchTerms}" "@np")
                  (nixSearch "NixOS options" "https://search.nixos.org/options?query={searchTerms}" "@no")
                  (nixSearch "NixOS Wiki" "https://wiki.nixos.org/w/index.php?search={searchTerms}" "@nw")
                  (nixSearch "Home Manager options" "https://home-manager-options.extranix.com/?query={searchTerms}" "@hm")
                  (nixSearch "noogle" "https://noogle.dev/q?term={searchTerms}" "@ng")
                ];
              };
            };
          })
      ];
    };
  };
}
