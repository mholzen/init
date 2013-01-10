#!/usr/bin/env python

import os

filename=os.path.expanduser("~/.bash_profile")

me='bash-profilename-install'

content=open(filename).read()

start="\n# The following line is automtically inserted by " + me + "\n"
command="for f in ~/.bash_profile.d/*.sh; do source $f; done\n"
end="# End of automatic insert\n"

if start in content:
	result = content[0:content.find(start)]
	result += start + command + end
	result += content[ content.find(end, content.find(start)) + len(end): ]
else:
	result = content + start + command + end

file=open(filename,"w")
file.write(result)
file.close


