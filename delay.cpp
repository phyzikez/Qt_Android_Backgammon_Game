#pragma once
#include <QtCore>

// System Delay
void delay(int ms) {
    QEventLoop loop;
    QTimer::singleShot(ms, &loop, SLOT(quit()));
    loop.exec();
}
