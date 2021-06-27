version = "0.0.3"
author = "disruptek"
description = "a cps dispatcher"
license = "MIT"

when not defined(release):
  requires "https://github.com/disruptek/balls >= 3.0.0 & < 4.0.0"
requires "https://github.com/disruptek/gram >= 0.4.0 & < 1.0.0"
requires "https://github.com/disruptek/cps >= 0.0.29 & < 1.0.0"
requires "https://github.com/haxscramper/hasts < 1.0.0"
requires "https://github.com/haxscramper/hmisc <= 0.11.10"

task test, "run tests for ci":
  when defined(windows):
    exec "balls.cmd"
  else:
    exec "balls"

task demo, "produce a demo":
  exec """demo docs/demo.svg "nim c --define:release --out=\$1 tests/test.nim""""

