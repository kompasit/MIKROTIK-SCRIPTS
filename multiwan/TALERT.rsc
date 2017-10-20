# 3   name="TALERT" owner="admin" policy=read,write,policy,test 
#     last-started=oct/20/2017 16:36:47 run-count=36 source=
       :global TTEXT;
       :global MYHOST;
       
       :local TEXT "* Router: $MYHOST *%0A$TTEXT";
       
       
       :local CHATID "-200602547"; 
       :local TOKEN "446522207:AAHpZthIT2j11cXbyLHjYETSKd6d4xexMOY";
       :local URL "https://api.telegram.org/bot$TOKEN/sendmessage\?chat_id=$CHATID&text=$TEXT";
       
       #:put $URL;
       
       /tool fetch url=$URL mode=http keep-result=no;
