# crystal-65xx

This will be a compiler for 65xx assembly.  It will create a .prg file that could be run on a 65xx emulator, like vice, or even a real c64.

This is mainly a hobby project.  I'm learning crystal, and I used to program for the commodore 64 years ago, so this seemed like something interesting and fun to do.

It will not be an emulator, just a compiler.  I was thinking of writing a d64 disk format manipulator too, but that might be later.

## Installation

Right now I have just written a basic lexer.  I am writing the parser/tokenizer now.
You must have crystal installed.  Then run `shards build` to build the binary into `bin`.  Right now there aren't really any dependencies, although that will probably change later.

## Usage

Just create a source file, `hello.c65` is provided as an example.  Then run `bin/compiler -f hello.c65` to compile.  Names are subject to change.

## Development

Lots of stuff to do still.

## Contributing

1. Fork it (<https://github.com/your-github-user/compiler/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Lance Dillon](https://github.com/riffraff169) - creator and maintainer
