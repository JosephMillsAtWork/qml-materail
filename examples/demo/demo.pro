TEMPLATE = app

QT += qml quick

SOURCES += \
                        $$PWD/main.cpp

RESOURCES += \
                        $$PWD/demo.qrc \
                        $$PWD/icons/icons.qrc

target.path = $$[QT_INSTALL_EXAMPLES]/material/demo
INSTALLS += target
