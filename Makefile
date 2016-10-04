# Makefile to build sunsetter for linux.

EXE = sunsetter

CXXFLAGS = -O3 -DNDEBUG
LDFLAGS = -O3

OBJECTS = aimoves.o bitboard.o board.o bughouse.o evaluate.o moves.o search.o capture_moves.o check_moves.o interface.o notation.o order_moves.o partner.o quiescense.o tests.o transposition.o validate.o

ifeq ($(ARCH),js)
CXX = em++
EXE = sunsetter.dev.js
EMFLAGS += -s TOTAL_MEMORY=43550000 -s EMTERPRETIFY=1 -s EMTERPRETIFY_ASYNC=1
EMFLAGS += --memory-init-file 0 -s NO_EXIT_RUNTIME=1 -s EXPORTED_FUNCTIONS="['_main', '_queue_command']" --pre-js pre.js --post-js post.js
#EMFLAGS += -s EMTERPRETIFY_ADVISE=1
EMFLAGS += -s EMTERPRETIFY_WHITELIST='["__Z10searchMove4moveii", "__Z10searchRootiP4movePi", "__Z12pollForInputv", "__Z12waitForInputv", "__Z15recursiveSearchPiS_S_P4moveiiS0_i", "__Z15searchFirstMove4moveii", "__Z19recursiveFullSearchPiS_S_P4moveiiS0_", "__Z21recursiveCheckEvasionPiS_S_P4moveiiS0_", "__Z6ponderv", "__Z6searchiiiii", "__Z8findMoveP4move", "__Z8testbpgniPPc", "_main"]'
CXXFLAGS += $(EMFLAGS)
LDFLAGS += $(EMFLAGS)
endif

# sunsetter is the default target, so either "make" or "make sunsetter" will do
$(EXE): $(OBJECTS) .depend
	$(CXX) $(EMFLAGS) $(LDFLAGS) $(OBJECTS) -o $(EXE)

sunsetter.js: sunsetter.dev.js preamble.js
	cat preamble.js sunsetter.dev.js > sunsetter.js

# so "make clean" will wipe out the files created by a make.
.PHONY:
clean:
	rm -f $(OBJECTS) $(EXE) .depend

.depend:
	$(CXX) $(DEPENDFLAGS) -MM $(OBJECTS:.o=.cpp) > $@

-include .depend
