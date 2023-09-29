#pragma once
#include <QtWidgets>
#include <QtQuickWidgets>
#include <QQmlContext>
#include <QtCore>
#include <map>
#include <list>
#include <tuple>

class Player
{
    friend class Connector;
    friend class CellInformator;

    // Player's UI Zyara Block Id-Name
    QString zyaraRowIdName;
    // Player's UI Column Figures Id-Name
    QString columnFigures;

    // Helper Row From Connector
    std::array<std::tuple<int, int, char, int>, 24>& row;
    // Set Of Currently Enabled Move
    std::map<int, std::list<std::tuple<int, int, int>>> enableMoves;

    // Move Info
    std::pair<int, int> moveInfo;
    // Is Winner
    bool isWinner;
    // Is Ready To Leave Board
    bool isLeaveBoard;
    // Is The Most First Move
    bool isFirstMove;
    // Legal Move Count From head
    int countFromHead;

public:
    // CTOR
    Player(QString zyaraRow, QString column, std::array<std::tuple<int, int, char, int>, 24>& ConRow);
};
