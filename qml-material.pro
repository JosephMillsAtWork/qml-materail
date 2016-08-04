TEMPLATE = subdirs

SUBDIRS += \
                $$PWD/src \
                $$PWD/examples \
                $$PWD/tests

OTHER_FILES += \
                        $$PWD/README.md \
                        $$PWD/CHANGELOG.md
# include the docs
include(docs/docs.pri)
