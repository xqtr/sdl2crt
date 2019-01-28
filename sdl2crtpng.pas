Unit sdl2crtpng;

{
   ====================================================================
   xLib                                                            xqtr
   ====================================================================

   This file is part of xlib for FreePascal
   
   https://github.com/xqtr/xlib
    
   This is an implementation of the crt unit, but with SDL2 graphics.
   The original idea came when i saw Netrunner app, by g00r00 and after
   that i found some code, from an old Mystic BBS version, which included
   a unit with exactly what i wanted to do!!! So i took this original unit
   and added more features to be a completely usable unit, to build
   "terminal" like applications in window servers. 
   
   Original code can be found here:
                  https://github.com/fidosoft/mysticbbs
                   
   Unfortunately g00r00 has made his code closed-source so, i had to 
   "re-invent the wheel", i hope that in the future he may change his mind.
   I have to thank him, cause his code is an inspiration for me and i have 
   learned a lot. So, all credits goes to him.   
    
   For contact look at Another Droid BBS [andr01d.zapto.org:9999],
   FSXNet and ArakNet.
   
   --------------------------------------------------------------------
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
}

{$mode objfpc}
{$H-}
{$codepage cp437}

Interface

Uses
  {$IFDEF UNIX}
    cthreads,
  {$ENDIF}
  SDL2,
  SDL2_mixer,
  SDL2_image;

Const
  BlockDrawTiming      = 150;
  
  keyENTER             = #13;
  keyESCAPE            = #27;
  keyHOME              = #71;
  keyUP                = #72;
  keyPGUP              = #73;
  keyLEFT              = #75;
  keyRIGHT             = #77;
  keyEND               = #79;
  keyDOWN              = #80;
  keyPGDN              = #81;
  keyINSERT            = #82;
  keyDELETE            = #83;
  
  KeyBackSpace     = #8;
  KeyTab           = #9;
  Keyforwardslash  = #47;
  Keyasterisk      = #42;
  Keyminus         = #45;
  Keyplus          = #43;
  KeyF1            = #59;
  KeyF2            = #60;
  KeyF3            = #61;
  KeyF4            = #62;
  KeyF5            = #63;
  KeyF6            = #64;
  KeyF7            = #65;
  KeyF8            = #66;
  KeyF9            = #67;
  KeyF10           = #68;
  KeyF11           = #69;
  KeyF12           = #70;

  AppInputSize         = 128;
  SDLFontSpace  : Byte = 0;
  SDLAppWindowX : Word = 800;
  SDLAppWindowY : Word = 600;
  
  mbLEFT               = 1;
  mbRIGHT              = 2;
  mbMIDDLE             = 3;
  mbDown               = 4;
  mbUp                 = 5;
  
  mode_80x25  = 1;
  mode_80x50  = 2;
  mode_132x50 = 3;
  
  {$IFDEF Windows}
    CRLF = #13#10;
  {$ENDIF}
  {$IFDEF Unix}
    CRLF = #13#10;
  {$ENDIF}

Type
  
  TSDLKeyMap = Record
    SDL   : Word;
    Key   : String[2];
    Shift : String[2];
    Alt   : String[2];
    Ctrl  : String[2];
  End;
  
  TScreenChar = Record
    Ch  : Char;
    Attr: Byte;
  End;
  
  TScreenLine = Array of TScreenChar;
  TScreen     = Array of TScreenLine;

  TSDLConsole = Class
    Buffer      : TScreen;
    Mode        : Byte;
    WindowWidth : Integer;
    WindowHeight: Integer;
    ScreenRect  : TSDL_Rect;
    isFullScreen: Boolean;
    BufferChanged:Boolean;
    SoundOn     : Boolean;
    ClickOn     : Boolean;
    BellOn      : Boolean;
    PauseDraw   : Boolean;
    
    sClick      : PMix_Chunk;
    sBell       : PMix_Chunk;
    
    ClickThread : PSDL_Thread;
    
    mbButton    : Byte;
    mbXp        : Integer; // mouse pointer pos in pixels
    mbYp        : Integer; // mouse pointer pos in pixels
    mbXc        : byte; // mouse pointer pos in blocks/cursor
    mbYc        : byte; // mouse pointer pos in blocks/cursor
    mX          : Integer;
    mY          : Integer;
    kpress      : boolean;
    
    BufferWidth : Byte;
    BufferHeight: Byte;
    SDLFontSize : Byte;
    SDLFontFile : String;
    FontChar    : Array[0..255] of TSDL_Rect;
    
    InputEvent  : pSDL_EVENT;
    ScreenBuf   : pSDL_SURFACE;
    Screen      : pSDL_SURFACE;
    Icon        : pSDL_SURFACE;
    cursor      : pSDL_SURFACE;
    tile        : pSDL_SURFACE;
    CopySurface : pSDL_SURFACE;
    TileRect    : TSDL_Rect;
    CopyRect    : TSDL_Rect;    
    FontImg     : pSDL_SURFACE;
    Window      : PSDL_Window;

    InputBuffer : Array[1..AppInputSize] of Char;
    InputPos    : Integer;
    InputSize   : Integer;

    WhereX     : Byte;
    WhereY     : Byte;
    TextAttr    : Byte;
    Seth        : Char;
    FontHeight  : Word;
    FontWidth   : Word;
    CursorOn    : Boolean;
    EnableCursor: Boolean;
    CopyOn      : Byte;
    
    OnMouseKey  : Procedure(x,y:integer; Button:Byte; State:byte);
    Procedure   Log(Str:string);
    Procedure   ScrollBufferUp;
    Function    GetSDLFGColor:Byte;
    Function    GetSDLBGColor:Byte;
    procedure   fillbuffer;  // this is only for test purposes.
    Procedure   ShowMouseCursor;

    Constructor Create (InitMode: Byte; Title,FontFile:String);
    Destructor  Destroy;         Override;

    Procedure   PushInput        (Ch: Char);
    Procedure   PushExt          (Ch: Char);
    Procedure   PushStr          (Str: String);
    Procedure   ProcessEvent;
    Procedure   CopyClipboard1;
    Procedure   CopyClipboard2;
   
    Procedure   ResizeWindow(w,h:integer);
    //Procedure   ApplyFontChange(size:integer);
    Procedure   UpdateScreenBuffer;
    
    Function    SetWindowIcon(icn:String):Boolean;
    Function    Pixel2Cursor(Var R:TSDL_Rect):TSDL_Rect;
    Procedure   ShowCursor;
    Procedure   DrawLineSelection;
    Procedure   DrawBlockSelection;
    Procedure   Draw;
    Procedure   ProcessEvents;
    Procedure   DisableCursor;
    Procedure   TakeScreenShot(filename:string);
    Procedure   SetClipboardText(s:string);
    Function    GetClipBoardText:String;
    procedure   transrect(r:TSDL_Rect);
    
    Procedure   RestoreScreen(sBuf: TScreen);
    Procedure   SaveScreen(var sBuf: TScreen);
    Procedure   ClrScr;
    procedure   ClearEOL;
    Function    GetAttrAt(AX, AY: Byte): Byte;
    Function    GetCharAt(AX, AY: Byte): Char;
    Procedure   SetAttrAt(AAttr, AX, AY: Byte);
    Procedure   SetCharAt(ACh: Char; AX, AY: Byte);
    Procedure   SetTextAttr(Attr:Byte);
    Procedure   GotoXY(x,y:Byte);
    Procedure   GotoY(y:Byte);
    Procedure   GotoX(x:Byte);
    Procedure   WriteChar(Ch:Char);
    Procedure   WriteStr(Str:String);
    Procedure   Write(Str:String);
    Procedure   WriteLn(Str:String);
    Procedure   WriteXY(X,Y,A:Byte; Str:String);
    Procedure   WritePipe (Str: String);
    Procedure   WritePipeB (Str: String);
    Procedure   WriteXYPipe (X, Y, Attr: Integer; Text: String);
    
    Function    KeyPressed       : Boolean;
    Function    ReadKey          : Char;
    Procedure   Delay            (MS: LongInt);
    Procedure   ShowBuffer;
    
    
  End;

Implementation

Const
      
  SDLKeyMapSize = 21;

  SDLKeyMapUS : Array[1..SDLKeyMapSize] of TSDLKeyMap = (
    (SDL:SDLK_1;      Key:'1';   Shift:'!';   Alt:'1';   CTRL:'1'),
    (SDL:SDLK_2;      Key:'2';   Shift:'@';   Alt:'2';   CTRL:'2'),
    (SDL:SDLK_3;      Key:'3';   Shift:'#';   Alt:'3';   CTRL:'3'),
    (SDL:SDLK_4;      Key:'4';   Shift:'$';   Alt:'4';   CTRL:'4'),
    (SDL:SDLK_5;      Key:'5';   Shift:'%';   Alt:'5';   CTRL:'5'),
    (SDL:SDLK_6;      Key:'6';   Shift:'^';   Alt:'6';   CTRL:'6'),
    (SDL:SDLK_7;      Key:'7';   Shift:'&';   Alt:'7';   CTRL:'7'),
    (SDL:SDLK_8;      Key:'8';   Shift:'*';   Alt:'8';   CTRL:'8'),
    (SDL:SDLK_9;      Key:'9';   Shift:'(';   Alt:'9';   CTRL:'9'),
    (SDL:SDLK_0;      Key:'0';   Shift:')';   Alt:'0';   CTRL:'0'),
    
    (SDL:SDLK_SEMICOLON;   Key:';';   Shift:':';   Alt:';';   CTRL:';'),
    (SDL:SDLK_COMMA;       Key:',';   Shift:'<';   Alt:',';   CTRL:','),
    (SDL:SDLK_MINUS;       Key:'-';   Shift:'_';   Alt:'-';   CTRL:'-'),
    (SDL:SDLK_PERIOD;      Key:'.';   Shift:'>';   Alt:'.';   CTRL:'.'),
    (SDL:SDLK_LEFTBRACKET; Key:'[';   Shift:'{';   Alt:'[';   CTRL:'['),
    (SDL:SDLK_RIGHTBRACKET;Key:']';   Shift:'}';   Alt:']';   CTRL:']'),
    (SDL:SDLK_BACKSLASH;   Key:'\';   Shift:'|';   Alt:'|';   CTRL:'|'),
    (SDL:SDLK_BACKQUOTE;   Key:'`';   Shift:'~';   Alt:'`';   CTRL:'`'),
    (SDL:SDLK_QUOTE;       Key:'''';  Shift:'"';   Alt:'''';   CTRL:''''),
    (SDL:SDLK_EQUALS;          Key:'=';   Shift:'+';   Alt:'=';   CTRL:'='),
    
    (SDL:SDLK_SLASH;  Key:'/';   Shift:'?';   Alt:'/';   CTRL:'/')
  );

  SDLDosColor : Array[0..15] of TSDL_Color = (
    (R:000;   G:000;   B:000;  a: 0), //00
    (R:000;   G:000;   B:128;  a: 0), //01
    (R:000;   G:128;   B:000;  a: 0), //02
    (R:000;   G:128;   B:128;  a: 0), //03
    (R:170;   G:000;   B:000;  a: 0), //04
    (R:128;   G:000;   B:128;  a: 0), //05
    (R:128;   G:128;   B:000;  a: 0), //06
    (R:192;   G:192;   B:192;  a: 0), //07
    (R:128;   G:128;   B:128;  a: 0), //08
    (R:000;   G:000;   B:255;  a: 0), //09
    (R:000;   G:255;   B:000;  a: 0), //10
    (R:000;   G:255;   B:255;  a: 0), //11
    (R:255;   G:000;   B:000;  a: 0), //12
    (R:255;   G:000;   B:255;  a: 0), //13
    (R:255;   G:255;   B:000;  a: 0), //14
    (R:255;   G:255;   B:255;  a: 0)  //15
  );

Function Int2Str (N: LongInt): String;
Var
  T : String;
Begin
  Str(N, T);
  Int2Str := T;
End;

Function Str2Int (Str: String): LongInt;
Var
  N : LongInt;
  T : LongInt;
Begin
  Val(Str, T, N);
  Str2Int := T;
End;
  
Constructor TSDLConsole.Create (InitMode: Byte; Title,FontFile:String);
Var
  i,x,y : Byte;
  di : TSDL_DisplayMode;
  text:string;
Begin
  Inherited Create;
  PauseDraw:=True;
  if SDL_Init( SDL_INIT_VIDEO ) < 0 then Begin
    Log('Error Initializing SDL');
    HALT;
  End;
  Title := Title + #0;    
  
  //Init Font
  SDLFontFile := Fontfile+#0;
  
  text:=FontFile+#0;
  //Fontimg:=SDL_CreateRGBSurface( 0,16*FontWidth,16*FOntheight, 32, 0, 0, 0, 100 );
  If FontFile='' Then 
    Case InitMode Of
      mode_80x25  : Text := '80x25.png'+#0;
      mode_80x50  : Text := '80x50.png'+#0;
      mode_132x50 : Text := '132x50.png'+#0;
    End;
  Try
    FontImg := IMG_Load(PChar(@text[1]));
  Except
    Log('Could Not Load Font File.');
    Halt;
  End;
  If FontImg=Nil Then Begin
    Log('Could Not Load Font File.');
    Halt;
  End;
  
  FontWidth := Fontimg^.w Div 16;
  FontHeight := Fontimg^.h Div 16;
  
  TileRect.x:=0;
  Tilerect.y:=0;
  Tilerect.w:=FontWidth;
  Tilerect.h:=FontHeight;
  SDL_SetColorKey(FontImg,1,0);
  //FontImg := IMG_Load('Anikki_square_20x20.png');
  For y:=0 to 15 Do 
    For x:=0 to 15 Do
      Begin
        FontChar[y*16+x].x:=x*FontWidth;
        FontChar[y*16+x].y:=y*FontHeight;
        FontChar[y*16+x].w:=FontWidth;
        FontChar[y*16+x].h:=FontHeight;
      End;

  SoundOn     := True;
  ClickOn     := True;
  BellOn      := True;
  if SDL_Init(SDL_INIT_AUDIO ) < 0 Then Begin
    SoundOn     := False;
    ClickOn     := False;
    BellOn      := False;
    Log('Sound System not Initialized.');
  End Else
    if Mix_OpenAudio( MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, MIX_DEFAULT_CHANNELS, 4096 ) < 0 then Begin
      SoundOn     := False;
      ClickOn     := False;
      BellOn      := False;
      Log('Could not open Mixer.');
    End Else Begin
    sClick := Mix_LoadWAV( 'click.wav' );
    if sClick = nil then Begin
      ClickOn := False;
      Log('Click Sound not Loaded.');
    end Else Begin
      Mix_VolumeChunk( sClick, MIX_MAX_VOLUME );
      //ClickThread := SDL_CreateThread(@PlayClick,pchar('hello'),nil);
    End;
    sBell := Mix_LoadWAV( 'bell.wav' );
    if sBell = nil then Begin
      BellOn := False;
      Log('Bell Sound not Loaded.');
    End Else Mix_VolumeChunk( sBell, MIX_MAX_VOLUME );
    
    End;
  
  Mode := InitMode;
  Case InitMode of
    mode_80x25  : Begin
                    SetLength(Buffer,26);
                    //Log('length y: '+int2str(length(buffer)));
                    For i:=0 to 25 Do begin
                      SetLength(Buffer[i],81);
                    end;
                    //SDL_SetWindowSize(Window, 80*FontWidth,25*FontHeight);
                    WindowWidth:=80*FontWidth;
                    WindowHeight:=25*FontHeight;
                    BufferWidth:=80;
                    BufferHeight:=25;
                  End;
    mode_80x50  : Begin
                    SetLength(Buffer,51);
                    For i:=0 to 50 Do SetLength(Buffer[i],82);
                    //SDL_SetWindowSize(Window, 80*FontWidth,25*FontHeight);
                    WindowWidth:=80*FontWidth;
                    WindowHeight:=50*FontHeight;
                    BufferWidth:=80;
                    BufferHeight:=50;
                  End;
    mode_132x50 : Begin
                    SetLength(Buffer,51);
                    For i:=0 to 50 Do SetLength(Buffer[i],133);
                    //SDL_SetWindowSize(Window, 132*FontWidth,25*FontHeight);
                    WindowWidth:=132*FontWidth;
                    WindowHeight:=50*FontHeight;
                    BufferWidth:=132;
                    BufferHeight:=50;
                  End;
  End;

  window := SDL_CreateWindow(PChar(@Title[1]), SDLAppWindowX, SDLAppWindowY, WindowWidth, WindowHeight, SDL_WINDOW_SHOWN or SDL_WINDOW_RESIZABLE);
  //renderer := SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED or SDL_RENDERER_PRESENTVSYNC);
  //renderer := SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
  log('Creating Window...');
  if window = nil then halt;
  
  {if SDL_RenderSetLogicalSize(Renderer, 640, 480) <> 0 then Begin
    Log('Could not set proper resolution');
    Halt;
  End;}
    
  SDL_SetWindowTitle(Window, PChar(@Title[1]));
  Screen := SDL_GetWindowSurface(window);
  // set scaling quality
  SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, 'best');
  //SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, 'nearest');
  
  //cc:=SDL_CreateRGBSurface(0,windowwidth,windowheight,32,0,0,0,100); 
  //SDL_FillRect(cc, nil,SDL_MapRGBA(cc^.format, 255, 0, 0,0));
  ScreenRect.x:=0;
  ScreenRect.y:=0;
  ScreenRect.w:=WindowWidth;
  ScreenRect.h:=WindowHeight;
  
  ScreenBuf := SDL_CreateRGBSurface(0,WindowWidth,WindowHeight,32,0,0,0,0);
  Screen := SDL_GetWindowSurface(window);
  //Texture := SDL_CreateTextureFromSurface(Renderer, ScreenBuf);
  CopySurface:=SDL_CreateRGBSurface( 0,WindowWidth,WindowHeight, 32, 0, 0, 0, 100 );
  SDL_FillRect(CopySurface,nil,SDL_MapRGBA(CopySurface^.format, 0, 188, 212,50));
  
  New(Cursor);
  New(Tile);
  Cursor := SDL_CreateRGBSurface(0,FontWidth,FontHeight,16,0,0,0,0);
  Tile := SDL_CreateRGBSurface(0,FontWidth,FontHeight,16,0,0,0,0);
  SDL_SetColorKey(Tile,1,0);
  SDL_SetColorKey(Cursor,1,0);
  SDL_UpperBlit(FontImg,@FontChar[Ord('_')],Cursor,nil);
  //Cursor := TTF_RenderText_solid (Font, PChar(chr(177)), SDLDosColor[14]);
  //SDL_FillRect(Cursor,nil,SDL_MapRGBA(cursor^.format, 200, 200, 200,100));
  New (InputEvent);
  
  SDL_GetDesktopDisplayMode(0, @di);
  
  SDL_SetWindowPosition(Window,(di.w div 2)-(WindowWidth div 2),(di.h div 2)-(WindowHeight div 2));
  InputSize := 0;
  InputPos  := 0;
  TextAttr  := 7;
  Seth      :='|';
  isFullScreen := False;
  CursorOn := True;
  EnableCursor := True;
  CopyOn:=0;
  kpress:=false;
  
  BufferChanged:=True;
  ClrScr;
  PauseDraw:=False;
  
  
  //SDL_CreateThread( @thread_func, nil );
  
  Log('Buffer Width: '+int2str(bufferwidth));
  Log('Buffer Height: '+int2str(bufferheight));
  Log('Font Width: '+int2str(fontwidth));
  Log('Font Height: '+int2str(fontheight));
End;

Destructor TSDLConsole.Destroy;
Var
  i : Byte;
Begin
  Dispose (InputEvent);
    
  
  SDL_FreeSurface(Cursor);
  SDL_FreeSurface(Tile);
  SDL_FreeSurface(ScreenBuf);
  SDL_FreeSurface(Icon);
  //SDL_FreeSurface(cc);
  SDL_FreeSurface(CopySurface);
  
  //SDL_DestroyRenderer(Renderer);
  //SDL_DestroyTexture(Texture);
  SDL_DestroyWindow ( Window );
  If BellOn Then Mix_FreeChunk( sBell );
  If ClickOn Then Mix_FreeChunk( sClick );
  Mix_CloseAudio;
  
  SDL_FreeSurface(FontImg);

  SDL_QUIT;
  
  Case Mode of
    mode_80x25  : Begin
                    For i:=0 to 25 Do SetLength(Buffer[i],0);
                    SetLength(Buffer,0);
                  End;
    mode_80x50  : Begin
                    For i:=0 to 51 Do SetLength(Buffer[i],0);
                    SetLength(Buffer,0);
                  End;
    mode_132x50 : Begin
                    For i:=0 to 51 Do SetLength(Buffer[i],0);
                    SetLength(Buffer,0);
                  End;
  End;

  Inherited Destroy;
End;

Procedure TSDLConsole.PushInput (Ch: Char);
Begin
  Inc (InputSize);

  If InputSize > AppInputSize Then Begin
    InputSize := 1;
    InputPos  := 0;
  End;

  InputBuffer[InputSize] := Ch;
  If ClickOn then Mix_PlayChannel( -1, sClick, 0 );
End;

Procedure TSDLConsole.PushExt (Ch: Char);
Begin
  PushInput(#0);
  PushInput(Ch);
  If ClickOn then Mix_PlayChannel( -1, sClick, 0 );
End;

Procedure TSDLConsole.PushStr (Str: String);
Begin
  PushInput (Str[1]);
  If Length(Str) > 1 Then PushInput (Str[2]);
End;

Procedure TSDLConsole.ProcessEvent;
Var
  IsShift : Boolean = False;
  IsCaps  : Boolean = False;
  IsAlt   : Boolean = False;
  IsCtrl  : Boolean = False;
  Found   : Boolean;
  Count   : Integer;
Begin
  IsShift := (InputEvent^.Key.KeySym._mod AND KMOD_SHIFT <> 0);
  IsCaps  := (InputEvent^.Key.KeySym._mod AND KMOD_CAPS  <> 0);
  IsAlt   := (InputEvent^.Key.KeySym._mod AND KMOD_ALT   <> 0);
  IsCtrl  := (InputEvent^.Key.KeySym._mod AND KMOD_CTRL  <> 0);

  Case InputEvent^.Type_ of
  SDL_MOUSEMOTION : Begin
  
                        //If SDL_GetTicks() - timer < 10 Then exit;
                        mx:=InputEvent^.motion.x;
                        my:=InputEvent^.motion.y;
                          CopyRect.X:=mbxp;
                          COpyRect.Y:=mbyp;
                          Copyrect.w:=mx-mbxp;
                          Copyrect.h:=my-mbyp;
                          //Pixel2Cursor(CopyRect);
                          copyon:=InputEvent^.motion.state;
                      End;
    SDL_MOUSEBUTTONDOWN : Begin
                            Case InputEvent^.button.button of 
                              SDL_BUTTON_LEFT: mbButton:= mbLEFT;
                              SDL_BUTTON_MIDDLE: mbButton:= mbMIDDLE;
                              SDL_BUTTON_RIGHT: mbButton:= mbRIGHT;
                             End;
                             mbXp:=InputEvent^.motion.x;
                             mbYp:=InputEvent^.motion.y;
                             If Assigned(OnMouseKey) Then OnMouseKey(mbxp,mbyp,mbbutton,mbDown);
                          End;
    SDL_MOUSEBUTTONUP : Begin
                            If CopyOn=1 Then CopyClipboard1;
                            If CopyOn=2 Then CopyClipboard2;
                            //log('Button: '+int2str(mbbutton));
                            If Assigned(OnMouseKey) Then OnMouseKey(mbxp,mbyp,mbbutton,mbUp);
                            mbButton:=0;
                            CopyOn:=0;
                          End;
    {SDL_MOUSEWHEEL : Begin
                        If SDL_GetTicks() - Timer < 500 then exit;
                            if InputEvent^.wheel.y < 0 Then begin
                              PushExt(keyDOWN);
                              InputEvent^.wheel.y:=0;
                              end
                            else if InputEvent^.wheel.y > 0 then begin
                              PushExt(keyUP);
                              InputEvent^.wheel.y:=0;
                            end;
                        //sdl_delay(30);
                        Timer := SDL_GetTicks();
                        //log(int2str(timer));
                      End;
    }
    SDL_WINDOWEVENT : Begin
                        Case InputEvent^.Window.event of
                          SDL_WINDOWEVENT_RESIZED : Begin
                                                      ResizeWindow(InputEvent^.window.data1,InputEvent^.window.data2);
                                                      log('Resized...');
                                                      //Draw;
                                                    End;
                        End;
                      end;
    //SDL_KEYUP : kpress:=false;
    SDL_KEYDOWN : Begin
                    //if kpress then exit;
                    //If SDL_GetTicks() - timer < 30 Then exit;
                    If (InputEvent^.Key.KeySym.Sym = SDLK_RETURN) And (IsAlt) then begin
                      If isFullScreen Then Begin
                        SDL_SetWindowFullscreen(Window,0);
                        isFullScreen := False;
                      End Else Begin
                        SDL_SetWindowFullscreen(Window,SDL_WINDOW_FULLSCREEN_DESKTOP);
                        isFullScreen := True;
                      End;
                      BufferChanged:=True;
                      exit;
                    end else
                    If (InputEvent^.Key.KeySym.Sym = SDLK_C) And (IsAlt) And isCtrl then begin
                      Halt; //!!!!
                    End else Begin
                    
                    Case InputEvent^.Key.KeySym.Sym of
                      SDLK_A..
                      SDLK_Z        : Begin
                                        If IsShift or IsCaps Then Dec (InputEvent^.Key.KeySym.Sym, 32);
                                        PushInput (Chr(InputEvent^.Key.KeySym.Sym));
                                      End;
                      SDLK_SPACE    : PushStr(#32);
                      SDLK_DELETE   : PushExt(keyDELETE);
                      SDLK_UP       : PushExt(keyUP);
                      SDLK_DOWN     : PushExt(keyDOWN);
                      SDLK_RIGHT    : PushExt(keyRIGHT);
                      SDLK_LEFT     : PushExt(keyLEFT);
                      SDLK_INSERT   : PushExt(keyINSERT);
                      SDLK_HOME     : PushExt(keyHome);
                      SDLK_END      : PushExt(keyEnd);
                      SDLK_PAGEUP   : PushExt(keyPGUP);
                      SDLK_PAGEDOWN : PushExt(keyPGDN);
                      SDLK_KP_ENTER,
                      SDLK_RETURN       : PushStr(#13);
                      SDLK_ESCAPE       : PushStr(#27);
                      SDLK_KP_BACKSPACE,
                      SDLK_BACKSPACE    : Pushstr(KeyBackSpace);
                      SDLK_TAB          : PushExt(KeyTab);
                      SDLK_F1           : PushExt(KeyF1);
                      SDLK_F2           : PushExt(KeyF2);
                      SDLK_F3           : PushExt(KeyF3);
                      SDLK_F4           : PushExt(KeyF4);
                      SDLK_F5           : PushExt(KeyF5);
                      SDLK_F6           : PushExt(KeyF6);
                      SDLK_F7           : PushExt(KeyF7);
                      SDLK_F8           : PushExt(KeyF8);
                      SDLK_F9           : PushExt(KeyF9);
                      SDLK_F10          : PushExt(KeyF10);
                      SDLK_F11          : PushExt(KeyF11);
                      SDLK_F12          : PushExt(KeyF12);
                      
                      
                      //SDLK_NUMLOCKCLEAR..SDL_SCANCODE_APPLICATION  : //ignore mod keys;
                    Else
                      Found := False;

                      For Count := 1 to SDLKeyMapSize Do
                        If InputEvent^.Key.KeySym.Sym = SDLKeyMapUS[Count].SDL Then Begin
                          If IsShift Then
                            PushStr(SDLKeyMapUS[Count].Shift)
                          Else
                          If IsAlt Then
                            PushStr(SDLKeyMapUS[Count].Alt)
                          Else
                          If IsCTRL Then
                            PushStr(SDLKeyMapUS[Count].CTRL)
                          Else
                            PushStr(SDLKeyMapUS[Count].Key);

                          Found := True;

                          Break;
                        End;

                        //If Not Found Then PushInput(Chr(InputEvent^.Key.KeySym.Sym));
                    End;
                    
                    End;
                  End;
    SDL_QUITEV  : Halt;
  End;
End;

Function TSDLConsole.KeyPressed : Boolean;
Begin
  If SDL_PollEvent(InputEvent) > 0 Then
    ProcessEvent;

  Result := InputPos <> InputSize;
End;

{Function TSDLConsole.ReadKey : Char;
Begin
  If InputPos = InputSize Then Begin
    Repeat
      //SDL_WaitEventTimeout(InputEvent,10);
      SDL_WaitEvent(InputEvent);
        ProcessEvent;
    Until (InputSize <> InputPos);

  End;

  Inc (InputPos);

  Result := InputBuffer[InputPos];

  If InputPos = InputSize Then Begin
    InputPos  := 0;
    InputSize := 0;
  End;
End;}

Procedure TSDLConsole.ProcessEvents;
Begin
  If SDL_PollEvent(InputEvent)<>0 then ProcessEvent;

End;

Function TSDLConsole.ReadKey : Char;
Begin
  BufferChanged:=true;
  If InputPos = InputSize Then Begin
    kpress:=true;
    Repeat
      SDL_WaitEvent(InputEvent);
      ProcessEvent;
    Until (InputSize <> InputPos);
    kpress:=false;
  End;

  Inc (InputPos);

  Result := InputBuffer[InputPos];

  If InputPos = InputSize Then Begin
    InputPos  := 0;
    InputSize := 0;
  End;
End;

Procedure TSDLConsole.Delay (MS: LongInt);
Begin
  SDL_DELAY(MS);
End;

Procedure TSDLConsole.ShowBuffer;
Begin
  //SDL_RenderPresent( Renderer );
  SDL_UpdateWindowSurface(window);  
End;

Procedure TSDLConsole.SetTextAttr(Attr:Byte);
Begin
  TextAttr:=Attr;
End;

Procedure TSDLConsole.WriteChar(Ch:Char);
Begin
  Case Ch of
    #08 : If WhereX > 1 Then
            Dec(WhereX);
    #10 : Begin
            If WhereY < BufferHeight Then
              Inc (WhereY) Else Begin 
                ScrollBufferUp;      
                WhereY:=BufferHeight;
              End;
          End;
    #13 : WhereX := 1;
  Else
    try
      Buffer[WhereY][WhereX].Ch:=Ch;
      Buffer[WhereY][WhereX].Attr:=TextAttr;
    except
    end;
    
      WhereX := WhereX + 1;
      If WhereX > BufferWidth Then Begin
        WhereX:=1;
        WhereY:=WhereY+1;
        If WhereY>BufferHeight Then Begin
          ScrollBufferUp;
          WhereY:=BufferHeight;
        End;
      End;
  End;
  BufferChanged:=True;
End;

Procedure TSDLConsole.GotoX(x:Byte);
Begin
  GotoXY(x,WhereY);
End;

Procedure TSDLConsole.GotoY(Y:Byte);
Begin
  GotoXY(WhereX,y);
End;

Procedure TSDLConsole.GotoXY(x,y:Byte);
Begin
  If (Y < 1)  Then Y := 1 Else
  If (Y > BufferHeight) Then Y := BufferHeight;
  If (X < 1)  Then X := 1 Else
  If (X > BufferWidth) Then X := BufferWidth;
  WhereX := X;
  WhereY := Y;
End;

Procedure TSDLConsole.WriteXY(X,Y,A:Byte; Str:String);
Var
  oldat : Byte;
Begin
  GotoXY(x,y);
  oldat:=TextAttr;
  TextAttr:=A;
  WriteStr(Str);  
  TextAttr:=oldat;
End;

Procedure TSDLConsole.ScrollBufferUp;
Var
  i:byte;
Begin
  For i:=2 to BufferHeight Do Move(Buffer[i][0],Buffer[i-1][0],(BufferWidth+1) * Sizeof(TScreenChar));
  //FillByte(Buffer[BufferHeight][0],0,(BufferWidth+1) * Sizeof(TScreenChar));
  for i:=1 to bufferwidth do begin
    buffer[bufferheight][i].ch:=#0;
    buffer[bufferheight][i].Attr:=7;
  end;
End;

Procedure TSDLConsole.WriteStr(Str:String);
var i:byte;
begin
  for i:=1 to length(str) do writechar(str[i]);
end;

Function TSDLConsole.GetSDLFGColor:Byte;
Begin
  Result := TextAttr Mod 16;
End;

Function TSDLConsole.GetSDLBGColor:Byte;
Begin
  Result := TextAttr Div 16;
End;

Procedure TSDLConsole.ClrScr;
Var
  x,y:byte;
Begin
  //SDL_SetRenderDrawColor(renderer, SDLDosColor[GetSDLBGColor].r, SDLDosColor[GetSDLBGColor].r, SDLDosColor[GetSDLBGColor].r, 255);
  //SDL_RenderClear(Renderer);
  SDL_FillRect(screen, @ScreenRect, 0);
  SDL_FillRect(screenbuf, @ScreenRect, 0);
  //SDL_UpdateWindowSurface(window); 
  
  for y:=1 to BufferHeight Do
    For x:=1 to BufferWidth Do Begin
      Buffer[y][x].Ch:=#0;
      Buffer[y][x].Attr:=TextAttr;
    End;
    
  WhereX:=1;
  WhereY:=1;
  //Draw;
End;

procedure TSDLConsole.fillbuffer;
var x,y:byte;
begin
  for y:=1 to bufferheight do 
    for x:=1 to bufferwidth do begin
      buffer[y][x].ch:='0';
      buffer[y][x].attr:=14+3*16;
    end;
end;

Procedure TSDLConsole.UpdateScreenBuffer;
Var
  Rect    : TSDL_Rect  = (X:0; Y:0; W:0; H:0);
  //Surface1 : PSDL_Surface;
  //Text    : String;
  x,y:byte;
Begin
  for y:=1 to bufferheight do begin
    for x:=1 to bufferwidth do begin
     
      Rect.W:=FontWidth;
      Rect.H:=FontHeight;
      Rect.X:=(X-1)*FontWidth;
      Rect.Y:=(Y-1)*FontHeight;
      
      SDL_FillRect(tile,@tilerect,0);
      SDL_BlitSurfaceScaled(FontImg,@FontChar[Ord(buffer[y][x].ch)],Tile,@tilerect);
      //SDL_BlitSurface(FontImg,@FontChar[Ord(buffer[y][x].ch)],Tile,@tilerect);
      SDL_SetSurfaceColorMod(Tile,SDLDosColor[buffer[y][x].Attr mod 16].r, SDLDosColor[buffer[y][x].Attr mod 16].g, SDLDosColor[buffer[y][x].Attr mod 16].b);
      SDL_FillRect(screenbuf,@rect,SDL_MapRGB(screenbuf^.format, SDLDosColor[buffer[y][x].Attr div 16].r, SDLDosColor[buffer[y][x].Attr div 16].g, SDLDosColor[buffer[y][x].Attr div 16].b));
      SDL_UpperBlit(Tile,@tilerect,screenbuf,@rect);
    end;
  end;  
End;

{Procedure TSDLConsole.MoveBuffer2Screen;
Begin
  UpdateScreenBuffer;
  SDL_BlitSurface(screenbuf,@screenrect,screen,@screenrect);
  //SDL_UpdateWindowSurface(window);
End;}

Procedure TSDLConsole.Write(Str:String);
begin
  WriteStr(str);
End;

Procedure TSDLConsole.WriteLn(Str:String);
Begin
  WriteStr(Str+crlf);
End;

Procedure TSDLConsole.Log(Str:string);
Begin
  system.writeln(str);
End;

Function  TSDLConsole.GetAttrAt(AX, AY: Byte): Byte;
Begin
  If (Ax<=BufferWidth) and (ay<=BufferHeight) Then
    Result:=Buffer[Ay][Ax].Attr
  Else Result:=7;
End;

Function  TSDLConsole.GetCharAt(AX, AY: Byte): Char;
Begin
  If (Ax<=BufferWidth) and (ay<=BufferHeight) Then
    Result:=Buffer[Ay][Ax].Ch
  Else Result:=' ';
End;

Procedure TSDLConsole.SetAttrAt(AAttr, AX, AY: Byte);
Begin
  If (Ax<=BufferWidth) and (ay<=BufferHeight) Then Buffer[Ay][Ax].Attr:=AAttr;
End;

Procedure TSDLConsole.SetCharAt(ACh: Char; AX, AY: Byte);
Begin
  If (Ax<=BufferWidth) and (ay<=BufferHeight) Then Buffer[Ay][Ax].Ch:=ACh;
End;

procedure TSDLConsole.ClearEOL;
Var
  i:byte;
Begin
  For i:=WhereX to BufferWidth Do Begin
    Buffer[WhereY][i].Ch:=' ';
    Buffer[WhereY][i].Attr:=TextAttr;
  End;
End;

Procedure TSDLConsole.WritePipeB (Str: String);

  Procedure AddChar (Ch: Char);
  Begin
    If WhereX > BufferWidth Then Exit;

    Buffer[WhereY][WhereX].Attr  := TextAttr;
    Buffer[WhereY][WhereX].Ch := Ch;

    Inc (WhereX);
  End;

Var
  Count   : Byte;
  Code    : String[2];
  CodeNum : Byte;
  OldAttr : Byte;
  OldX    : Byte;
  OldY    : Byte;
  text    : string;
Begin

  text:=str;
  Count := 1;

  While Count <= Length(text) Do Begin
    If text[Count] = Seth Then Begin
      Code    := Copy(text, Count + 1, 2);
      CodeNum := Str2Int(Code);

      If (Code = '00') or ((CodeNum > 0) and (CodeNum < 24) and (Code[1] <> '&') and (Code[1] <> '$')) Then Begin
        Inc (Count, 2);
        If CodeNum in [00..15] Then
          SetTextAttr (CodeNum + ((TextAttr SHR 4) AND 7) * 16)
        Else
          SetTextAttr ((TextAttr AND $F) + (CodeNum - 16) * 16);
      End Else Begin
        AddChar(text[Count]);
      End;
    End Else Begin
      AddChar(text[Count]);
    End;
    Inc (Count);
  End;
  BufferChanged:=True;
End;

Procedure TSDLConsole.WritePipe (Str: String);
Begin
  WritePipeB(Str);
End;

Procedure TSDLConsole.WriteXYPipe (X, Y, Attr: Integer; Text: String);
Begin
  GotoXY(X,Y);
  TextAttr:=Attr;
  WritePipe(Text);
End;

Procedure TSDLConsole.RestoreScreen(sbuf: TScreen);
Var
  x,y:Byte;
Begin
  SetLength(sbuf,BufferHeight+1);
  For y:=1 to BufferHeight Do SetLength(sbuf[y],BufferWidth+1);
  
  For y:=1 to BufferHeight Do
    For x:=1 to BufferWidth Do Begin
      Buffer[y][x].Ch:=sbuf[y][x].Ch;
      Buffer[y][x].Attr:=sbuf[y][x].Attr;
    End;
  //Draw;
End;

Procedure TSDLConsole.SaveScreen(var sbuf: TScreen);
Var
  x,y:Byte;
Begin
  SetLength(sbuf,BufferHeight+1);
  For y:=1 to BufferHeight Do SetLength(sbuf[y],BufferWidth+1);
  
  For y:=1 to BufferHeight Do
    For x:=1 to BufferWidth Do Begin
      sbuf[y][x].Ch:=Buffer[y][x].Ch;
      sbuf[y][x].Attr:=Buffer[y][x].Attr;
    End;
End;

Procedure TSDLConsole.ResizeWindow(w,h:integer);
var
  nw,nh:integer;
Begin
  PauseDraw:=true;
  FontWidth := w div bufferwidth;
  nw:= bufferwidth * FontWidth;
  
  FontHeight := h div bufferheight;
  nh:= bufferheight * FontHeight;
  
  WindowWidth := nw;
  WindowHeight:=nh;
  
  SDL_FreeSurface(Tile);
  Tile := SDL_CreateRGBSurface(0,FontWidth,FontHeight,16,0,0,0,0);
  SDL_SetColorKey(Tile,1,0);
  
  Tilerect.w:=FontWidth;
  Tilerect.h:=FontHeight;
  
  SDL_FreeSurface(Cursor);    
  Cursor := SDL_CreateRGBSurface(0,FontWidth,FontHeight,16,0,0,0,0);
  SDL_SetColorKey(Cursor,1,0);
  
  SDL_BlitSurfaceScaled(FontImg,@FontChar[Ord('_')],Cursor,@tilerect);
  //SDL_UpperBlit(FontImg,@FontChar[Ord('_')],Cursor,nil);
  
  try
    SDL_SetWindowSize(Window,nw,nh);
  except
    log('Exception On Setting Window Size');
  end;
  
  ScreenRect.x:=0;
  ScreenRect.y:=0;
  ScreenRect.w:=WindowWidth;
  ScreenRect.h:=WindowHeight;
  
  SDL_FreeSurface(ScreenBuf);
  ScreenBuf := SDL_CreateRGBSurface(0,WindowWidth,WindowHeight,16,0,0,0,0);
  SDL_FreeSurface(Screen);
  sdl_delay(5);
  try
    Screen := SDL_GetWindowSurface(window);
  except
    log('Exception On Getting Window Surface');
  end;
  sdl_delay(5);
  SDL_FreeSurface(CopySurface);
  CopySurface:=SDL_CreateRGBSurface( 0,WindowWidth,WindowHeight, 32, 0, 0, 0, 50 );
  SDL_FillRect(CopySurface,nil,SDL_MapRGBA(CopySurface^.format, 255, 0, 0,50));
  BufferChanged:=True;
  PauseDraw:=false;
  log('WindowHeight : '+int2str(WindowHeight));
  log('WindowWidth : '+int2str(WindowWidth));
  log('New FontWidth : '+int2str(FontWidth));
  log('New FontHeight : '+int2str(FontHeight));
End;
 

Procedure TSDLConsole.ShowCursor;
var
  Rect    : TSDL_Rect  = (X:0; Y:0; W:0; H:0);
Begin
    rect.x:=(WhereX-1) * FontWidth;
    rect.y:=(WHereY-1) * FOntHeight;
    rect.w:=fontwidth;
    rect.h:=fontheight;
    
    SDL_BlitSurface(cursor,nil,screenbuf,@rect);
End;

Procedure TSDLConsole.ShowMouseCursor;
var
  x:integer =0;
  y:integer =0;
  a:byte=1;
  b:byte=1;
  Rect    : TSDL_Rect  = (X:0; Y:0; W:0; H:0);
Begin
  if mbbutton=0 then exit;
  
  a:=1;
  while x<mx-fontwidth do begin
    x:=(a*fontwidth);
    a:=a+1;
  end;
  a:=a-1;x:=a*fontwidth;
  while y<(my-fontheight) do begin
    y:=(b*fontheight);
    b:=b+1;
  end;
  b:=b-1;y:=b*fontheight;
  
  
    rect.x:=x;
    rect.y:=y;
    rect.w:=fontwidth;
    rect.h:=fontheight;
    //boxRGBA(screen,x,y,x+fontwidth,y+fontheight,SDLDosColor[15].r,SDLDosColor[15].g,SDLDosColor[15].b,255);
    
    //SDL_FillRect(screen, nil,SDL_MapRGB(screen^.format, 255, 0, 0));
    //SDL_FLIP(screen);SDL_BlitSurface(screenbuf,nil,screen,nil);
    
    SDL_FillRect(screen, nil, 0);  
    SDL_BlitSurface(screenbuf,nil,screen,nil);
    //SDL_UpdateWindowSurface(window); 
    SDL_BlitSurface(cursor,nil,screenbuf,@rect);
    //SDL_UpdateWindowSurface(window);    
  
  mbxc:=a+1;
  mbyc:=b+1;
End;

Function TSDLConsole.SetWindowIcon(icn:String):Boolean;
Begin
  Result:=True;
  Icon := IMG_Load(PChar(@icn[1]));
  SDL_SetWindowIcon(Window,Icon);
End;

procedure TSDLConsole.transrect(r:TSDL_Rect);
begin
  //cc:=SDL_CreateRGBSurface(0,windowwidth,windowheight,32,0,0,0,100);  
//  SDL_SetSurfaceBlendMode(CopySurface,SDL_BLENDMODE_add);
//  SDL_FillRect(copysurface, @r,SDL_MapRGBA(copysurface^.format, 255, 0, 0,0));
 // SDL_BlitSurface(copysurface,@r,screen,@r);
  //SDL_FreeSurface(copysurface);
  {SDL_SetRenderDrawBlendMode(renderer,SDL_BLENDMODE_Blend);
  SDL_SetRenderDrawColor(renderer, 255, 100, 0, 150);
  SDL_RenderFillRect(renderer,@r);}
  
  //SDL_lowerBlit(screenbuf,@screenrect,screen,@screenrect);
  SDL_SetSurfaceBlendMode(CopySurface,SDL_BLENDMODE_add);
  SDL_lowerBlit(CopySurface,@r,screen,@r);
  //SDL_UpdateWindowSurface(window); 
  //sdl_delay(20);
end;

Procedure TSDLConsole.DrawLineSelection;
var
  x,y:byte;
  q,r :TSDL_Rect;
  
Begin
  //SDL_SetRenderDrawBlendMode(renderer,SDL_BLENDMODE_blend);
  //SDL_SetRenderDrawColor(renderer, 255, 10, 10, 200);
  {CopyRect.X:=mbxp;
  COpyRect.Y:=mbyp;
  Copyrect.w:=mx-mbxp;
  Copyrect.h:=my-mbyp;}
  //timer:=SDL_GetTicks() - timer;
  //if timer < BlockDrawTiming then exit;
  CopyRect.X:=mbxp;
  COpyRect.Y:=mbyp;
  Copyrect.w:=mx-mbxp;
  Copyrect.h:=my-mbyp;
  r:=Pixel2Cursor(CopyRect);
  
  if r.h=0 then begin
    q.x:=(r.x-1)*fontwidth;
    q.y:=(r.y-1)*fontheight;
    q.w:=(r.w+1)*fontwidth;
    q.h:=fontheight;
    transrect(q);
    SDL_UpdateWindowSurface(window); 
    exit;
  end;
  if r.h=1 then begin
    q.x:=(r.x-1)*fontwidth;
    q.y:=(r.y-1)*fontheight;
    q.w:=(BufferWidth-r.x+1)*fontwidth;
    q.h:=fontheight;
    transrect(q);
    
    q.x:=0;
    q.y:=(r.y)*fontheight;
    q.w:=(r.x+r.w)*fontwidth;
    q.h:=fontheight;
    transrect(q);
    sdl_delay(20);
    SDL_UpdateWindowSurface(window); 
    exit;
  end;
  q.x:=(r.x-1)*fontwidth;
    q.y:=(r.y-1)*fontheight;
    q.w:=(BufferWidth-r.x+1)*fontwidth;
    q.h:=fontheight;
    transrect(q);
    
    q.x:=0;
    q.y:=(r.y)*fontheight;
    q.w:=windowwidth;
    q.h:=(r.h-1)*fontheight;
    transrect(q);
    
    q.x:=0;
    q.y:=(r.y+r.h-1)*fontheight;
    q.w:=(r.x+r.w)*fontwidth;
    q.h:=fontheight;
    transrect(q);
    SDL_UpdateWindowSurface(window); 
   sdl_delay(20);

End;

Procedure TSDLConsole.DrawBlockSelection;
Begin
  //timer:=SDL_GetTicks() - timer;
  //if timer < BlockDrawTiming then exit;
  
  CopyRect.X:=mbxp;
  COpyRect.Y:=mbyp;
  Copyrect.w:=mx-mbxp;
  Copyrect.h:=my-mbyp;
  Pixel2Cursor(CopyRect);
  //SDL_lowerBlit(screenbuf,@screenrect,screen,@screenrect);
  SDL_SetSurfaceBlendMode(CopySurface,SDL_BLENDMODE_add);
  SDL_lowerBlit(CopySurface,@copyrect,screen,@copyrect);
  SDL_UpdateWindowSurface(window); 
  sdl_delay(10);
  {
  SDL_SetRenderDrawBlendMode(renderer,SDL_BLENDMODE_BLEND);
  SDL_SetRenderDrawColor(renderer, 255, 0, 0, 250);
  SDL_RenderFillRect(renderer,@copyrect);}
  //log('block: '+int2str(copyrect.x)+' y: '+int2str(copyrect.y)+' w: '+int2str(copyrect.w)+' h:'+int2str(copyrect.h));
End;

Procedure TSDLConsole.Draw;
Begin
    If PauseDraw Then Begin
      sdl_delay(30);
      Exit;
    end;
    
    If BufferChanged Then Begin
      UpdateScreenBuffer;
      BufferChanged:=False;
    End;
    
    //Texture := SDL_CreateTextureFromSurface(Renderer, ScreenBuf);
    //SDL_RenderCopy(Renderer, Texture, nil, nil);
    
    SDL_BlitSurface(screenbuf,@screenrect,screen,@screenrect);
    
    If EnableCursor Then CursorOn := Not CursorOn;
    If CursorOn Then ShowCursor;
    
    if copyon=2 then DrawBlockSelection else
      if copyon=1 then DrawLineSelection;
    
  
    SDL_UpdateWindowSurface(window); 
    //SDL_RenderPresent(Renderer);
    //SDL_DestroyTexture(Texture);
    sdl_delay(10);

End;

Function TSDLConsole.Pixel2Cursor(Var R:TSDL_Rect):TSDL_Rect;
Var
  d:integer;
  x,y,w,h:byte;
Begin

  result.x := (r.x div fontwidth)+1;
  r.x :=(r.x div fontwidth ) * fontwidth;
  
  result.w:=(r.w div fontwidth);
  r.w:=((r.w div fontwidth)+1) * fontwidth;
  
  result.y := (r.y div fontheight)+1;
  r.y :=(r.y div fontheight ) * fontheight;
  
  result.h:=(r.h div fontheight);
  r.h:=((r.h div fontheight)+1) * fontheight;
End;

Procedure TSDLConsole.TakeScreenShot(filename:string);
Var
  surf: pSDL_SURFACE;
Begin
  Surf:=SDL_CreateRGBSurface( 0,WindowWidth,Windowheight, 32, 0, 0, 0, 0 );
  SDL_UpperBlit(ScreenBuf,@screenrect,surf,@screenrect);    
  IMG_SavePNG(surf,PChar(@filename[1]));
  SDL_FreeSurface(surf);
End;

Procedure TSDLConsole.SetClipboardText(s:string);
Begin
  SDL_SetClipBoardText(PChar(@s[1]));
End;

Function TSDLConsole.GetClipBoardText:String;

Begin
  Result:= SDL_GetClipboardText^;
End;
{$H+}
Procedure TSDLConsole.CopyClipboard1;
Var
  r:TSDL_Rect;
  x,y:byte;
  s:string='';
Begin
  try
    r:=Pixel2Cursor(CopyRect);
  //  log('x '+int2str(r.x)+'y '+int2str(r.y)+'w '+int2str(r.w)+'h '+int2str(r.h));
    if r.h=1 then begin
      for x:=r.x to r.x+r.w-1 do 
        if ord(buffer[r.y][x].ch)>13 then s:=s+buffer[r.y][x].ch;
      SDL_SetClipboardText(PChar(@S[1]));
      exit;
    end;
    if r.h=2 then begin
      for x:=r.x to BufferWidth do 
        if ord(buffer[r.y][x].ch)>13 then s:=s+buffer[r.y][x].ch;
      s:=s+#13;
      for x:=1 to r.x+r.w-1 do 
        if ord(buffer[r.y+1][x].ch)>13 then s:=s+buffer[r.y+1][x].ch;
      SDL_SetClipboardText(PChar(@S[1]));
      exit;
    end;
    
    for x:=r.x to BufferWidth do 
        if ord(buffer[r.y][x].ch)>13 then s:=s+buffer[r.y][x].ch;
    s:=s+#13;
    
    for y:=0 to r.h -3 do begin
      for x:=1 to bufferwidth do
        if ord(buffer[r.y+1+y][x].ch)>13 then s:=s+buffer[r.y+y+1][x].ch;
      s:=s+#13;
    end;

    for x:=1 to r.x+r.w-1 do 
      if ord(buffer[r.y+r.h-1][x].ch)>13 then s:=s+buffer[r.y+r.h-1][x].ch;
    SDL_SetClipboardText(PChar(@S[1]));
    
    Log('Text Copied to Clipboard');
  Except
    Log('Exception while coping text to clipboard');
  End;
End;
{$H-}

Procedure TSDLConsole.CopyClipboard2;
Var
  r:TSDL_Rect;
  x,y:byte;
  s:string='';
Begin
  r:=Pixel2Cursor(CopyRect);
  for y:=r.y to r.y+r.h-1 do begin
    for x:=r.x to r.x+r.w-1 do
      if ord(buffer[y][x].ch)>13 then s:=s+buffer[y][x].ch;
    s:=s+crlf;
  end;
  SDL_SetClipboardText(PChar(@S[1]));
  Log('Text Copied to Clipboard');
End;

Procedure TSDLConsole.DisableCursor;
Begin
  EnableCursor:=False;
  CursorOn:=False;
End;


End.
