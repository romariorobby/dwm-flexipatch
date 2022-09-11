# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

# FreeBSD users, prefix all ifdef, else and endif statements with a . for this to work (e.g. .ifdef)

ifdef YAJLLIBS
all: options dwm dwm-msg
else
all: options dwm
endif

options:
	@echo dwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk patches.h

config.h:
	cp config.def.h $@

patches.h:
	cp patches.def.h $@

list-patches-enabled:
	@grep -r "^#define \w* 1" patches.def.h | cut -d' ' -f2 | sed 's/_PATCH//g'

list-patches:
	@grep -r "^#define \w*" patches.def.h | cut -d' ' -f2 | sed 's/_PATCH//g'

dwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

ifdef YAJLLIBS
dwm-msg:
	${CC} -o $@ patch/ipc/dwm-msg.c ${LDFLAGS}
endif

clean:
	rm -f config.h patches.h dwm ${OBJ} dwmf-${VERSION}.tar.gz
	rm -f dwm-msg

dist: clean
	mkdir -p dwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		dwm.1 drw.h util.h dwm.desktop ${SRC} dwm.png transient.c dwm-${VERSION}
	tar -cf dwmf-${VERSION}.tar dwm-${VERSION}
	gzip dwmf-${VERSION}.tar
	rm -rf dwm-${VERSION}

req:
	./requirement.sh

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwm ${DESTDIR}${PREFIX}/bin/dwmf
ifdef YAJLLIBS
	cp -f dwm-msg ${DESTDIR}${PREFIX}/bin
endif
	cp -f patch/dwmc ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwmf
ifdef YAJLLIBS
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm-msg
endif
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwmf.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwmf.1
	mkdir -p ${DESTDIR}${XSPREFIX}/xsessions
	cp -f dwm.desktop ${DESTDIR}${XSPREFIX}/xsessions/dwmf.desktop
	chmod 644 ${DESTDIR}${XSPREFIX}/xsessions/dwmf.desktop

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dwmf\
		${DESTDIR}${MANPREFIX}/man1/dwmf.1\
		${DESTDIR}${XSPREFIX}/xsessions/dwmf.desktop

.PHONY: all options clean dist install uninstall
