TEMPLATE = app
TARGET = game
QT += quick qml sensors multimedia widgets quickwidgets 3dcore 3drender 3dinput 3dextras 3dquick 3dquickextras
SOURCES +=  main.cpp \
    CellInformator.cpp \
    connector.cpp \
    delay.cpp \
    player.cpp \
    zyari.cpp
RESOURCES += res.qrc
android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    OTHER_FILES += android/AndroudManifest.xml
}

DISTFILES += \
    android/AndroidManifest.xml

HEADERS += \
    CellInformator.h \
    connector.h \
    player.h \
    zyari.h
