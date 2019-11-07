QT       += core gui network webenginewidgets
ICON      = resources/icons/icon.icns

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += gnu++11
CONFIG += sdk_no_version_check

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

win32 {
    SOURCES += \
        src/framelesswindow.cpp \
        src/notificationcenter.cpp
    RESOURCES += resources/shadowclash_windows.qrc
}

macx {
    OBJECTIVE_SOURCES += \
        src/framelesswindow.mm \
        src/notificationcenter.mm
    LIBS += -framework Cocoa -framework Security
    RESOURCES += resources/shadowclash_mac.qrc
    # Support low macOS version
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.10
}

unix:!mac {
    SOURCES += \
        src/notificationcenter.cpp
    RESOURCES += resources/shadowclash_linux.qrc
}

SOURCES += \
    src/aboutwindow.cpp \
    src/apirequest.cpp \
    src/appdelegate.cpp \
    src/appversionutil.cpp \
    src/clashconfig.cpp \
    src/clashresourcemanager.cpp \
    src/configmanager.cpp \
    src/enhancemodemanager.cpp \
    src/launchatlogin.cpp \
    src/logger.cpp \
    src/main.cpp \
    src/mainwindow.cpp \
    src/paths.cpp \
    src/proxyconfighelpermanager.cpp \
    src/runguard.cpp \
    src/systemtray.cpp \
    src/remoteconfigwindow.cpp

HEADERS += \
    src/appdelegate.h \
    src/appversionutil.h \
    src/clashconfig.h \
    src/clashresourcemanager.h \
    src/enhancemodemanager.h \
    src/framelesswindow.h \
    src/aboutwindow.h \
    src/apirequest.h \
    src/configmanager.h \
    src/launchatlogin.h \
    src/logger.h \
    src/mainwindow.h \
    src/notificationcenter.h \
    src/paths.h \
    src/proxyconfighelpermanager.h \
    src/runguard.h \
    src/systemtray.h \
    src/shadowclash.h \
    src/remoteconfigwindow.h

INCLUDEPATH += $$PWD/src/plog/include
INCLUDEPATH += $$PWD/src/yaml-cpp/include

FORMS += \
    ui/mainwindow.ui \
    ui/aboutwindow.ui \
    ui/remoteconfigwindow.ui

TRANSLATIONS += \
    translations/shadowclash_en.ts

!include("src/fervor/Fervor.pri") {
    error("Unable to include Fervor autoupdater.")
}

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    resources/shadowclash.qrc

APP_QML_FILES.files += resources/clashxdashboard
APP_QML_FILES.files += resources/yacddashboard
APP_QML_FILES.path = Contents/Resources

QMAKE_BUNDLE_DATA += APP_QML_FILES

LIBS += $$PWD/framework/libyaml-cpp.a
LIBS += $$PWD/framework/shadowclash.a
