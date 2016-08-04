## make all the files avilable for qtcreator
OTHER_FILES += \
                    $$PWD/material.qdocconf \
                    $$PWD/material.qdoc \
                    $$PWD/materialize.css \
                    $$PWD/doc.qbs \
                    $$PWD/fixnavi.pl \
                    $$PWD/html-footer.qdocconf \
                    $$PWD/html-header-offline.qdocconf  \
                    $$PWD/qt-html-templates-offline.qdocconf \
                    $$PWD/html-config.qdocconf \
                    $$PWD/style.css \
                    $$PWD/main.css
                    ##IMAGES


defineReplace(targetPath) {
    return($$replace(1, /, $$QMAKE_DIR_SEP))
}

qt:greaterThan(QT_MAJOR_VERSION, 4) {
    QDOC_BIN = $$targetPath($$[QT_INSTALL_BINS]/qdoc)
    QDOC_MAINFILE = $$PWD/material.qdocconf
} else {
    QDOC_BIN = $$targetPath($$[QT_INSTALL_BINS]/qdoc3)
    QDOC_MAINFILE = $$PWD/material.qdocconf

    # cheap replacement of the Qt5 shell_quote function
    defineReplace(shell_quote) {
        return("\"$$1\"")
    }
}

HELPGENERATOR = $$targetPath($$[QT_INSTALL_BINS]/qhelpgenerator)

VERSION_TAG = $$replace(QBS_VERSION, "[-.]", )
message($$QBS_VERSION)



HTML_DOC_PATH=$$OUT_PWD/doc/html
equals(QMAKE_DIR_SEP, /) {
 # unix, mingw+msys
    QDOC = SRCDIR=$$PWD OUTDIR=$$HTML_DOC_PATH QBS_VERSION=$$QBS_VERSION QBS_VERSION_TAG=$$VERSION_TAG QT_INSTALL_DOCS=$$[QT_INSTALL_DOCS] $$QDOC_BIN
} else:win32-g++* {   # just mingw
    # The lack of spaces in front of the && is necessary!
    QDOC = set SRCDIR=$$PWD&& set OUTDIR=$$HTML_DOC_PATH&& set QBS_VERSION=$$QBS_VERSION&& set QBS_VERSION_TAG=$$VERSION_TAG&& set QT_INSTALL_DOCS=$$[QT_INSTALL_DOCS]&& $$QDOC_BIN
} else {   # nmake
    QDOC = set SRCDIR=$$PWD $$escape_expand(\\n\\t) \
           set OUTDIR=$$HTML_DOC_PATH $$escape_expand(\\n\\t) \
           set QBS_VERSION=0.3 $$escape_expand(\\n\\t) \
           set QBS_VERSION_TAG=0.3 $$escape_expand(\\n\\t) \
           set QT_INSTALL_DOCS=$$[QT_INSTALL_DOCS] $$escape_expand(\\n\\t) \
           $$QDOC_BIN
}

QHP_FILE = $$OUT_PWD/doc/html/qmlmaterial.qhp
QCH_FILE = $$OUT_PWD/doc/qml-material.qch

HELP_DEP_FILES += \
#                 $$PWD/src/material-example.qdoc \
                 $$PWD/material.qdoc \
                 $$QDOC_MAINFILE

html_docs.commands = $$QDOC $$QDOC_MAINFILE
html_docs.depends += $$HELP_DEP_FILES

qch_docs.commands = $$HELPGENERATOR -o $$shell_quote($$QCH_FILE) $$QHP_FILE
qch_docs.depends += html_docs

inst_qch_docs.files = $$QCH_FILE
inst_qch_docs.path = $$[QT_INSTALL_DOCS]/qml-material
inst_qch_docs.CONFIG += no_check_exist no_default_install
INSTALLS += inst_qch_docs

inst_html_docs.files = $$HTML_DOC_PATH
inst_html_docs.path = $$inst_qch_docs.path
inst_html_docs.CONFIG += no_check_exist no_default_install directory
INSTALLS += inst_html_docs

install_docs.depends = install_inst_qch_docs install_inst_html_docs
QMAKE_EXTRA_TARGETS += install_docs

docs.depends = qch_docs
QMAKE_EXTRA_TARGETS += html_docs qch_docs docs

unix{
fixnavi.commands = \
    cd $$targetPath($$PWD) && \
    perl fixnavi.pl -Dqcmanual -Dqtquick \
        materials.qdoc
}
QMAKE_EXTRA_TARGETS += fixnavi
