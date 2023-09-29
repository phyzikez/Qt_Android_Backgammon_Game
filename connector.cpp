#include "connector.h"

// CTOR
Connector::Connector(QObject* pobj) :  QObject(pobj),
                                        pm_qurl {new QUrl("qrc:/Style/Style.qml")},
                                        pm_engine {new QQmlApplicationEngine()},
                                        pm_component {new QQmlComponent(pm_engine, *pm_qurl)},
                                        pm_root {pm_component->create()},
                                        pm_zyari {new Zyari()},
                                        players {
                                            Player("zyara_p1", "columnWhite", whiteRow),
                                            Player("zyara_p2", "columnBlack", blackRow)}
{
    // Init Inner Game Board
    initBoard();
    // Init Current Game Statistic
    resetStatistics();
    // Setting Signal-Slot Connections
    activateEvents(pm_root);

    startGame();
}

void Connector::activateEvents(QObject* pm_root) {
    // Switch Mute Button
    QObject* p_switchMute = pm_root->findChild<QObject*>("switchMute");
    if (p_switchMute) {
        QObject::connect(p_switchMute, SIGNAL(switched()), this, SLOT(switchMute()));
    }

    // Open Context Menu
    QObject* p_menuButton = pm_root->findChild<QObject*>("menuButton");
    if (p_menuButton) {
        QObject::connect(p_menuButton, SIGNAL(menuClicked()), this, SLOT(openMenuContext()));
    }

    // Return To Game
    QObject* p_buttonReturn = pm_root->findChild<QObject*>("buttonReturn");
    if (p_buttonReturn) {
        QObject::connect(p_buttonReturn, SIGNAL(menuClicked()), this, SLOT(closeMenuContext()));
    }

    // Go To Main Menu
    QObject* p_msgMainMenuDialog = pm_root->findChild<QObject*>("msgMainMenuDialog");
    if (p_msgMainMenuDialog) {
        QObject::connect(p_msgMainMenuDialog, SIGNAL(menuClicked()), this, SLOT(goToMainMenu()));
    }

    // Open Statistics
    QObject* p_buttonStatistics = pm_root->findChild<QObject*>("buttonStatistics");
    if (p_buttonStatistics) {
        QObject::connect(p_buttonStatistics, SIGNAL(menuClicked()), this, SLOT(openStatistics()));
    }

    // Close Statistics
    QObject* p_closeStatistics = pm_root->findChild<QObject*>("closeStatistics");
    if (p_closeStatistics) {
        QObject::connect(p_closeStatistics, SIGNAL(menuClicked()), this, SLOT(closeStatistics()));
    }

    // Exit Game
    QObject* p_exitGame = pm_root->findChild<QObject*>("msgExitGame");
    if (p_exitGame) {
        qDebug() << "exit - 1";
        QObject::connect(p_exitGame, SIGNAL(exitApp()), this, SLOT(exitGame()));
    }

    // New Game AI
    QObject* p_newGameAI = pm_root->findChild<QObject*>("newGameAI");
    if (p_newGameAI) {
        QObject::connect(p_newGameAI, SIGNAL(startGameAI()), this, SLOT(newGameAI()));
    }

    // New Game Player
    QObject* p_newGamePlayer = pm_root->findChild<QObject*>("newGamePlayer");
    if (p_newGamePlayer) {
        QObject::connect(p_newGamePlayer, SIGNAL(startGamePlayer()), this, SLOT(newGamePlayer()));
    }

    // TEST CASE EXIT
//    QObject* p_newGameTestExit = pm_root->findChild<QObject*>("newGameTestExit");
//    if (p_newGameTestExit) {
//        QObject::connect(p_newGameTestExit, SIGNAL(startGameTestExit()), this, SLOT(startGameTestExit()));
//    }

    // Play Game
    QObject* p_confirmPlayer = pm_root->findChild<QObject*>("confirmPlayer");
    if (p_confirmPlayer) {
        QObject::connect(p_confirmPlayer, SIGNAL(startGame()), this, SLOT(playGame()));
    }
}

void Connector::initBoard() {
    // Init Board
    std::fill(board.begin(), board.end(), '-');
    for (int i=5; i<=20; i++) {
        board[i*13] = 'x';
    }
    for (int i=0; i<=14; i++) {
        board[i*13+12] = 'o';
    }
    for (int i=0; i<=20; i++) {
        board[i*13+6] = '%';
    }

    // Init Helper Rows
    updateRows();
}

// ------------------- LOGIC ------------------ //

// Debug Show Board
void Connector::showTest() {

    // BOARD TEST SHOW
//    std::string out[20];
//    for (int i=0; i<rows; i++){
//        for (int j=0; j<cols; j++){
//            out[i] += board[i*13+j];
//        }
//    }
//    for (auto &s : out){
//        qDebug() << s << Qt::endl;
//    }

    //qDebug() << "----- CUR : " << (curPlayer == &players.first ? "W" : "B") << " ----- "
        //<< "------------ TOTAL : " << curPlayer->moveInfo.first
        //<< " ----- RELEASED: " <<curPlayer->moveInfo.second << "----- " << Qt::endl
      //  ;

    // WHITE ROW TEST SHOW
    QStringList s1,s2,s3,s4;
    QString temp = "";
    for (int i=0; i<24; ++i) {
        temp = QString::number((int)std::get<0>(curPlayer->row[i]));
        temp += QString(3-temp.length(), ' ');
        s1 << temp;
        temp = QString::number((int)std::get<1>(curPlayer->row[i]));
        temp += QString(3-temp.length(), ' ');
        s2 << temp;
        temp = QString((char)std::get<2>(curPlayer->row[i]));
        temp += "  ";
        s3 << temp;
        temp = QString::number((int)std::get<3>(curPlayer->row[i]));
        temp += QString(3-temp.length(), ' ');
        s4 << temp;
    }
    qDebug()
        << "----------------------- " << (curPlayer == &players.first ? "WHITE" : "BLACK") << " ------------------------ " << Qt::endl
        << s1 << Qt::endl
        << s2 << Qt::endl
        << s3 << Qt::endl
        << s4 << Qt::endl
    ;
}

int Connector::getColFigCount(int col) {
    int res = 0;
    char fig = board[col];
    bool isIncrease = (col < 13) ? true : false;
    // If Empty '-'
    if (fig == '-'){
        return 0;
    }
    // Accumulate
    do {
        res++;
        isIncrease ? col+=13 : col-=13;
    } while (board[col] == fig);
    return res;
}

// Count Number Of Figures In Specified Range
int Connector::countFiguresInRange(std::array<std::tuple<int, int, char, int>, 24> &row, int start, int end) {
    return std::accumulate(row.begin()+start, row.begin()+end+1, 0,
                           [](int &ac, auto& tup){ return ac + std::get<3>(tup); });
}

void Connector::updateRows(){
    // Update White & Black Rows
    // Quad I
    for (int i=12; i>6; i--) {
        whiteRow[12-i] = std::make_tuple(12-i, i, board[i], getColFigCount(i));
        blackRow[24-i] = std::make_tuple(24-i, i, board[i], getColFigCount(i));
    }
    // Quad II
    for (int i=5; i>=0; i--) {
        whiteRow[11-i] = std::make_tuple(11-i, i, board[i], getColFigCount(i));
        blackRow[23-i] = std::make_tuple(23-i, i, board[i], getColFigCount(i));
    }
    // Quad III
    for (int i=247; i<253; i++) {
        whiteRow[i-235] = std::make_tuple(i-235, i, board[i], getColFigCount(i));
        blackRow[i-247] = std::make_tuple(i-247, i, board[i], getColFigCount(i));
    }
    // Quad IV
    for (int i=254; i<260; i++) {
        whiteRow[i-236] = std::make_tuple(i-236, i, board[i], getColFigCount(i));
        blackRow[i-248] = std::make_tuple(i-248, i, board[i], getColFigCount(i));
    }
}

char Connector::isUpper(int pos, char fig) const {
    const char UP = 'U';
    const char DOWN = 'D';
    if (pos/13 == 0) return UP;
    if (pos/13 == 19) return DOWN;
    if (board[pos+13] != fig) return UP;
    if (board[pos-13] != fig) return DOWN;
}

// Update Board (If True - Redraw)
void Connector::updateBoard(std::pair<int, int> dragged_Item, bool isAI /*false default*/) {
    std::pair<int, int> draggedItem = dragged_Item;
    //qDebug() << "OLD: " << draggedItem.first << "NEW: " << draggedItem.second;

    // Update Main Board
    if (draggedItem.first != draggedItem.second) {
        board[draggedItem.second] = board[draggedItem.first];
        board[draggedItem.first] = '-';
    }

    // Update Inner Boards
    updateRows();

    // Check If Exit-Cell Needs To be Shown
    char curCh = (curPlayer == &players.first ? 'o' : 'x');

    int n_figs = std::accumulate(curPlayer->row.begin()+18, curPlayer->row.end(), 0, [&](int &ac, auto& tup) {
        return ac + (std::get<2>(tup) == curCh ? std::get<3>(tup) : 0);
    });
    if (n_figs == 15) {
        QObject* p_exitCell = pm_root->findChild<QObject*>(curPlayer == &players.first ? "exitCellWhite" : "exitCellBlack");
        p_exitCell->setProperty("visible", true);
        curPlayer->isLeaveBoard = true;
    }

    // If Win State
    int n_last = std::accumulate(curPlayer->row.begin(), curPlayer->row.end(), 0, [&](int &ac, auto& tup) {
        return ac + (std::get<2>(tup) == curCh ? std::get<3>(tup) : 0);
    });
    if (n_last == 0) {
        qDebug() << "WIN!";
        QObject* p_winWindow = pm_root->findChild<QObject*>("winnerWindow");
        p_winWindow->setProperty("visible", true);
    }

    if (!(curPlayer == &players.second && isAI == true) && curPlayer->moveInfo.first <= 0) {
        // Full Move Is Done / No Moves --> Switch Player
        switchPlayer();
    }

    if (!(curPlayer == &players.second && isAI == true)) {
        // Test Output
        showTest();
        // Update Valid Moves
        updateEnableMoves();
    }
}

// Check The Move Is Valid
bool Connector::isMoveValid(int oldPos, int newPos, bool isTestMode) {
    // HELPERS
    // Current And Opponent's Figures
    char fig = board[oldPos];
    char figOpp = (fig == 'o' ? 'x' : 'o');
    // Board's Column Id
    int oldCol = oldPos%13;
    int newCol = newPos%13;
    // Up/Down Pos
    char oldIsUpper = isUpper(oldPos, fig);
    char newIsUpper = isUpper(newPos, fig);
    // Key Column Id
    int cidOld, cidNew;

    // Get Indices
    int cOld = oldIsUpper == 'U' ? oldCol : (oldPos + 13*(19 - oldPos/13));
    int cNew = newIsUpper == 'U' ? newCol : (newPos + 13*(19 - newPos/13));
    cidOld = std::get<0>(*std::find_if(curPlayer->row.begin(), curPlayer->row.end(),
                                       [&](const auto &tup) { return std::get<1>(tup) == cOld; }));
    cidNew = std::get<0>(*std::find_if(curPlayer->row.begin(), curPlayer->row.end(),
                                       [&](const auto &tup) { return std::get<1>(tup) == cNew; }));

    //Test Output
//    qDebug() // << "\t[" // << fig
//        << "TRY MOVE FROM POS" << oldPos /* << " {" << oldCol << " | " << oldIsUpper << " | " << cidOld << "}" */
//        << " --> TO POS" << newPos /* << " {" << newCol << " | " << newIsUpper << " | " << cidNew << "}" */
//    ;
//    qDebug() << "NEED TO MOVE [ BY ZYARA ] : " << curPlayer->moveInfo.first << " | DONE MOVES : " << curPlayer->moveInfo.second << Qt::endl;

    // VALIDATION STAGES
    bool oldOk = false, newOk = false, zyaraOk = false;

    // --------------------------------- ZYARA RESTRICTIONS ------------------------------- //
    // Stage 3.1. Zyara-Cell Check
    if (std::abs(cidNew - cidOld) == pm_zyari->z1 ||
        std::abs(cidNew - cidOld) == pm_zyari->z2 ||
        std::abs(cidNew - cidOld) == pm_zyari->z1 + pm_zyari->z2 ||
        // Kosha --> Boost x4
        (pm_zyari->isKosha() && (std::abs(cidNew - cidOld) == 3*pm_zyari->z2
                                 || std::abs(cidNew - cidOld) == 4*pm_zyari->z2)) ) {
        zyaraOk = true;
    }

    // Stage 3.3. Zyara Already Moved
    if (((std::abs(cidNew - cidOld) == curPlayer->moveInfo.second) && (!pm_zyari->isKosha())) ||
        std::abs(cidNew - cidOld) > curPlayer->moveInfo.first) {
        qDebug() << "[ ACHTUNG ] : [ ERROR BAD MOVE ] : " << "This Zyara's Move Was Done" << Qt::endl;
        zyaraOk = false;
    }

    // --------------------------------- START POSTION ---------------------------------- //
    // Stage 1.1. Source Figure At The Board Edge
    if ((oldPos/13 == 0 && board[oldPos+13] == '-') || (oldPos/13 == 19 && board[oldPos-13] == '-')) {
        oldOk = true;
    }

    // Stage 1.2. Source Figure At The Top Of Column
    else if (((oldPos/13 != 0 && board[oldPos-13] != fig && board[oldPos+13] == fig) ||
            (oldPos/13 != 19 && board[oldPos+13] != fig && board[oldPos-13] == fig))) {
        oldOk = true;
    }

    // Stage 1.3. Move From Head
    if (cidOld == 0 && curPlayer->countFromHead == 0) {
        qDebug() << "[ ACHTUNG ] : [ ERROR BAD MOVE ] : " << "Move From Head Is Done" << Qt::endl;
        oldOk = false;
    }

    // --------------------------------- TARGET POSTION -------------------------------- //
    // Stage 2.1. Empty Target Cell
    if (board[newPos] == '-') {

        // Stage 2.2. Target Cell At The Board Edge
        if (newPos/13 == 0 || newPos/13 == 19) {
            newOk = true;
        }
        else {
            // Stage 2.3. Target Cell At The Top Of Column
            if ((std::abs(newPos-oldPos) != 13) && ((board[newPos-13] != fig && board[newPos+13] == fig) ||
                (board[newPos+13] != fig && board[newPos-13] == fig))) {
                newOk = true;
            }
        }
    }

    if (board[newPos] == '%') {
        newOk = false;
    }

    // Stage 2.4. New Pos > Old Pos
    if ((cidNew < cidOld) && (cidNew >= 0 && cidNew < 24)) {
        qDebug() << "[ ACHTUNG ] : [ ERROR BAD MOVE ] : " << "Reversed Direction" << Qt::endl;
        oldOk = newOk = false;
    }

    // Stage 2.5. No Way
    if (pm_zyari->isKosha()) {
        if (std::get<2>(curPlayer->row[cidOld+pm_zyari->z1]) == figOpp) {
            qDebug() << "[ ACHTUNG ] : [ ERROR BAD MOVE ] : " << "Opponent Is Here" << Qt::endl;
            newOk = false;
        }
    }
    else {
        if (std::get<2>(curPlayer->row[cidOld+pm_zyari->z1]) == figOpp &&
            std::get<2>(curPlayer->row[cidOld+pm_zyari->z2]) == figOpp ) {
            qDebug() << "[ ACHTUNG ] : [ ERROR BAD MOVE ] : " << "Opponent Is Here" << Qt::endl;
            newOk = false;
        }
    }

    // Stage 2.6. Prevent Of Blocking I and II Quad Cells With No One Opponent's Figure
    // Helper Lambda To Count Figures In Range By Edge
    auto counter = [&](int start, int end, char f) -> int {
        return std::count_if(curPlayer->row.begin() + start,
                             curPlayer->row.begin() + end + 1,
                             [&](auto& tup){ return std::get<2>(tup) == f; }

    );};

    // Prevent Of Block Of 6 Figures Aside In I-II Quads
    if (cidNew > 0 && cidNew < 12) {
        if (counter(6, 11, figOpp) == 0) {
            // !!! ILLEGAL CHANGING DATA BEGIN ////////////////////////
            char realFigTarget = std::get<2>(curPlayer->row[cidNew]);
            --std::get<3>(curPlayer->row[cidOld]);
            if (std::get<3>(curPlayer->row[cidOld]) == 0) std::get<2>(curPlayer->row[cidOld]) = '-';
            std::get<2>(curPlayer->row[cidNew]) = fig;
            //qDebug() << "ILLEGAL DONE" << Qt::endl;
            //showTest();
            for (int i=0; i<=6; ++i) {
                if (counter(0+i, 5+i, fig) == 6) {
                    qDebug() << "[ ACHTUNG ] : [ ERROR BAD MOVE ] : " << "6 Figures Aside Blocks Opponent Opportunity To Go" << Qt::endl;
                    newOk = false;
                }
            }
            std::get<2>(curPlayer->row[cidOld]) = fig;
            ++std::get<3>(curPlayer->row[cidOld]);
            std::get<2>(curPlayer->row[cidNew]) = realFigTarget;
            // !!! ILLEGAL CHANGING DATA END //////////////////////////
        }
    }

    // Stage 5. Validation Within Accumulated Valid Moves (Figure Is Dropped, Not Loop Check)
    if (isTestMode == false) {
        // Check From-Pos
        auto iterFrom = std::find_if(curPlayer->enableMoves.begin(), curPlayer->enableMoves.end(), [&](auto& pr){
            auto it = std::find_if(pr.second.begin(), pr.second.end(), [&](auto& tup) {
                return std::get<0>(tup) == cidOld;
            });
            return it == pr.second.end() ? false : true;
        });
        if (iterFrom == curPlayer->enableMoves.end()) oldOk = false;
        // Check To-Pos
        auto iterTo = std::find_if(curPlayer->enableMoves.begin(), curPlayer->enableMoves.end(), [&](auto& pr){
            auto it = std::find_if(pr.second.begin(), pr.second.end(), [&](auto& tup) {
                return std::get<1>(tup) == cidNew;
            });
            return it == pr.second.end() ? false : true;
        });
        if (iterTo == curPlayer->enableMoves.end()) newOk = false;
    }

    // -------------------------- ADDITIONAL CONDITIONS ------------------------- //
    // Update If Validation Ok
    bool res = oldOk && newOk && zyaraOk;

    ////////////////////////////  EXIT  ////////////////////////////////

    // Stage 4.1. Figure Leaves The Board (Good Bye Figure)
    // Helper BoostDelta Figure To Leave The Board
    delta = 0;

    if (curPlayer->isLeaveBoard == true &&
        ((newPos >= 260 && curPlayer == &players.first) || (newPos < 0 && curPlayer == &players.second)) &&
        //newPos == ((curPlayer == &players.first) ? 260 : -1) &&
        std::get<2>(curPlayer->row[cidOld]) == fig) {
        cidNew = 24;
        // Figure Matches Zyara
        if (std::abs(cidNew - cidOld) == pm_zyari->z1 ||
            std::abs(cidNew - cidOld) == pm_zyari->z2 ||
            std::abs(cidNew - cidOld) == pm_zyari->z1 + pm_zyari->z2 ||
            (pm_zyari->isKosha() && (std::abs(cidNew - cidOld) == 3*pm_zyari->z1 ||
                                     std::abs(cidNew - cidOld) == 4*pm_zyari->z1)) ) {
            res = true;
        }
        else {
            // Figure Doesn't Match Zyara But Can Exit
            int firstFigPosIV = 18;
            for (; firstFigPosIV < 24; ++firstFigPosIV) {
                if (std::get<2>(curPlayer->row[firstFigPosIV]) == fig) {
                    break;
                }
            }
            if (firstFigPosIV == cidOld) {
                if (std::abs(cidNew - cidOld) < pm_zyari->z1) {
                    delta = pm_zyari->z1 - std::abs(cidNew - cidOld);
                    res = true;
                }
                else if (std::abs(cidNew - cidOld) < pm_zyari->z2) {
                    delta = pm_zyari->z2 - std::abs(cidNew - cidOld);
                    res = true;
                }
            }
        }

        // Already Moved
        if (((std::abs(cidNew - cidOld) == curPlayer->moveInfo.second) && (!pm_zyari->isKosha())) ||
            std::abs(cidNew - cidOld) > curPlayer->moveInfo.first) {
            qDebug() << "[ ACHTUNG ] : MOVED ALREADY THIS " << Qt::endl;
            res = false;
        }

    }
    ////////////////////////////////////////////////////////////////////

    if (res == true && isTestMode == false) {
        // 4.2. Setting First Move State
        if (curPlayer->isFirstMove) {
            curPlayer->isFirstMove = false;
        }
        // 4.3. If Move From Head
        if (cidOld == 0) {
            curPlayer->countFromHead--;
        }
        curPlayer->moveInfo.second += (cidNew - cidOld + delta);
        curPlayer->moveInfo.first -= (cidNew - cidOld + delta);
    }
    return res;
}

// Get Board Pos From Row Pos (Current Player)
int Connector::boardFromRow(int pos, bool isTargetPos) {
    bool isUpper = ((curPlayer == &players.first && pos < 12) || (curPlayer == &players.second && pos > 11)) ? true : false;
    int res = std::get<1>(curPlayer->row[pos]) + 13 * (std::get<3>(curPlayer->row[pos]) - (isTargetPos ? 0 : 1)) * (isUpper ? 1 : -1);
    if (pos == 24 && isTargetPos == true) res = (curPlayer == &players.first ? 260 : -1);
    qDebug() << "CONVERTER IN : " << pos << " ------> OUT: " << res << Qt::endl;
    return res;
}

// Get Enabled Valid Cells To Move
QString Connector::getValidCells(bool isTarget /*false --> from*/) {
    std::set<int> rowIds;
    for (auto &pr : curPlayer->enableMoves){
        for (auto &tup : pr.second) {
            rowIds.insert(boardFromRow(isTarget ? std::get<(1)>(tup) : std::get<(0)>(tup), isTarget ? true : false));
        }
    }
    QString ids = "";
    for (auto& el : rowIds) {
        ids += (QString().number(el) + ",");
    }
    ids.removeAt(ids.size()-1);
    //qDebug() << ids << Qt::endl;
    return ids;
}

// Update Enable Moves Of Current Player
void Connector::updateEnableMoves() {
    // Clear Deprecated Info
    curPlayer->enableMoves.clear();

    char fig = ((curPlayer == &players.first) ? 'o' : 'x');
    char figOpp = ((curPlayer == &players.first) ? 'x' : 'o');

    // Hepler Lambda
    auto fillList = [&](int _from, int _to, std::list<std::tuple<int, int, int>>& _lst){
        int _count = (_from == 0) ? (curPlayer->isFirstMove && pm_zyari->isKosha() ? 2 : 1)
                                  : std::get<3>(curPlayer->row[_from]);
        _lst.push_back(std::make_tuple(_from, _to, _count));
    };

    // Update Info
    if (pm_zyari->isKosha()) {
        std::list<std::tuple<int, int, int>> list_z_x1;
        std::list<std::tuple<int, int, int>> list_z_x2;
        std::list<std::tuple<int, int, int>> list_z_x3;
        std::list<std::tuple<int, int, int>> list_z_x4;

        // Run Through The Whole Row To Find Player' Figure
        int N = 0;
        std::for_each(curPlayer->row.begin(), curPlayer->row.end(), [&](auto& tup){
            if (std::get<2>(tup) == fig) {

                N++;
                int from = std::get<0>(tup);
                int to_z_x1 = std::get<0>(tup) + pm_zyari->z1;
                int to_z_x2 = std::get<0>(tup) + 2*pm_zyari->z1;
                int to_z_x3 = std::get<0>(tup) + 3*pm_zyari->z1;
                int to_z_x4 = std::get<0>(tup) + 4*pm_zyari->z1;

                bool isX1 = false, isX2 = false, isX3 = false;
                if (to_z_x1 < 24 && std::get<2>(curPlayer->row[to_z_x1]) != figOpp &&
                    isMoveValid(boardFromRow(from), boardFromRow(to_z_x1, true))) {
                    fillList(from, to_z_x1, list_z_x1);
                    isX1 = true;
                }
                if (isX1 == true && to_z_x2 < 24 && std::get<2>(curPlayer->row[to_z_x2]) != figOpp &&
                    isMoveValid(boardFromRow(from), boardFromRow(to_z_x2, true))) {
                    fillList(from, to_z_x2, list_z_x2);
                    isX2 = true;
                }
                if (isX2 == true && to_z_x3 < 24 && std::get<2>(curPlayer->row[to_z_x3]) != figOpp &&
                    isMoveValid(boardFromRow(from), boardFromRow(to_z_x3, true))) {
                    fillList(from, to_z_x3, list_z_x3);
                    isX3 = true;
                }
                if (isX3 == true && to_z_x4 < 24 && std::get<2>(curPlayer->row[to_z_x4]) != figOpp &&
                    isMoveValid(boardFromRow(from), boardFromRow(to_z_x4, true))) {
                    fillList(from, to_z_x4, list_z_x4);
                }

                ///////// !!!!!!!!!!!!!! EXIT ////////////////////////
                if (to_z_x1 >= 24 && curPlayer->isLeaveBoard == true &&
                    isMoveValid(boardFromRow(from), (curPlayer == &players.first ? 260 : -1), true)) {
                    fillList(from, 24, list_z_x1);
                }
                if (to_z_x2 >= 24 && curPlayer->isLeaveBoard == true &&
                    isMoveValid(boardFromRow(from), (curPlayer == &players.first ? 260 : -1), true)) {
                    fillList(from, 24, list_z_x2);
                }
                if (to_z_x3 >= 24 && curPlayer->isLeaveBoard == true &&
                    isMoveValid(boardFromRow(from), (curPlayer == &players.first ? 260 : -1), true)) {
                    fillList(from, 24, list_z_x3);
                }
                if (to_z_x4 >= 24 && curPlayer->isLeaveBoard == true &&
                    isMoveValid(boardFromRow(from), (curPlayer == &players.first ? 260 : -1), true)) {
                    fillList(from, 24, list_z_x4);
                }
                //////////////////////////////////////////////////////
            }
        });

        // Fill Set Of Positions
        curPlayer->enableMoves.insert(std::make_pair(pm_zyari->z1, list_z_x1));
        curPlayer->enableMoves.insert(std::make_pair(2*pm_zyari->z1, list_z_x2));
        curPlayer->enableMoves.insert(std::make_pair(3*pm_zyari->z1, list_z_x3));
        curPlayer->enableMoves.insert(std::make_pair(4*pm_zyari->z1, list_z_x4));
    }
    else {
        std::list<std::tuple<int, int, int>> list_z1;
        std::list<std::tuple<int, int, int>> list_z2;
        std::list<std::tuple<int, int, int>> list_z1z2;

        // Run Through The Whole Row To Find Player' Figure
        int N = 0;
        std::for_each(curPlayer->row.begin(), curPlayer->row.end(), [&](auto& tup){
            if (std::get<2>(tup) == fig) {
                N++;
                int from = std::get<0>(tup);
                int to_z1 = std::get<0>(tup) + pm_zyari->z1;
                int to_z2 = std::get<0>(tup) + pm_zyari->z2;
                int to_z1z2 = std::get<0>(tup) + pm_zyari->z1 + pm_zyari->z2;

                bool isSumEnable = false;
                if (to_z1 < 24 && std::get<2>(curPlayer->row[to_z1]) != figOpp &&
                    isMoveValid(boardFromRow(from), boardFromRow(to_z1, true))) {
                    fillList(from, to_z1, list_z1);
                    isSumEnable = true;
                }
                if (to_z2 < 24 && std::get<2>(curPlayer->row[to_z2]) != figOpp &&
                    isMoveValid(boardFromRow(from), boardFromRow(to_z2, true))) {
                    fillList(from, to_z2, list_z2);
                    isSumEnable = true;
                }
                if (isSumEnable == true && to_z1z2 < 24 && std::get<2>(curPlayer->row[to_z1z2]) != figOpp &&
                    isMoveValid(boardFromRow(from), boardFromRow(to_z1z2, true))) {
                    fillList(from, to_z1z2, list_z1z2);
                }

                ///////// !!!!!!!!!!!!!! EXIT ////////////////////////
                if (to_z1 >= 24 && curPlayer->isLeaveBoard == true &&
                    isMoveValid(boardFromRow(from), (curPlayer == &players.first ? 260 : -1), true)) {
                    fillList(from, 24, list_z1);
                }
                if (to_z2 >= 24 && curPlayer->isLeaveBoard == true &&
                    isMoveValid(boardFromRow(from), (curPlayer == &players.first ? 260 : -1), true)) {
                    fillList(from, 24, list_z2);
                }
                if (to_z1z2 >= 24 && curPlayer->isLeaveBoard == true &&
                    isMoveValid(boardFromRow(from), (curPlayer == &players.first ? 260 : -1), true)) {
                    fillList(from, 24, list_z1z2);
                }
                //////////////////////////////////////////////////////
            }
        });

        // Fill Set Of Positions
        curPlayer->enableMoves.insert(std::make_pair(pm_zyari->z1, list_z1));
        curPlayer->enableMoves.insert(std::make_pair(pm_zyari->z2, list_z2));
        curPlayer->enableMoves.insert(std::make_pair(pm_zyari->z1 + pm_zyari->z2, list_z1z2));
    }

    // Helper Lambda (Accum List's Figs)
    auto accum = [](std::pair<const int, std::list<std::tuple<int, int, int>>>& pairKey) -> int {
        int _count = std::accumulate(pairKey.second.begin(),
                                     pairKey.second.end(), 0,
                                       [&](int &ac, auto& tup){ return ac + std::get<2>(tup); });
        return _count;
    };

    /////////////////////////// FINAL CORRECTING MOVES /////////////////////////////////////
    // Correcting Player's Move Info
    if (pm_zyari->isKosha()) {
        int n_x1 = accum(*(curPlayer->enableMoves.begin()));
        int n_x2 = accum(*++(curPlayer->enableMoves.begin()));
        int n_x3 = accum(*++++(curPlayer->enableMoves.begin()));
        int n_x4 = accum(*++++++(curPlayer->enableMoves.begin()));

        if (isCurMoveFirst == true) {
            if (n_x1 + n_x2 + n_x3 + n_x4 >= 4) curPlayer->moveInfo.first = pm_zyari->z1*4;
            else if (n_x1 + n_x2 + n_x3 + n_x4 == 3) curPlayer->moveInfo.first = pm_zyari->z1*3;
            else if (n_x1 + n_x2 + n_x3 + n_x4 == 2) curPlayer->moveInfo.first = pm_zyari->z1*2;
            else if (n_x1 + n_x2 + n_x3 + n_x4 == 1) curPlayer->moveInfo.first = pm_zyari->z1;
            else curPlayer->moveInfo.first = 0;
        }
    }
    else {
        if (curPlayer->isLeaveBoard == false) {
            // Enabled Moves For Each Zyara
            int r1 = curPlayer->enableMoves.begin()->second.size();
            int r2 = (++(curPlayer->enableMoves.begin()))->second.size();
            int r3 = (++++(curPlayer->enableMoves.begin()))->second.size();

            // From Poses Z1 & Z2
            int from1 = 0, from2 = 0;
            if (r1 != 0) from1 = std::get<0>(*(curPlayer->enableMoves.begin()->second.begin()));
            if (r2 != 0) from2 = std::get<0>(*((++curPlayer->enableMoves.begin())->second.begin()));

            // Bool-Helpers
            bool isNoWay = false, isOnlyZ1 = false, isOnlyZ2 = false, isBothZ1Z2 = false;

            // ------- NO MOVES -------
            if (r1 == 0 && r2 == 0 && r3 == 0) {
                isNoWay = true;
                // No Delete
            }
            // ------------------------


            // ------- ONLY Z1 -------
            else if (r1 >= 1 && r2 == 0 && r3 == 0) {
                isOnlyZ1 = true;
                // No Delete
            }
            else if (r1 == 1 && r2 == 1 && r3 == 0 && from1 == from2) {
                isOnlyZ1 = true;
                // Delete Z2
                curPlayer->enableMoves.erase((++curPlayer->enableMoves.begin())->first);
            }
            // -----------------------


            // -------  ONLY Z2 -------
            else if (r1 == 0 && r2 >= 1 && r3 == 0) {
                isOnlyZ2 = true;
                // No Delete
            }
            // ------------------------


            // ------- BOTH Z1 & Z2 -------
            else if (r1 == 0 && r2 == 0 && r3 >= 1) {
                isBothZ1Z2 = true;
                // No Delete
            }
            else if (r1 > 1 && r2 > 1 && r3 >= 1) {
                isBothZ1Z2 = true;
                // No Delete
            }
            else if (r1 == 1 && r2 > 1 && r3 >= 1) {
                isBothZ1Z2 = true;
                // No Delete
            }
            else if (r1 > 1 && r2 == 1 && r3 >= 1) {
                isBothZ1Z2 = true;
                // No Delete
            }
            else if (r1 == 0 && r2 >= 1 && r3 >= 1) {
                isBothZ1Z2 = true;
                // Delete Z2
                curPlayer->enableMoves.erase((++curPlayer->enableMoves.begin())->first);
            }
            else if (r1 >= 0 && r2 == 0 && r3 >= 1) {
                isBothZ1Z2 = true;
                // Delete Z1
                curPlayer->enableMoves.erase(curPlayer->enableMoves.begin()->first);
            }
            else if (r1 == 1 && r2 == 1 && r3 >= 1) {
                isBothZ1Z2 = true;
                if (from1 == from2) {
                    // Delete Z1 & Z2
                    curPlayer->enableMoves.erase(curPlayer->enableMoves.begin()->first);
                    curPlayer->enableMoves.erase((++curPlayer->enableMoves.begin())->first);
                }
            }
            else if (r1 > 1 && r2 > 1 && r3 == 0) {
                isBothZ1Z2 = true;
                // No Delete
            }
            else if (r1 == 1 && r2 == 1 && r3 == 0 && from1 != from2) {
                isBothZ1Z2 = true;
                // No Delete
            }
            else if (r1 == 1 && r2 > 1 && r3 == 0) {
                isBothZ1Z2 = true;
                auto iter = std::find_if((++curPlayer->enableMoves.begin())->second.begin(),
                                         (++curPlayer->enableMoves.begin())->second.end(),
                                         [&](std::tuple<int, int, int>& tup) {
                                             return std::get<0>(tup) == std::get<0>(*(curPlayer->enableMoves.begin()->second.begin()));
                                         });
                if (iter != (++curPlayer->enableMoves.begin())->second.end()) {
                    // Delete Pair Z2
                    (++curPlayer->enableMoves.begin())->second.erase(iter);
                }
            }
            else if (r1 > 1 && r2 == 1 && r3 == 0) {
                isBothZ1Z2 = true;
                auto iter = std::find_if(curPlayer->enableMoves.begin()->second.begin(),
                                         curPlayer->enableMoves.begin()->second.end(),
                                         [&](std::tuple<int, int, int>& tup) {
                                             return std::get<0>(tup) == std::get<0>(*((++curPlayer->enableMoves.begin())->second.begin()));
                                         });
                if (iter != curPlayer->enableMoves.begin()->second.end()) {
                    // Delete Pair Z1
                    curPlayer->enableMoves.begin()->second.erase(iter);
                }
            }
            // ---------------------------

            // Final Check For Whole Moving
            if (isCurMoveFirst == true) {
                if (isNoWay) {
                    curPlayer->moveInfo.first = 0;
                    //curPlayer->enableMoves.clear();
                }
                else {
                    if (isOnlyZ1) {
                        curPlayer->moveInfo.first = pm_zyari->z1;
                    }
                    else if (isOnlyZ2) {
                        curPlayer->moveInfo.first = pm_zyari->z2;
                    }
                    else if (isBothZ1Z2) {
                        curPlayer->moveInfo.first = pm_zyari->z1 + pm_zyari->z2;
                    }
                }
            }
        }
        else {
            if (isCurMoveFirst == true) {
                int n_z1 = accum(*(curPlayer->enableMoves.begin()));
                int n_z2 = accum(*++(curPlayer->enableMoves.begin()));
                int n_z1z2 = accum(*++++(curPlayer->enableMoves.begin()));

                if (n_z1z2 >= 1 || (n_z1 >= 1 && n_z2 >= 1)) curPlayer->moveInfo.first = pm_zyari->z1 + pm_zyari->z2;
                else if (n_z1z2 == 0 && n_z1 >= 1 && n_z2 == 0) curPlayer->moveInfo.first = pm_zyari->z1;
                else if (n_z1z2 == 0 && n_z1 == 0 && n_z2 >= 1) curPlayer->moveInfo.first = pm_zyari->z2;
                else curPlayer->moveInfo.first = 0;
            }
        }
    }

    // Prevent Empty Move
    if (curPlayer->moveInfo.first != 0 && curPlayer->isLeaveBoard == true) {
        auto iter = std::find_if(curPlayer->enableMoves.begin(), curPlayer->enableMoves.end(), [&](auto& pr){
            return (!(pr.second.empty()));
        });
        if (iter == curPlayer->enableMoves.end()) {
            auto pos = std::find_if(curPlayer->row.begin()+18, curPlayer->row.end(), [&](auto& tup){
                return (std::get<2>(tup) == (curPlayer == &players.first ? 'o' : 'x'));
            });
            curPlayer->enableMoves.begin()->second.push_back({std::get<0>(*pos),24,pm_zyari->z1});
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////
    // Test Output
    showEnableMoves();
}

// Test Output
void Connector::showEnableMoves() {
    qDebug() << " ------------------------------------------------------------------------- REQUIRED MOVES : " <<
        curPlayer->moveInfo.first << "  |  DONE : " << curPlayer->moveInfo.second << Qt::endl;
    for (auto &kvlist : curPlayer->enableMoves) {
        if (kvlist.second.empty()){
            qDebug() << " ------------------------------------------------------------------------------- [ " <<
                kvlist.first << "] : NO MOVES FOR ZYARA" << Qt::endl;
        }
        else {
            qDebug() << " ------------------------------------------------------------------------------- [ " <<
                kvlist.first << " ] -> " << kvlist.second.size() << " ITEMS : " << Qt::endl;
            for (auto &lst : kvlist.second) {
                qDebug() << " ------------------------------------------------------------------------------- FROM " <<
                    std::get<0>(lst) << " ---> TO " << std::get<1>(lst) <<
                    " ( " << std::get<2>(lst) << " ITEMS )" << Qt::endl;
            }
        }
    }
}

// --------------------------------- AI ---------------------------------- //
std::pair<int, int> Connector::moveAI() {
    int from_board = -999, to_board = -999;
    auto iter = std::find_if(players.second.enableMoves.begin(),
                             players.second.enableMoves.end(),
                             [](auto& prLst){
        return !(prLst.second.empty());
    });
    if (iter != players.second.enableMoves.end()) {
        qDebug() << "***************************** enableMoves are NOT EMPTY. SO HERE THEY ARE : ";
        showTest();
        showEnableMoves();

        // Required Positions
        int from_row = -999, to_row = -999;

        // --------------- AI LOGIC (ORIENTED TO FILL CELLS / PROTECT / ATTACK) ------------ //

        // Helper Lambda For Random Move Choice
        auto rndMove = [&](){
            while (from_row == -999 && to_row == -999) {
                int rnd_key = pm_zyari->makeRnd(1, players.second.enableMoves.size());
                auto iter_map = players.second.enableMoves.begin();
                for (int i=1; i<rnd_key; ++i) {
                    ++iter_map;
                }
                if (!(iter_map->second.empty())) {
                    auto iter_list = iter_map->second.begin();
                    int rnd_tup = pm_zyari->makeRnd(1, iter_map->second.size());
                    for (int k=1; k<rnd_tup; ++k) {
                        ++iter_list;
                    }
                    from_row = std::get<0>(*iter_list);
                    to_row = std::get<1>(*iter_list);
                }
            }
        };

        // Generating Checking Helper Lambda
        const bool FROM = true;
        const bool TO = false;
        auto lamb = [&](std::tuple<int, int, int>& tup, int beg, int end,
                        std::function<bool(int, int)> pred, int compVal, bool isFrom) -> bool {
            return (isFrom == true) ?
                       ((std::get<0>(tup) >= beg) && (std::get<0>(tup) <= end) &&
                        pred(std::get<3>(players.second.row[std::get<0>(tup)]), compVal)) :
                       ((std::get<1>(tup) >= beg) && (std::get<1>(tup) <= end) &&
                        pred(std::get<3>(players.second.row[std::get<1>(tup)]), compVal));
        };

        // 0. HEAD && N>0
        auto head_ = [&](std::tuple<int, int, int>& tup) -> bool {
            return (std::get<0>(tup) == 0);
        };

        // 1.1. HOME && N=0
        auto home_eq_0 = [&](std::tuple<int, int, int>& tup, bool isFrom) -> bool {
            return lamb(tup, 1, 6, std::equal_to<int>(), 0, isFrom);
        };
        // 1.2. HOME && N=1
        auto home_eq_1 = [&](std::tuple<int, int, int>& tup, bool isFrom) -> bool {
            return lamb(tup, 1, 6, std::equal_to<int>(), 1, isFrom);
        };
        // 1.3. HOME && N>1
        auto home_gr_1 = [&](std::tuple<int, int, int>& tup, bool isFrom) -> bool {
            return lamb(tup, 1, 6, std::greater<int>(), 1, isFrom);
        };

        // 2.1. ATTACK && N=0
        auto attack_eq_0 = [&](std::tuple<int, int, int>& tup, bool isFrom) -> bool {
            return lamb(tup, 13, 18, std::equal_to<int>(), 0, isFrom);
        };
        // 2.2. ATTACK && N=1
        auto attack_eq_1 = [&](std::tuple<int, int, int>& tup, bool isFrom) -> bool {
            return lamb(tup, 13, 18, std::equal_to<int>(), 1, isFrom);
        };
        // 2.3. ATTACK && N>1
        auto attack_gr_1 = [&](std::tuple<int, int, int>& tup, bool isFrom) -> bool {
            return lamb(tup, 13, 18, std::greater<int>(), 1, isFrom);
        };

        // 3.1. SIMPLE && N=0
        auto simple_eq_0 = [&](std::tuple<int, int, int>& tup, bool isFrom) -> bool {
            return lamb(tup, 7, 12, std::equal_to<int>(), 0, isFrom) ||
                   lamb(tup, 19, 23, std::equal_to<int>(), 0, isFrom);
        };
        // 3.2. SIMPLE && N=1
        auto simple_eq_1 = [&](std::tuple<int, int, int>& tup, bool isFrom) -> bool {
            return lamb(tup, 7, 12, std::equal_to<int>(), 1, isFrom) ||
                   lamb(tup, 19, 23, std::equal_to<int>(), 1, isFrom);
        };
        // 3.3. SIMPLE && N>1
        auto simple_gr_1 = [&](std::tuple<int, int, int>& tup, bool isFrom) -> bool {
            return lamb(tup, 7, 12, std::greater<int>(), 1, isFrom) ||
                   lamb(tup, 19, 23, std::greater<int>(), 1, isFrom);
        };

        // Exit Yes
        if (players.second.isLeaveBoard == true) {
            for (auto& pr : players.second.enableMoves) {
                for (auto& tup : pr.second) {
                    if (std::get<1>(tup) == 24) {
                        from_row = std::get<0>(tup);
                        to_row = std::get<1>(tup);
                        break;
                    }
                }
            }
            if (from_row == -999) {
                rndMove();
            }
        }
        // Exit No
        else {
            // Checking Part
            auto goodPair = [&]() {
                std::pair<std::pair<int, int>, int> cells = {{-999, -999}, 1000};
                for (auto& pr : players.second.enableMoves) {
                    for (auto& tup : pr.second) {
                        int depth = 0;
                        // Close & No Opening
                        if (head_(tup) && home_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (simple_gr_1(tup, FROM) && attack_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_gr_1(tup, FROM) && attack_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (attack_gr_1(tup, FROM) && attack_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (head_(tup) && attack_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (simple_eq_1(tup, FROM) && attack_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (attack_eq_1(tup, FROM) && attack_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_eq_1(tup, FROM) && attack_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (simple_gr_1(tup, FROM) && simple_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_gr_1(tup, FROM) && home_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (head_(tup) && simple_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_gr_1(tup, FROM) && simple_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (attack_gr_1(tup, FROM) && simple_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        // Close & Valid Opening
                        else if (home_eq_1(tup, FROM) && home_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (simple_eq_1(tup, FROM) && simple_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        // Replacement & No Opening
                        else if (head_(tup) && attack_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (head_(tup) && attack_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (head_(tup) && home_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (head_(tup) && home_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (head_(tup) && simple_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (head_(tup) && attack_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_gr_1(tup, FROM) && attack_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_gr_1(tup, FROM) && attack_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_gr_1(tup, FROM) && simple_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_gr_1(tup, FROM) && simple_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_gr_1(tup, FROM) && home_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_gr_1(tup, FROM) && home_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (simple_gr_1(tup, FROM) && attack_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (simple_gr_1(tup, FROM) && attack_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (attack_gr_1(tup, FROM) && attack_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (attack_gr_1(tup, FROM) && attack_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (simple_gr_1(tup, FROM) && simple_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (simple_gr_1(tup, FROM) && simple_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (attack_gr_1(tup, FROM) && simple_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (attack_gr_1(tup, FROM) && simple_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        // Opening & Closing
                        else if (attack_eq_1(tup, FROM) && simple_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_eq_1(tup, FROM) && simple_eq_0(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        // Opening & No Closing
                        else if (simple_eq_1(tup, FROM) && attack_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (simple_eq_1(tup, FROM) && simple_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (simple_eq_1(tup, FROM) && attack_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (simple_eq_1(tup, FROM) && simple_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        // Opening Attack
                        else if (attack_eq_1(tup, FROM) && attack_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (attack_eq_1(tup, FROM) && simple_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (attack_eq_1(tup, FROM) && attack_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (attack_eq_1(tup, FROM) && simple_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        // Opening Home
                        else if (home_eq_1(tup, FROM) && home_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_eq_1(tup, FROM) && home_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_eq_1(tup, FROM) && attack_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_eq_1(tup, FROM) && attack_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_eq_1(tup, FROM) && simple_eq_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else if (home_eq_1(tup, FROM) && simple_gr_1(tup, TO)) {
                            ++depth; if (depth < cells.second) {cells = {{std::get<0>(tup), std::get<1>(tup)}, depth}; } break;
                        }
                        else {
                            rndMove();
                        }
                    }
                }
                return cells;
            };
            auto pr = goodPair();
            from_row = pr.first.first;
            to_row = pr.first.second;
            qDebug() << " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ADVANCED AI FOUND THE BEST: " <<
                "( " << from_row << " --> " << to_row << " )";
        }
        // ------------------------------------------------------------------------------------ //


        if (from_row != -999 && to_row != -999) {
            qDebug() << "***************************** SO, [AI] HAS FOUND THE MOVES";
            from_board = boardFromRow(from_row);
            to_board = boardFromRow(to_row, true);
            qDebug() << "***************************** SO, [AI] DECIDED TO GO (ROW) FROM [ " << from_row << " ] TO [ " << to_row << " ] !!!";
            qDebug() << "***************************** SO, [AI] DECIDED TO GO (BOARD) FROM [ " << from_board << " ] TO [ " << to_board << " ] !!!";

            // Reset First Move
            if (curPlayer->isFirstMove) {
                curPlayer->isFirstMove = false;
            }
            // Reset Move From Head
            if (from_row == 0) {
                curPlayer->countFromHead--;
            }
            // Update MoveInfo
            players.second.moveInfo.second += (to_row - from_row + delta);
            players.second.moveInfo.first -= (to_row - from_row + delta);

            isCurMoveFirst = false;
            updateBoard(std::pair(from_board, to_board), true);
        }
        else {
            qDebug() << "***************************** SO, [AI] CAN'T MOVE AT ALL";
        }
    }
    return std::pair<int, int>(from_board, to_board);
}

// Show Intro
void Connector::startIntro() {
    QObject* p_animIntro = pm_root->findChild<QObject*>("animIntro");
    p_animIntro->setProperty("running", true);
}

// Switch Sound
void Connector::switchMute() {
    QObject* p_switchMute = pm_root->findChild<QObject*>("switchMute");
    // Turn On Sound
    if (p_switchMute->property("checked").toString() == "true") {
        p_switchMute->setProperty("text", "Sound On");
        qDebug() << "Sound is On";
    }
    // Turn Off Sound
    else {
        p_switchMute->setProperty("text", "Sound Off");
        qDebug() << "Sound is Off";
    }
}

// Open Context Menu
void Connector::openMenuContext() {
    QObject* p_boardEffect = pm_root->findChild<QObject*>("boardEffect");
    p_boardEffect->setProperty("visible", true);
    QObject* p_menuContext = pm_root->findChild<QObject*>("menuContext");
    p_menuContext->setProperty("visible", true);
    QObject* p_boardImage = pm_root->findChild<QObject*>("boardImage");
    p_boardImage->setProperty("enabled", false);
}

// Close Context Menu
void Connector::closeMenuContext() {
    QObject* p_boardEffect = pm_root->findChild<QObject*>("boardEffect");
    p_boardEffect->setProperty("visible", false);
    QObject* p_menuContext = pm_root->findChild<QObject*>("menuContext");
    p_menuContext->setProperty("visible", false);
    QObject* p_boardImage = pm_root->findChild<QObject*>("boardImage");
    p_boardImage->setProperty("enabled", true);
}

// Open Statistics
void Connector::openStatistics() {
    QObject* p_statistics = pm_root->findChild<QObject*>("statistics");
    p_statistics->setProperty("visible", true);
}

// Close Statistics
void Connector::closeStatistics() {
    QObject* p_statistics = pm_root->findChild<QObject*>("statistics");
    p_statistics->setProperty("visible", false);
}

// Go To Main Menu
void Connector::goToMainMenu() {
    closeMenuContext();
    QObject* p_mainMenu = pm_root->findChild<QObject*>("mainMenu");
    p_mainMenu->setProperty("visible", true);
}

// New Game AI
void Connector::newGameAI() {
    isTest = false;

    pm_root->deleteLater();
    pm_component->deleteLater();

    pm_component = new QQmlComponent(pm_engine, *new QUrl("qrc:/Style/Style.qml"));
    pm_root = pm_component->create();

    activateEvents(pm_root);
    initBoard();
    resetStatistics();

    QObject* p_test = pm_root->findChild<QObject*>("selectPlayer");
    p_test->setProperty("visible", true);
}

// New Game Player
void Connector::newGamePlayer() {
    isTest = false;

    pm_root->deleteLater();
    pm_component->deleteLater();

    pm_component = new QQmlComponent(pm_engine, *new QUrl("qrc:/Style/Style.qml"));
    pm_root = pm_component->create();

    activateEvents(pm_root);
    initBoard();
    resetStatistics();

    QObject* p_test = pm_root->findChild<QObject*>("selectPlayer");
    p_test->setProperty("visible", true);
}

//////////////////// TEST-CASE EXIT ////////////////////
//void Connector::startGameTestExit() {
//    isTest = true;

//    pm_root->deleteLater();
//    pm_component->deleteLater();

//    pm_component = new QQmlComponent(pm_engine, *new QUrl("qrc:/Style/Style.qml"));
//    pm_root = pm_component->create();

//    activateEvents(pm_root);
//    initBoard();
//    resetStatistics();

//    int white_items[15] = {235, 248, 249, 228, 241, 254, 255, 230, 243, 256, 244, 257, 245, 258, 259};
//    int black_items[15] = {0, 1, 2, 3, 4, 5, 9, 10, 23, 16, 17, 18, 29, 31, 44};
//    for (int i=0; i<15; ++i) {
//        board[white_items[i]] = 'o';
//        board[black_items[i]] = 'x';
//        board[65+13*i] = '-';
//        board[12+13*i] = '-';
//    }

//    updateRows();

//    QObject* p_test = pm_root->findChild<QObject*>("selectPlayer");
//    p_test->setProperty("visible", true);
//}
///////////////////////////////////////

// Load Game
void Connector::playGame() {
    startGame();
}

// Exit Game
void Connector::exitGame() {
    qDebug() << "exit - 2";
    qApp->exit();
}

/* -------------------------------  GAME LOGIC  -------------------------------------------------- */

// Generate Zyara
void Connector::genRnd() {
    auto curZyari = pm_zyari->drop();
    updateStatistics(curZyari);
    //qDebug() << "RAND: " << curZyari.first << " - " << curZyari.second;

    QObject* p_z1 = pm_root->findChild<QObject*>((QString("cur_1")+curPlayer->zyaraRowIdName).toStdString().c_str());
    QObject* p_z2 = pm_root->findChild<QObject*>((QString("cur_2")+curPlayer->zyaraRowIdName).toStdString().c_str());

    std::string path;
    path += "qrc:/res/res/z";
    path += std::to_string(curZyari.first);
    path += ".png";
    p_z1->setProperty("source", path.c_str());
    path.clear();
    path = "qrc:/res/res/z";
    path += std::to_string(curZyari.second);
    path += ".png";
    p_z2->setProperty("source", path.c_str());
}

bool Connector::isCurrentPlayer1() {
    return curPlayer == &players.first;
}

void Connector::switchPlayer(){
    qDebug() << Qt::endl << "-----------------------------------  SWITCHED  -------------------------" << Qt::endl;
    // Set First Move For Current Zyara
    isCurMoveFirst = true;
    // Reset Prev Player's Move Info
    curPlayer->moveInfo.first = 0;
    curPlayer->moveInfo.second = 0;

    // Activate Current Player
    curPlayer = &(curPlayer == &players.first ? players.second : players.first);

    // Generate Zyara For Current Player
    genRnd();
    // Reset First Head Move (x2 By The Most First Move)
    curPlayer->countFromHead = ((curPlayer->isFirstMove == true && pm_zyari->isKosha() == true) ? 2 : 1);

    // Init Required Moves
    curPlayer->moveInfo.first = (pm_zyari->isKosha() ? (4*pm_zyari->z1) : (pm_zyari->z1+pm_zyari->z2));
    // Reset Done Moves
    curPlayer->moveInfo.second = 0;

    // Correcting Enabled/Required Moves
    updateEnableMoves();

    // Hide Avatar Animation Block
    std::string curPl = (curPlayer->zyaraRowIdName == "zyara_p2") ? "avarat1Animation" : "avarat2Animation";
    QObject* p_avatarAnim = pm_root->findChild<QObject*>(curPl.c_str());
    p_avatarAnim->setProperty("running", false);

    // Unhide Avatar Animation Block
    curPl = (curPlayer->zyaraRowIdName == "zyara_p1") ? "avarat1Animation" : "avarat2Animation";
    p_avatarAnim = pm_root->findChild<QObject*>(curPl.c_str());
    p_avatarAnim->setProperty("running", true);

    /// PLAYER VS PLAYER | PLAYER VS AI
    // ...
    // ... Waiting For Player's Move ...
    // ...

    // Is Needed To Skip
    auto iter = std::find_if(curPlayer->enableMoves.begin(), curPlayer->enableMoves.end(), [](auto& prLst){
        return !(prLst.second.empty());
    });
    if (iter == curPlayer->enableMoves.end()) {
        // SKIP THE MOVE
        qDebug() << "SSSSSSSSSSSKKKKKKKKKKKKKKKKKKKIIIIIIIIIIIIIIIIIIIIIPPPPPPPPPPPPPPPPPPPPPPPPP" << Qt::endl;
        //delay(1000);
        switchPlayer();
    }
}

// Init/Reset Statistics
void Connector::resetStatistics() {
    stat.clear();
    stat.insert(std::pair(std::pair(1,1), 0));
    stat.insert(std::pair(std::pair(1,2), 0));
    stat.insert(std::pair(std::pair(1,3), 0));
    stat.insert(std::pair(std::pair(1,4), 0));
    stat.insert(std::pair(std::pair(1,5), 0));
    stat.insert(std::pair(std::pair(1,6), 0));
    stat.insert(std::pair(std::pair(2,2), 0));
    stat.insert(std::pair(std::pair(2,3), 0));
    stat.insert(std::pair(std::pair(2,4), 0));
    stat.insert(std::pair(std::pair(2,5), 0));
    stat.insert(std::pair(std::pair(2,6), 0));
    stat.insert(std::pair(std::pair(3,3), 0));
    stat.insert(std::pair(std::pair(3,4), 0));
    stat.insert(std::pair(std::pair(3,5), 0));
    stat.insert(std::pair(std::pair(3,6), 0));
    stat.insert(std::pair(std::pair(4,4), 0));
    stat.insert(std::pair(std::pair(4,5), 0));
    stat.insert(std::pair(std::pair(4,6), 0));
    stat.insert(std::pair(std::pair(5,5), 0));
    stat.insert(std::pair(std::pair(5,6), 0));
    stat.insert(std::pair(std::pair(6,6), 0));
}

// Update Staticstics
void Connector::updateStatistics(std::pair<int, int> genZyara) {
    // Update Current Zyara Stat
    std::swap(genZyara.first, genZyara.second);
    auto iter = stat.find(genZyara);
    ++(iter->second);

    // Current Sum Of Drops
    int countDrops = std::accumulate(stat.begin(), stat.end(), 0, [&](int &ac, auto& pr){
        return ac + pr.second;
    });

    // Temp UI Stat's Elements
    QString t_name = "stat";
    QObject* p_elem;
    double procTail;
    QString procTailText = "";
    QString temp = "";
    int endPos = 0;
    // Update UI-Stat Info
    std::for_each(stat.begin(), stat.end(), [&](auto& pr){
        t_name += QString::number(pr.first.first);
        t_name += QString::number(pr.first.second);
        p_elem = pm_root->findChild<QObject*>(t_name.toStdString().c_str());
        procTail = (pr.second*100.)/countDrops;
        temp = QString::number(procTail);
        endPos = (temp.size() > 5) ? 5 : temp.size();
        procTailText.resize(endPos);
        for (int i=0; i < endPos; ++i) {
            procTailText[i] = temp[i];
        }
        procTailText.prepend(" -> ");
        p_elem->setProperty("text", procTailText);
        t_name = "stat";
        procTailText = "";
        temp = "";
    });

}

// Start Game Loop
void Connector::startGame() {
    // Reset Old Data
    players.first.isFirstMove = true;
    players.second.isFirstMove = true;
    players.first.isLeaveBoard = false;
    players.second.isLeaveBoard = false;
    players.first.isWinner = false;
    players.second.isWinner = false;
    isCurMoveFirst = true;

    // Who's First Move
    int p1, p2;
    do {
        auto res = pm_zyari->drop(false);
        p1 = res.first;
        p2 = res.second;
    } while (p1 == p2);
    //qDebug() << p1 << "-" << p2;
    curPlayer = &((p2 > p1) ? players.first : players.second);

    // Generate Zyara For Current Player
    genRnd();
    // Reset First Head Move (x2 By The Most First Move)
    curPlayer->countFromHead = ((curPlayer->isFirstMove == true && pm_zyari->isKosha() == true) ? 2 : 1);

    // Init Required Moves
    curPlayer->moveInfo.first = (pm_zyari->isKosha() ? (4*pm_zyari->z1) : (pm_zyari->z1+pm_zyari->z2));
    // Reset Done Moves
    curPlayer->moveInfo.second = 0;

    // Correcting Enabled/Required Moves
    updateEnableMoves();

    // Unhide Avatar Animation Block
    std::string curPl = (curPlayer->zyaraRowIdName == "zyara_p1") ? "avarat1Animation" : "avarat2Animation";
    QObject* p_avatarAnim = pm_root->findChild<QObject*>(curPl.c_str());
    p_avatarAnim->setProperty("running", true);
}
