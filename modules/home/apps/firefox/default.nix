{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.polytope.apps.firefox;

  firefox-cascade = pkgs.fetchFromGitHub {
    # Using darkKronicle's cascade theme
    name = "firefox-cascade";
    owner = "DarkKronicle";
    repo = "cascade";
    rev = "994edba071341b4afa9483512d320696ea10c0a6";
    sha256 = "sha256-DX77qLtDktv077YksxnrSoqa8O0ujJF2NH36GkENaXI=";
  };
in
{
  options.polytope.apps.firefox = {
    enable = mkEnableOption "Firefox";
    userCss = mkEnableOption "Use Custom CSS Theming"; # Todo: nake this actually work :p
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      # This method for installing plugins here largely from:
      # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/7
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {

          # Settings:
          # https://mozilla.github.io/policy-templates/
          DisableTelemetry = true;
          DisableFirefoxAccounts = true;
          DisablePocket = true;
          OfferToSaveLogins = false;
          OfferToSaveLoginsDefault = false;

          # // -- Extensions -- //
          ExtensionSettings = {
            # This does not manage the settings of the extension

            #"*".installation_mode = "blocked"; # blocks all addons except the ones specified below

            # The workflow seems to be:
            # ~ Manually install the extension, get the filename created in ~/.mozilla/firefox/[Profile]/extensions/[newExtensionEntry]
            # ~ Right click copy url the install link from firefox to get the "simple name" for the extension (replace '_' with '-')
            # ~ Create a new instance here, using the new filename from above as the string, the simple name in the install url
            # - install modes include "blocked", "normal_installed", "force_installed"

            # uBlock Origin:
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
            # Privacy Badger
            "jid1-MnnxcxisBPnSXQ@jetpack" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
              installation_mode = "force_installed";
            };
            # KeepassXC
            "keepassxc-browser@keepassxc.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
              installation_mode = "normal_installed";
            };
            # Dark Reader
            "addon@darkreader.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
              installation_mode = "normal_installed";
            };
            # Better Canvas
            "{8927f234-4dd9-48b1-bf76-44a9e153eee0}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/better-canvas/latest.xpi";
              installation_mode = "normal_installed";
            };
            # Sidebery
            "{3c078156-979c-498b-8990-85f7987dd929}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
              installation_mode = "normal_installed";
            };
            # Jump-Cutter
            "jump-cutter@example.com.xpi" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/jump-cutter/latest.xpi";
              installation_mode = "normal_installed";
            };
            # Old-Reddit redirect
            "{9063c2e9-e07c-4c2c-9646-cfe7ca8d0498}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/old-reddit-redirect/latest.xpi";
              installation_mode = "normal_installed";
            };
            # Sponsorblock
            "sponsorBlocker@ajay.app" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
              installation_mode = "normal_installed";
            };
            # Dearrow
            "deArrow@ajay.app" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi";
              installation_mode = "normal_installed";
            };
            # YT auto full hd
            #"why it no have a thing I can find for here" = {
            #  install_url = "https://addons.mozilla.org/firefox/downloads/file/4285305/youtube_auto_hd_fps-1.8.25.xpi";
            #  installation_mode = "normal_installed";
            #};
          };
        };
      };

      profiles = {
        main = {
          id = 0;
          name = "main";
          isDefault = true;
          userChrome = mkIf cfg.userCss ''
            @import "${firefox-cascade}/chrome/userChrome.css";
          '';

          search = {
            force = true;
            default = "SearXNG";
            engines = {
              "SearXNG" = {
                definedAliases = [ "@sx" ];
                urls = [
                  {
                    template = "https://searx.bndkt.io/";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
              };
            };
          };

          # Custom bookmarks
          bookmarks = [
            {
              name = "wormhole - fileSharing";
              tags = [ "Tools" ];
              url = "https://wormhole.app/";
            }
            {
              name = "flashpaper - secretSharing";
              tags = [ "Tools" ];
              url = "https://darkkronicle.com/";
            }
            {
              name = "gartbin";
              tags = [ "Tools" ];
              url = "https://bin.gart.sh";
            }
            {
              name = "RegexCheatSheet - DaveChild";
              tags = [
                "Reference"
                "Regex"
              ];
              url = "https://cheatography.com/davechild/cheat-sheets/regular-expressions/";
            }
            {
              name = "Monkeytype";
              tags = [ "Fun" ];
              url = "https://monkeytype.com/";
            }
            {
              name = "Linux Weekly News";
              tags = [ "Reading" ];
              url = "https://lwn.net/Archives/";
            }
            {
              name = "Blahaj Zone";
              tags = [ "Reading" ];
              url = "https://shonk.social/";
            }
            {
              name = "Lospec Palettes";
              tags = [ "Reference" ];
              url = "https://lospec.com/palette-list";
            }
            {
              name = "Downgit";
              tags = [ "Tools" ];
              url = "https://minhaskamal.github.io/DownGit/#/home";
            }
            {
              name = "Homemanger Options";
              tags = [
                "Nix"
                "Reference"
              ];
              url = "https://home-manager-options.extranix.com/";
            }
            {
              name = "Nix Package Search";
              tags = [
                "Nix"
                "Reference"
              ];
              url = "https://search.nixos.org/packages";
            }
            {
              name = "Nazarick";
              tags = [
                "Nix"
                "Reference"
              ];
              url = "https://github.com/darkkronicle/nazarick";
            }
            {
              name = "Sort Visualizer";
              tags = [ "Reference" ];
              url = "https://www.sortvisualizer.com";
            }
            {
              name = "OEIS";
              tags = [ "Reference" ];
              url = "https://oeis.org/A000040";
            }
          ];

          settings = {
            # My user settings:
            "browser.ctrlTab.sortByRecentlyUsed" = true;
            "browser.toolbars.bookmarks.visibility" = "never";

            # My added settings:
            "browser.firefox-view.feature-tour" = "{\"screen\":\"FIREFOX_VIEW_SPOTLIGHT\",\"complete\":true}";
            "browser.pdfjs.feature-tour" = "{\"screen\":\"\",\"complete\":false}";
            "browser.newtabpage.activity-stream.system.showSponsored" = false;
            "browser.newtabpage.activity-stream.discoverystream.enabled" = false;
            "browser.newtabpage.activity-stream.discoverystream.sendToPocket.enabled" = false;
            "extensions.pocket.enabled" = false;
            "browser.newtabpage.activity-stream.discoverystream.saveToPocketCard.enabled" = false;
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
            "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
            "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsored" = false;
            "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.shell.skipDefaultBrowserCheckOnFirstRun" = true;
            "dom.private-attribution.submission.enabled" = false; # New firefox 128 'privacy respecting attribution"

            # Arkenfox: stolen from nazarick config:
            # https://github.com/DarkKronicle/nazarick/blob/main/modules/home/apps/firefox/default.nix
            # https://arkenfox.github.io/gui/
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "widget.use-xdg-desktop-portal.file-picker" = 1; # Okay so it's a xdg issue not firefox config issue?
            "browser.aboutConfig.showWarning" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.activity-stream.default.sites" = "";
            "extensions.getAddons.showPane" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "browser.discovery.enabled" = false;
            "browser.shopping.experience2023.enabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.server" = "data:,";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.coverage.opt-out" = true;
            "toolkit.telemetry.opt-out" = true;
            "toolkit.telemetry.endpoint.base" = "";
            "browser.ping-centre.telemetry" = false;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "breakpad.reportURL" = false;
            "browser.tabs.crashReporting.sendReport" = false;
            "browser.crashReports.unsubmittedCheck.enabled" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
            "network.http.speculative-parallel-limit" = false;
            "browser.send_pings" = false;
            "browser.urlbar.pocket.featureGate" = false;
            "browser.urlbar.weather.featureGate" = false;
            "browser.urlbar.mdn.featureGate" = false;
            "browser.urlbar.addons.featureGate" = false;
            "browser.urlbar.trending.featureGate" = false;
            "browser.urlbar.suggest.quicksuggest.sponsored" = false;
            "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
            "browser.urlbar.speculativeConnect.enabled" = false;
            "security.ssl.require_safe_negotiation" = true; # May cause issues
            "dom.security.https_only_mode" = true;
            "network.http.referer.XOriginTrimmingPolicy" = 2; # May cause issues
            "network.IDN_show_punycode" = true;
            "browser.download.useDownloadDir" = false;
            "browser.download.alwaysOpenPanel" = false;
            "browser.download.manager.addToRecentDocs" = false;
            "browser.download.always_ask_before_handling_new_types" = false;
            "browser.contentblocking.category" = "strict"; # May cause issues
            "browser.link.open_newwindow" = 3; # May cause issues

            # Nazarick does this at system level, I dont yet
            "network.trr.uri" = "https://dns.quad9.net/dns-query";
            "network.trr.custom_uri" = "https://dns.quad9.net/dns-query";

            # Don't touch
            "extensions.blocklist.enabled" = true;
            "network.http.referer.spoofSource" = false;
            "security.dialog_enable_delay" = 1000;
            "extensions.webcompat.enable_shims" = true;
            "extensions.webcompat-reporter.enabled" = false;
          };
        };
      };
    };
  };
}
