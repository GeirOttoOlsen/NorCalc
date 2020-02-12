CREATE SERVER hServer.
hServer:CONNECT("-H 80.203.178.219 -S 4510 -AppService asAppFarm -DirectConnect") NO-ERROR.
IF hServer:CLIENT-CONNECTION-ID = "" THEN
  hServer:CONNECT("-H 10.0.0.10 -S 4510 -AppService asAppFarm -DirectConnect") NO-ERROR.  

IF hServer:CLIENT-CONNECTION-ID = "" THEN
do:
  message 'Could not connect to given IP adress: 80.203.178.218 or 10.0.0.10 port 4510' view-as alert-box.
  RETURN FALSE.
end.
ELSE
  RETURN TRUE.
