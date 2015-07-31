#!/bin/bash
npm list -g 2>&1 | grep -E '^├' | cut -d' ' -f2
