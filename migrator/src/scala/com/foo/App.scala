package com.foo

import fansi._

object App {
  def greeting(name: String) = Str(s"Hello, ") ++ Color.Green(name)

  def main(args: Array[String]): Unit = {
    println(greeting("World"))
  }
}
