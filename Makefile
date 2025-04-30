TARGET=$(PACKAGE).$(LIB_EXTENSION)
VARS=$(wildcard var/*.txt)
TMPL=$(wildcard tmpl/*.c)
SRCS=$(wildcard src/*.c)
GCDAS=$(SRCS:.c=.gcda)
OBJS=$(SRCS:.c=.o)
INSTALL?=install

ifdef UNPACK_COVERAGE
COVFLAGS=--coverage
endif


.PHONY: all install clean

all: $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) $(WARNINGS) $(COVFLAGS) $(CPPFLAGS) -o $@ -c $<

$(TARGET): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS) $(LIBS) $(PLATFORM_LDFLAGS) $(COVFLAGS)

install:
	$(INSTALL) $(TARGET) $(LIBDIR)
	rm -f $(OBJS) $(GCDAS) *.so

clean:
	rm -f $(OBJS) $(GCDAS) *.so
