function ps1-simple { PS1='> '; }
function ps1-color { PS1="$colorOn> $colorOff"; }
function ps1-dollar-color { PS1="$colorOn\$ $colorOff"; }
function ps1-directory { PS1='$colorOn%1d > $colorOff'; }

function prompt-simple { ps1-simple }
function prompt-color { ps1-color }
function prompt-dollar-color { ps1-dollar-color }
function prompt-directory { ps1-directory }

function prompt { ps1-directory }