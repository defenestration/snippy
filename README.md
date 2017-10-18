#Snippy
poor mans text snippet expander

Written by "mhwombat": https://bbs.archlinux.org/viewtopic.php?id=71938&p=2
 
Based on "snippy" by "sessy" 
 (https://bbs.archlinux.org/viewtopic.php?id=71938)

Other mods by defenestration

You will also need "dmenu", "xsel" and "xdotool". Get them from your linux
 distro in the usual way.

This version of snippy is set to emulate typing, so it will try to type the snippet into the window, this means you could interrupt it if you mash the keyboard during execution.  This is a bit easier to use with both browsers and terminals though. See above for a version that uses the clipboard/paste buffer.

Likely this will not work under Wayland as it uses xsel/xdotool, welcome to try though. 

To use:

1. Create the directory ~/.snippy
2. Create a file in that directory for each snippet that you want. The filename will be used as a menu item, so you might want to omit the file extension when you name the file. 

    TIP: If you have a lot of snippets, you can organise them into 
    subdirectories under ~/.snippy.

    TIP: The contents of the file will be pasted asis, so if you 
    don't want a newline at the end when the text is pasted, don't
    put one in the file.
3. Bind a convenient key combination to this script.

    TIP: If you're using XMonad, add something like this to xmonad.hs
      ((mod4Mask, xK_s), spawn "/path/to/snippy")
4. Use your shortcut and select the option to output.



