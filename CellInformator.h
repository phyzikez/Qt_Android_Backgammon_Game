#pragma once
#include <QtWidgets>
#include <QtQuickWidgets>
#include <QQmlContext>
#include <QtCore>
#include "connector.h"

class CellInformator : public QObject
{
    Q_OBJECT
    QPair<int, int> m_changedCell;
    int from_AI;
    int to_AI;
    int _delta;
public:
    static inline Connector* p_connector = nullptr;
    CellInformator(QObject* pobj = 0);

    Q_INVOKABLE int get_from(){ return from_AI; }
    Q_INVOKABLE int get_to(){ return to_AI; }
    Q_INVOKABLE bool get_isAI(){ return p_connector->isGameAI; }

    // Get Dragged Info
    Q_INVOKABLE void updateCellInfo(const int& oldPos, const int& newPos);
    // Target Cell Validation
    Q_INVOKABLE bool isTargetValid(const int& oldPos, const int& newPos);
    Q_INVOKABLE static double updateX();
    Q_INVOKABLE static double updateY();
    Q_INVOKABLE bool isCurrentFigureName(QString name);
    Q_INVOKABLE QString highlightCell(bool isTarget);
    Q_INVOKABLE bool isTestMode();
    Q_INVOKABLE void deactivateFirstCurMove();
    Q_INVOKABLE void activateGameAI(bool isAI);
    Q_INVOKABLE void moveAI();
    Q_INVOKABLE bool isTotalMoveAI();
    Q_INVOKABLE void activateSwitch();
    Q_INVOKABLE void activateUpdateEnableMoves();
    Q_INVOKABLE bool isEnableMovesAIExist();
    Q_INVOKABLE void activateShowTest();
signals:
};
