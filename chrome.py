#!/usr/bin/env python
from subprocess import call
from sys import argv

call(["open", "-a", "/Applications/Google Chrome.app"] + argv[1:])