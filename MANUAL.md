Stuff Done Manually
===================

Download Irfanview + Plugins


Manual Syncs
============

Programs that store passwords in plain text.


FileZilla
---------

Base64 encoded passwords.


HeidiSQL
--------

Storing a manual backup here for now.  
Bestand > Instellingsbestand importeren/exporteren > HeidiSQL.txt


Settings stored in:  
```
regedit => HKEY_CURRENT_USER => Software => Heidisql
```

Decoding a password:  
```c#
function heidiDecode(hex) {
    var str = '';
    var shift = parseInt(hex.substr(-1));
    hex = hex.substr(0, hex.length - 1);
    for (var i = 0; i < hex.length; i += 2)
      str += String.fromCharCode(parseInt(hex.substr(i, 2), 16) - shift);
    return str;
}

console.log(heidiDecode('pwd from file'));
```
