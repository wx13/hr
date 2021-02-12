# hr -- Fancy horizontal rule for the shell.

The hr command is a bash function which prints a configurable horizontal rule.
It is useful for marking the start of a command with lots of output. It makes it
easy to find the start of the output in the scrollback buffer.

## Usage

If are running a long command, simply do this:

```
hr; ./some_long_running_command
```

This will choose a color based on the day of the week. You can also specify the
color using color codes. Available colors are red (r), white (w), blue (b), cyan
(c), yellow (y), green(g), magenta (m), and black (k). Here are some examples.

color code  | Result
----------- | -------------------------------------------
r           | red
rwb         | single line of alternating red, white, blue
r w b       | three horizontal lines of red, white, blue
wrrbbby     | One white, 2 reds, 2 blues and a yellow
w2r3by      | One white, 2 reds, 2 blues and a yellow
w3r w3r w3r | Same row repeated repeated 3 times
w3r 3       | Same row repeated repeated 3 times
