import std/os
import std/strutils
import std/tables
import std/macros
import std/times
import std/hashes

import cps
import gram

type
  Vertex = object
    fn: Continuation.fn
    name: string
    info: LineInfo

  Link[T] = object
    name: string
    entry: float
    cont: T

var traced: Table[Continuation.fn, (string, LineInfo)]
template trace*(c: typed; fun: string; info: LineInfo) =
  if c.fn notin traced:
    traced[c.fn] = (fun, info)

proc `$`*(v: Vertex): string =
  ## render the continuation leg
  try:
    if v.fn in traced:
      var (name, info) = traced[v.fn]
      name = name.split("_")[0]
      let fn = info.filename.lastPathPart
      result = "$#    ($# : $#)" % [ name, fn, $info.line ]
    else:
      result = $(cast[int](v.fn))
  except:
    result = "?"

proc `$`*[T](l: Link[T]): string =
  ## render the link between two continuation legs
  try:
    result = "  $# cpu" % [ $l.entry ]
  except:
    result = "?"

const F = defaultGraphFlags.toInt
proc passenger*[T: Continuation](c: T): (T, Graph[Vertex, Link[T], F]) =
  var g: Graph[Vertex, Link[T], F] = newGraph[Vertex, Link[T]]()
  var prior: Node[Vertex, Link[T]]
  trampolineIt c:
    let vertex = g.add Vertex(fn: it.fn)
    let link = Link[T](cont: c, entry: cpuTime())
    g.incl vertex
    if not prior.isNil:
      discard g.edge(prior, link, vertex)
    prior = vertex
  result = (c.T, g)
