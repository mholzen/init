function ps1-simple { PS1='> '; }
function ps1-color { PS1="$colorOn> $colorOff"; }
function ps1-dolar-color { PS1="$colorOn\$ $colorOff"; }
function ps1-directory { PS1='$colorOn%1d > $colorOff'; }
function prompt { ps1-directory }
