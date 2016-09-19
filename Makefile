# Makefile to build sunsetter for linux.

EXE = sunsetter
CC = clang

CFLAGS = -O3 -DNDEBUG

OBJECTS = aimoves.o bitboard.o board.o bughouse.o evaluate.o moves.o search.o capture_moves.o check_moves.o interface.o notation.o order_moves.o partner.o quiescense.o tests.o transposition.o validate.o

ifeq ($(ARCH),js)
CC = em++
EXE = sunsetter.dev.js
CFLAGS += -s TOTAL_MEMORY=33550000 -s EMTERPRETIFY=1 -s EMTERPRETIFY_ASYNC=1
CFLAGS += -s EMTERPRETIFY_ADVISE
LINKFLAGS += --memory-init-file 0 -s NO_EXIT_RUNTIME=1 -s EXPORTED_FUNCTIONS="['_main', '_queue_command']" --pre-js pre.js --post-js post.js
endif

# sunsetter is the default target, so either "make" or "make sunsetter" will do
$(EXE): $(OBJECTS) .depend
	$(CC) $(LDFLAGS) $(OBJECTS) -o $(EXE)

sunsetter.js: sunsetter.dev.js preamble.js
	cat preamble.js sunsetter.dev.js > sunsetter.js

# so "make clean" will wipe out the files created by a make.
.PHONY:
clean:
	rm -f $(OBJECTS) $(EXE) .depend

.depend:
	$(CC) $(DEPENDFLAGS) -MM $(OBJECTS:.o=.cpp) > $@

-include .depend
