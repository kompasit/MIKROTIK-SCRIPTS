# backup2ftp
# /system script run backup2ftp
:local debug true
:local path "/"
:local ftphost "192.168.167.21"
:local ftpport "21"
:local ftpuser "mikrot"
:local ftppassword "ahgie4aeCha+"
:local ftppath ""

:local ds [/system clock get date]
:local dd [:pick $ds 8 10]

if ($debug or $dd = "01" or $dd = "15") do={
  :set ds ([:pick $ds 2 4] . [:pick $ds 5 7] . $dd)
  :local ts [/system clock get time]
  :set ts ([:pick $ts 0 2].[:pick $ts 3 5])
  :local fname ([/system identity get name]."_".$ds."-".$ts."_auto")
  :local fname1 "$fname.backup"
  :local fname2 "$fname.rsc"
  :log info $fname1
  :log info $fname2

  :foreach i in=[/file find] do={ :if ([:typeof [:find [/file get $i name] "_auto."]]!="nil") do={/file remove $i}; }

  /system backup save name=($path.$fname1)
  :log info message="System backup finished (1/2).";
  #/export compact file=($path.$fname2)
  /export terse file=($path.$fname2)
  :log info message="Config export finished (2/2)."

  :log info message="Uploading system backup (1/2)."
  /tool fetch address="$ftphost" port="$ftpport" src-path=($path.$fname1) user="$ftpuser" mode=ftp password="$ftppassword" dst-path="$ftppath/$fname1" upload=yes
  :log info message="Uploading config export (2/2)."
  /tool fetch address="$ftphost" port="$ftpport" src-path=($path.$fname2) user="$ftpuser" mode=ftp password="$ftppassword" dst-path="$ftppath/$fname2" upload=yes
  #:delay 30s;
  :log info message="Configuration backup finished.";
}
