all: bin/compiler65 src/opcodes6502.cr

bin/compiler65: src/*.cr src/opcodes6502.cr
	shards build

src/opcodes6502.cr: src/op6502.txt
	cd src && crystal run genopcodes.cr > opcodes6502.cr
