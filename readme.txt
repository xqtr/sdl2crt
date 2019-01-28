        __  _                        __ _                           _  __
  ______\ \_\\_______________________\///__________________________//_/ /______
  \___\                                                                   /___/
   | .__                                 __                                  |
   | |                   ___  __________/  |________                         |
   |                     \  \/  / ____/\   __\_  __ \                        |
   ;                      >    < <_|  | |  |  |  | \/                        ;
   :                     /__/\_ \__   | |__|  |__|                           :
   .                           \/  |__|      Releases                        .
   .                                                                         .
   :           H/Q Another Droid BBS - andr01d.zapto.org:9999                :
   ;                                                                         ;
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   :                                                                         :
   |                       SDL2CRT Unit for FreePascal                       |
   :                                                                         :
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   | ._          SoftWare         Oper.System      Type                      |
   ; |           - { } BASH       - {x} Linux      - { } ANSI                ;
   :             - { } DOOR       - {x} RPi        - { } TEXT                :
   .             - { } MPL        - {x} Windows    - {x} ASCII               .
   :             - { } Python     - { } Mac        - { } BINARY              :
   ;             - {x} Source     - { } OS/2                                 ;
   |                                                                         |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   |  _     _ _                                                              |
   ; |    _| | |_    ____  _         _     _                                 ;
   :     |_     _|  |    \|_|___ ___| |___|_|_____ ___ ___                   :
   .     |_     _|  |  |  | |_ -|  _| | .'| |     | -_|  _|   _ _ _          .
   ;       |_|_|    |____/|_|___|___|_|__,|_|_|_|_|___|_|    |_|_|_|         ;
   |                                                                         |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   ; The author has taken every precaution to insure that no harm or damage  ;
   | will occur on computer systems operating this util.  Never the less, the:
   ; author will NOT be held liable for whatever may happen on your computer .
   : system or to any computer systems which connects to your own as a result:
   . of. operating this util.  The user assumes full responsibility for the  ;
   : correct operation of this software package, whether harm or damage      |
   ; results from software error, hardware malfunction, or operator error.   :
   | NO warranties are : offered, expressly stated or implied, including     .
   | without limitation or ; restriction any warranties of operation for a   :
   ; particular purpose and/or | merchant ability.  If you do not agree with ;
   : this then do NOT use this program.                                      |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´

   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   |        _ _                                                              |
   ;      _| | |_    _____ _           _                                     ;
   :     |_     _|  |  _  | |_ ___ _ _| |_                                   :
   .     |_     _|  |     | . | . | | |  _|   _ _ _                          .
   ;       |_|_|    |__|__|___|___|___|_|    |_|_|_|                         ;
   |                                                                         |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
  
   This is a unit for freepascal, to write programs in GUI systems, like 
   Windows, Linux/X11, MacOS etc, in a style like a terminal program. You can
   use all 256 ASCII characters and build text based games, BBS stuff or 
   anything else you imagine.   
   
   You can get and download the programs from GitHub at:
                    
                      https://github.com/xqtr/sdl2crt
                      
            Report any bugs or features you want there also.

   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   |        _ _                                                              |
   ;      _| | |_    _____         _       _ _                               ;
   :     |_     _|  |     |___ ___| |_ ___| | |                              :
   .     |_     _|  |-   -|   |_ -|  _| .'| | |   _ _ _                      .
   ;       |_|_|    |_____|_|_|___|_| |__,|_|_|  |_|_|_|                     ;
   |                                                                         |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´

    Its a Unit... use it like any other free/pascal unit. See the included
    example.pas program for starting your own program.
 
    

   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   |        _ _                                                              |
   ;      _| | |_    _____         ___ _                                     ;
   :     |_     _|  |     |___ ___|  _|_|___                                 :
   .     |_     _|  |   --| . |   |  _| | . |   _ _ _                        .
   ;       |_|_|    |_____|___|_|_|_| |_|_  |  |_|_|_|                       ;
   |                                    |___|                                |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   
   Not exactly config... but you can use some stuff to customize a little bit
   your app.
   
   .:fonts:.
   
   The TSDLConsole object needs a PNG file with all 256 chars to display. This
   file must be 16x16 in char size. You can use any width/height in pixels.
   When you resize the window, the font will be stretched accordingly to keep 
   the original width/height ratio of the font.
   
   The object will look for a PNG file which its name is the width and height
   of the selected mode. For example if you choose a 80x25 mode, it will look
   for the 80x25.png. You can't start an app, without a font image file. You
   can specify another filename in the contructor, if you want.
   
   .:sound:.
   
   Included in the package you will find two WAV files, one for a click button
   fx and one for the bell sound. If you don't want the sound fxs, you can 
   delete those files or use your own files to change the sounds.
   
   .:icon:.
   
   You can specify and load an ICN file for the application window. Just use 
   the SetWindowIcon procedure.
   
   .:resize:.
   You can resize the window with the mouse or press ALT + ENTER to enter
   fullscreen mode or window mode.
   
   .:mouse select:.
   You can select text in the window with the mouse and copy it, to the 
   clipboard. There are two modes. If you select with the right mouse button
   it will select lines, but if you use the middle button it will select a 
   block. The text captured will be copied automatically.
   
   For now, you can't paste from the clipboard. I didn't implement it, because
   you can implement it in various ways, depending your app/project. So instead
   of narrowing down the way to paste text, you can implement your own way.
 

   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   |        _ _                                                              |
   ;      _| | |_    _____ _     _                                           ;
   :     |_     _|  |  |  |_|___| |_ ___ ___ _ _                             :
   .     |_     _|  |     | |_ -|  _| . |  _| | |   _ _ _                    .
   ;       |_|_|    |__|__|_|___|_| |___|_| |_  |  |_|_|_|                   ;
   |                                        |___|                            |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   
    .:. January 2019 
     `  + First Release
        
          
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
   |        _ _                                                              |
   ;      _| | |_    _____           _ _ _                                   ;
   :     |_     _|  |     |___ ___ _| |_| |_ ___                             :
   .     |_     _|  |   --|  _| -_| . | |  _|_ -|   _ _ _                    .
   ;       |_|_|    |_____|_| |___|___|_|_| |___|  |_|_|_|                   ;
   |                                                                         |
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´

   The hole project and idea was based on g00r00s idea for Netrunner and his
   open source code of his sdl2crt unit. I used his code to build this one, so
   all credits goes to him. 
   
   + --- --  -   .     -        ---    ---    ---        -     .    - -- --- ´
         _____         _   _              ____          _   _ 
        |  _  |___ ___| |_| |_ ___ ___   |    \ ___ ___|_|_| |        8888
        |     |   | . |  _|   | -_|  _|  |  |  |  _| . | | . |     8 888888 8
        |__|__|_|_|___|_| |_|_|___|_|    |____/|_| |___|_|___|     8888888888
                                                                   8888888888
                DoNt Be aNoTHeR DrOiD fOR tHe SySteM               88 8888 88
                                                                   8888888888
 /: HaM RaDiO   /: ANSi ARt!     /: MySTiC MoDS   /: DooRS         '88||||88'
 /: NeWS        /: WeATheR       /: FiLEs         /: SPooKNet       ''8888"'
 /: GaMeS       /: TeXtFiLeS     /: PrEPardNeSS   /: FsxNet            88
 /: TuTors      /: bOOkS/PdFs    /: SuRVaViLiSM   /: ArakNet    8 8 88888888888
                                                              888 8888][][][888
   TeLNeT : andr01d.zapto.org:9999 [UTC 11:00 - 20:00]          8 888888##88888
   SySoP  : xqtr                   eMAiL: xqtr@gmx.com          8 8888.####.888
   DoNaTe : https://paypal.me/xqtr                              8 8888##88##888
