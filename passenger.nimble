version = "0.0.3"
author = "disruptek"
description = "a cps dispatcher"
license = "MIT"

when not defined(release):
  requires "https://github.com/disruptek/balls >= 3.0.0 & < 4.0.0"
requires "https://github.com/disruptek/gram >= 0.4.0 & < 1.0.0"
requires "https://github.com/nim-works/cps >= 0.0.29 & < 1.0.0"
requires "https://github.com/haxscramper/hmisc >= 0.9.15 & <= 0.11.4"
requires "https://github.com/haxscramper/hasts >= 0.1.3 & <= 0.1.6"

task test, "run tests for ci":
  when defined(windows):
    exec "balls.cmd"
  else:
    exec "balls"

task demo, "produce a demo":
  exec """nim c --gc:arc --define:danger --run tests/test.nim"""
