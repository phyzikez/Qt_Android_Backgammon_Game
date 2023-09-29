#include <QGuiApplication>
#include <QtWidgets>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQuickView>
#include "connector.h"
#include "CellInformator.h"

int main(int argc, char** argv)
{
    // Init
    QGuiApplication app(argc,argv);

    qmlRegisterType<CellInformator>("CellInfo", 1, 0, "CellInformator");

    // Main Object
    Connector connector;
    CellInformator::p_connector = &connector;

    // Start Intro
    connector.startIntro();

    // Start
    return app.exec();
}
