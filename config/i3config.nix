{ pkgs, i3blocksConf, keepmenu, rofimoji, ... }:

with pkgs;

let
  lock = import ../scripts/lock.nix { inherit pkgs; };
  shutdownMenu = import ../scripts/shutdownMenu.nix { inherit pkgs lock; };
  rofiAutorandr = import ../scripts/rofiAutorandr.nix { inherit pkgs; };
  fontSize = "13px";
  workspaces = [" term" " code" " web" "♪ music" " avoid" "scratch" "scratch" "scratch" " bg"];
  fonts = [ "FontAwesome ${fontSize}" "Source Code Pro Medium ${fontSize}" ];
  numbers = map toString (lib.range 1 9);
  workspaceNumbers = lib.zipListsWith (x: y: x + " " + y) numbers workspaces ;
  useWithModifier = mod: lib.mapAttrs' (k: v: lib.nameValuePair (mod + "+" + k) v);
  appendExecToCommand = lib.mapAttrs' (k: v: lib.nameValuePair k ("exec " + v));
in
{
  enable = true;
  config = rec {
    inherit fonts;
    modifier = "Mod4";
    assigns = {
      "\"${lib.elemAt workspaceNumbers 1}\"" = [{ class = "Emacs"; }];
      "\"${lib.elemAt workspaceNumbers 3}\"" = [{ class = "Vlc"; }];
      "\"${lib.elemAt workspaceNumbers 4}\"" = [{ class = "Slack"; } {class = "discord";}];
    };
    bars = [{
      inherit fonts;
      position = "top";
      trayOutput = "primary";
      statusCommand = "${i3blocks}/bin/i3blocks -c ${i3blocksConf}";
      colors = {
        background = "#1d2021";
        statusline ="#ebdbb2";
        separator="#666666";
        inactiveWorkspace = {border = "#504945"; background="#504945"; text="#ebdbb2";};
        activeWorkspace = {border = "#1d2021"; background="#1d2021"; text=" #ebdbb2";};
        focusedWorkspace = {border = "#1d2021"; background="#1d2021"; text=" #ebdbb2";};
        urgentWorkspace = {border = "#fb4933"; background="#fb4933"; text="#ebdbb2";};
      };
    }];
    window = {
      hideEdgeBorders = "both";
      commands = [
        { command = "border pixel 0"; criteria = { class = "^.*"; }; }
        { command = "move to workspace \"${lib.elemAt workspaceNumbers 3}\""; criteria = { class = "Spotify"; }; }
      ];
    };
    startup = [
      { command = "${xorg.xset}/bin/xset -b"; }
      { command = "${transmission-gtk}/bin/transmission-gtk --minimized"; }
      { command = "${rescuetime}/bin/rescuetime"; }
      { command = "${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ 25%"; }
      { command = "${numlockx}/bin/numlockx on"; }
    ];
    modes = {
      resize = {
        h = "resize shrink width 10 px or 10 ppt";
        j = "resize shrink height 10 px or 10 ppt";
        k = "resize grow height 10 px or 10 ppt";
        l = "resize grow width 10 px or 10 ppt";
        Down = "resize grow height 10 px or 10 ppt";
        Left = "resize shrink width 10 px or 10 ppt";
        Right = "resize grow width 10 px or 10 ppt";
        Up = "resize shrink height 10 px or 10 ppt";
        Return = "mode default";
        Escape = "mode default";
      };
    };
    colors = {
      unfocused = {
        border = "#665c54";
        background = "#665c54";
        text = "#eddbb2";
        indicator = "#2e9ef4";
        childBorder= "#665c54";
      };

      focusedInactive = {
        border= "#282828";
        background = "#5f676a" ;
        text = "#ffffff";
        indicator = "#484e50";
        childBorder = "#5f676a";
      };

      focused = {
        border= "#1d2021";
        background = "#1d2021";
        text = "#a89984";
        indicator = "#292d2e";
        childBorder = "#222222";
      };

      urgent = {
        border= "#fb4933";
        background = "#fb4933";
        text = "#ebdbb2";
        indicator = "#fb4933";
        childBorder = "#fb4933";
      };

      placeholder = {
        border= "#000000";
        background = "#0c0c0c";
        text = "#ffffff";
        indicator = "#000000";
        childBorder = "#0c0c0c";
      };
    };
    keybindings = useWithModifier modifier ({
      "Control+l" = "exec ${shutdownMenu}";
      "Control+e" = "exec ${emacs}/bin/emacsclient -a '' -c";
      "Control+mod1+p" = "exec ${playerctl}/bin/playerctl play-pause";
      "Control+mod1+Right" = "exec ${playerctl}/bin/playerctl next";
      "Control+mod1+Left" = "exec ${playerctl}/bin/playerctl previous";
      "Control+mod1+Up" = "exec ${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "Control+mod1+Down" = "exec ${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "Control+mod1+m" = "exec ${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "Return" = "exec ${kitty}/bin/kitty";
      "Shift+Return" = "exec ${kitty}/bin/kitty tmux";
      "g" = ''exec ${wmfocus}/bin/wmfocus --fill -c asdf --textcolor red'';
      "Control+k" = "exec ${keepmenu}/bin/keepmenu";
      "Control+p" = "exec ${rofimoji}/bin/rofimoji -p";
      "t" = ''exec ${libnotify}/bin/notify-send -t 5000 "`date +%H:%M`" "`date +%A` `date +%d` `date +%B` `date +%Y` - Week `date +%U`"'';
      "a" = "focus child";
      "Control+Down" = "move workspace to output down";
      "Control+Up" = "move workspace to output up";
      "Control+Left" = "move workspace to output left";
      "Control+Right" = "move workspace to output right";
      "Shift+c" = "reload";
      "Shift+r" = "restart";
      "d" = "exec ${rofi}/bin/rofi -show run";
      "Control+d" = "exec i3-dmenu-desktop --dmenu 'rofi -dmenu'";
      "Control+w" = "exec ${rofi}/bin/rofi -show window";
      "p" = "exec ${rofiAutorandr}";
      "e" = "layout toggle stacking tabbed splith splitv";
      "f" = "fullscreen toggle";
      "Tab" = "workspace back_and_forth";
      "h" = "focus left";
      "j" = "focus down";
      "k" = "focus up";
      "l" = "focus right";
      "Left" = "focus left";
      "Down" = "focus down";
      "Up" = "focus up";
      "Right" = "focus right";
      "minus" = "split vertical";
      "bar" = "split horizontal";
      "Shift+q" = "kill";
      "r" = "mode resize";
      "Shift+a" = "focus parent";
      "q" = "move scratchpad";
      "x" = "scratchpad show";
      "Shift+h" = "move left";
      "Shift+j" = "move down";
      "Shift+k" = "move up";
      "Shift+l" = "move right";
      "Shift+Left" = "move left";
      "Shift+Down" = "move down";
      "Shift+Up" = "move up";
      "Shift+Right" = "move right";
      "Shift+space" = "floating toggle";
      "s" = "layout stacking";
      "space" = "focus mode_toggle";
      "w" = "layout tabbed";
    } //
    lib.foldl (x: y: x // y) {}
      (lib.zipListsWith
        (i: n: {
          "${i}" = "workspace ${n}";
          "Shift+${i}" = "move container to workspace ${n}; workspace ${n}";
        })
        numbers
        workspaceNumbers)
    ) // appendExecToCommand ({
      "XF86AudioRaiseVolume" = "${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" = "${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioMute" = "${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";

      "XF86AudioPlay" = "${playerctl}/bin/playerctl play-pause";
      "XF86AudioNext" = "${playerctl}/bin/playerctl next";
      "XF86AudioPrev" = "${playerctl}/bin/playerctl previous";

      "XF86MonBrightnessUp" = "${light}/bin/light -A 10";
      "XF86MonBrightnessDown" = "${light}/bin/light -U 10";

      "Print" = "${gnome3.gnome-screenshot}/bin/gnome-screenshot -i";

      "Control+mod1+l" = "${lock}";
    });
  };
}
