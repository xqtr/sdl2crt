program sdl2crt_example;
{$mode objfpc}
uses 
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  classes,
  sdl2crtpng;

//we use a thread to do the drawing for this example. If you don't want to use
//threads, which will make the executable smaller also, you can... by calling
//the Draw function, whenever you are ready to show the screen to the user.

//Be aware that if you don't use the thread option, you will not see the 
//mouse selection boxes
type
  TSDLDraw = class(TThread)
    public
      Fscreen:TSDLConsole;
      constructor Create(StartSuspended : boolean; scr:TSDLConsole);
      destructor Destroy; override;
      procedure Execute;override;
  end;

var
  s         : TSDLConsole;
  c         : char;
  exiting   : boolean = false;
  sdlthread : tsdldraw;
  str       : string = '';

constructor TSDLDraw.Create(StartSuspended : boolean; Scr:TSDLConsole);
begin
  inherited Create(StartSuspended);
  Fscreen := Scr;
  FreeOnTerminate := False;
end;

destructor TSDLDraw.Destroy;
begin
  inherited Destroy;
end;

Procedure TSDLDraw.Execute;
Begin
  repeat;
  if not fscreen.kpress then fscreen.processevents;
  FScreen.Draw;  // the thread will draw the screen until this variable
  until exiting; // is true. so to exit you have to put true to this var.
End;
  
begin
  //create our main screen object in mode 80x25
  s:=TSDLConsole.create(mode_80x25,'Example...','');
  
  //create the drawing thread
  sdlthread:=TSDLDraw.Create(True,s);
  sdlthread.start;
  //with this you can set an icon to the app.
  s.setwindowicon('a.icn');
  
  //main program. all crt functions are implemented.
  s.clrscr;
  s.writexy(10,10,14,'Hello World!!!');
  s.writexy(1,25,8,'Press ESC to Exit');
  s.writexypipe(1,23,7,'|15Use |03Right Mouse Button |07to select text |09 or Middle |11mouse button');

  s.gotoxy(1,12);
  s.textattr:=13;
  repeat 
    c:=s.readkey;
    str:=str+c;
    s.gotoxy(1,12);
    s.writestr(str);
  until c=#27;
  exiting:=true;
  
  //destroy all objects
  sdlthread.destroy;
  s.destroy;
end.
