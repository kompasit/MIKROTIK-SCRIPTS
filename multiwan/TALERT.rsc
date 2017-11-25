:global TTEXT;
:global MYHOST;

:local TTIME  [/system clock get time];
:local TDATE [/system clock get date];

:local TEXT "$MYHOST: $TTEXT at $TDATE $TTIME";


:local CHATID "-XXX"; 
:local TOKEN "YYY";
:local URL "https://api.telegram.org/bot$TOKEN/sendmessage\?chat_id=$CHATID&text=$TEXT";

/tool fetch url=l=$URL keep-result=no