#pragma once
#include <QtWidgets>
#include <QtQuickWidgets>
#include <QQmlContext>
#include <QtCore>
#include <QtMultimedia>
#include <array>
#include <map>
#include <set>
#include <list>
#include <algorithm>
#include <numeric>
#include <tuple>
#include "zyari.h"
#include "player.h"

class Connector : public QObject
{
    Q_OBJECT
    friend class CellInformator;
private:
    // Path To Main Qml
    QUrl *pm_qurl;
    // App's Engine
    QQmlApplicationEngine *pm_engine;
    // Qml Component
    QQmlComponent *pm_component;
    // Qml Root Object
    QObject* pm_root;

    // Fixed Board Sizes
    const int cols = 13;
    const int rows = 20;
    std::array<char, 260> board;

    // Main Board
    static std::pair<int, int> dragInfo;
    // Helper Rows
    std::array<std::tuple<int, int, char, int>, 24> whiteRow, blackRow;

    // Dice
    Zyari *pm_zyari;

    // Players
    std::pair<Player, Player> players;
    // Current Player
    Player* curPlayer;

    // Statistics
    std::map<std::pair<int, int>, int> stat;

    // Test Mode
    bool isTest  = false;
    // Is First Current Move
    bool isCurMoveFirst = true;
    // Game With AI
    bool isGameAI = false;

    int delta;

public:
    // CTOR
    Connector(QObject* pobj = 0);
    // Init Events
    void activateEvents(QObject *pm_root);
    // Test Show Board
    void showTest();
    // Update Board
    void updateBoard(std::pair<int, int> draggedItem, bool isAI = false);
    void updateRows();
    int getColFigCount(int col);
    void playerInfoUpdate();
    bool isMoveValid(int oldPos, int newPos, bool isTestMode = true);
    char isUpper(int pos, char fig) const;
    void startGame();
    bool isCurrentPlayer1();
    int countFiguresInRange(std::array<std::tuple<int, int, char, int>, 24>& row, int start, int end);
    void updateEnableMoves();
    int boardFromRow(int rowPos, bool isTargetPos = false);
    QString getValidCells(bool isTarget);
    std::pair<int, int> moveAI();
public slots:
    // --------- LOGIC --------- //
    // Init Board
    void initBoard();
    // Generate Random Values Of Zyara
    void genRnd();
    void switchPlayer();
    void updateStatistics(std::pair<int, int> genZyara);
    // Init/Reset Statistics
    void resetStatistics();
    void showEnableMoves();

    // ---------- UI ---------- //
    void startIntro();
    // Gaming UI
    void openMenuContext();
    void switchMute();
    // Context Menu
    void goToMainMenu();
    void openStatistics();
    void closeMenuContext();
    void closeStatistics();
    // Main Menu
    void newGameAI();
    void newGamePlayer();
    // void startGameTestExit();
    void playGame();
    void exitGame();
};
