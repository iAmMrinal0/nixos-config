{ lib, pkgs, systems, ... }:

{
  enable = true;
  package = if builtins.currentSystem == systems.darwin then
    pkgs.Firefox
  else
    pkgs.firefox-unwrapped;
  extensions = (with pkgs.nur.repos.rycee.firefox-addons; [
    darkreader
    privacy-badger
    reddit-enhancement-suite
    ublock-origin
    https-everywhere
    multi-account-containers
    keepassxc-browser
    vimium
    octotree
    refined-github
    sponsorblock
    bypass-paywalls
    pkgs.nur.repos.ethancedwards8.firefox-addons.enhancer-for-youtube
  ]);
  profiles = lib.optionalAttrs (builtins.currentSystem == systems.linux) ({
    default.settings = {
      "browser.sessionstore.warnOnQuit" = true;
      "browser.aboutConfig.showWarning" = false;
      "browser.ctrlTab.recentlyUsedOrder" = false;
      "browser.download.panel.shown" = true;
      "browser.newtab.extensionControlled" = true;
      "browser.newtab.privateAllowed" = true;
      "findbar.highlightAll" = true;
      "privacy.donottrackheader.enabled" = true;
      "signon.autofillForms" = false;
      "signon.importedFromSqlite" = true;
      "signon.rememberSignons" = false;
      "signon.usage.hasEntry" = true;
    };
  });
}
