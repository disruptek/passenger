import std/tables

import balls
import gram
import cps
import passenger

suite "passenger":

  block:
    ## zevv's goto
    type
      C = ref object of Continuation
        labels: Table[string, Continuation.fn]

    proc label(c: C, id: string): C {.cpsMagic.} =
      c.labels[id] = c.fn
      return c

    proc goto(c: C, id: string): C {.cpsMagic.} =
      c.fn = c.labels[id]
      result = c

    proc foo() {.cps: C.} =
      var x = 0
      echo "one"
      label"here"
      inc x
      if x <= 10:
        echo "two"
        echo "three"
        goto"here"
        echo "four"

    var c = whelp foo()
    block:
      let (c, g) = passenger c
      g.dotRepr.toPng "docs/goto.png"
