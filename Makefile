# Created by: jhanna@home.com
# $FreeBSD: head/devel/spin/Makefile 508082 2019-08-04 09:07:47Z antoine $

PORTNAME=	spin
PORTVERSION=	6.5.0
CATEGORIES=	devel
DIST_SUBDIR=	spin

MAINTAINER=	ports@FreeBSD.org
COMMENT=	On-the-fly verification system for asynchronous concurrent systems

LICENSE=	BSD3CLAUSE
LICENSE_FILE=	${WRKSRC}/Src/LICENSE

RUN_DEPENDS=	gcc:lang/gcc9

USE_GITHUB=	yes
GH_ACCOUNT=	nimble-code
GH_PROJECT=	Spin
GH_TAGNAME=	version-${PORTVERSION}

MAKEFILE=	makefile
ALL_TARGET=	spin
MAKE_ARGS=	CC="${CC}" CFLAGS="${CFLAGS} -DNXT"

PORTDOCS=	*
PORTEXAMPLES=	*

OPTIONS_DEFINE=	DOCS EXAMPLES ISPIN
OPTIONS_DEFAULT=	ISPIN
OPTIONS_SUB=	yes
ISPIN_DESC=	Install ispin and TCL/Tk dependency
ISPIN_USES=	shebangfix tk

SHEBANG_FILES=	../iSpin/ispin.tcl
tk_OLD_CMD=	/bin/sh
tk_CMD=		${WISH} -f

post-patch-ISPIN-on:
	${REINPLACE_CMD} -e "s|exec wish|#exec wish|" ${WRKDIR}/Spin/iSpin/ispin.tcl

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/spin ${STAGEDIR}${PREFIX}/bin
	${INSTALL_MAN} ${WRKDIR}/Spin/Man/spin.1 ${STAGEDIR}${PREFIX}/man/man1

do-install-DOCS-on:
	@${MKDIR} ${STAGEDIR}${DOCSDIR}
	cd ${WRKDIR}/Spin/Doc && ${COPYTREE_SHARE} . ${STAGEDIR}${DOCSDIR}

do-install-EXAMPLES-on:
	@${MKDIR} ${STAGEDIR}${EXAMPLESDIR}
	cd ${WRKDIR}/Spin/Examples && ${COPYTREE_SHARE} . ${STAGEDIR}${EXAMPLESDIR}

do-install-ISPIN-on:
	${INSTALL_SCRIPT} ${WRKDIR}/Spin/iSpin/ispin.tcl ${STAGEDIR}${PREFIX}/bin/ispin

.include <bsd.port.mk>
