TARGET=$(PACKAGE).$(LIB_EXTENSION)
VARS:=$(wildcard var/*.txt)
TMPL:=$(wildcard tmpl/*.c)
SRCS:=$(wildcard src/*.c)
GCDAS:=$(SRCS:.c=.gcda)
OBJS:=$(SRCS:.c=.o)
INSTALL?=install
CCX:=$(CC)
MAKE_TARGET:=$(shell cat .make-target)

ifdef UNPACK_COVERAGE
CCX:=$(subst gcc,clang,$(CC))
COVFLAGS=-fprofile-instr-generate -fcoverage-mapping
endif

.PHONY: all install clean test coverage

all: $(TARGET)
	@echo "Exporting target name to .make-target"
	@echo $(TARGET) > .make-target

%.o: %.c
	$(CCX) $(CFLAGS) $(WARNINGS) $(COVFLAGS) $(CPPFLAGS) -o $@ -c $<

$(TARGET): $(OBJS)
	$(CCX) -o $@ $^ $(LDFLAGS) $(LIBS) $(PLATFORM_LDFLAGS) $(COVFLAGS)

install:
	$(INSTALL) $(TARGET) $(LIBDIR)
	rm -f $(OBJS) $(GCDAS)

clean:
	rm -f $(OBJS) $(GCDAS) $(TARGET)

test:
	@echo "Running tests..."
	LLVM_PROFILE_FILE=default.profraw testcase ./test/

coverage: test
	llvm-profdata merge -sparse default.profraw -o default.profdata && \
  	llvm-cov export $(MAKE_TARGET) \
		-instr-profile=default.profdata \
  		-ignore-filename-regex='.+/include/.*' \
  		-ignore-filename-regex='.+/deps/.*' \
  		-format=lcov > lcov.info
	llvm-cov report $(MAKE_TARGET) \
		-instr-profile=default.profdata \
		-ignore-filename-regex='.+/include/.*' \
  		-ignore-filename-regex='.+/deps/.*'
