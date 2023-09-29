#include "CellInformator.h"
#include "delay.cpp"

// CTOR
CellInformator::CellInformator(QObject* pobj) : QObject(pobj) {}

// Update Board After Item's Move
void CellInformator::updateCellInfo(const int& oldPos, const int& newPos) {
    m_changedCell.first = oldPos;
    m_changedCell.second = newPos;
    p_connector->updateBoard(m_changedCell);
}

bool CellInformator::isTargetValid(const int& oldPos, const int& newPos) {
    return p_connector->isMoveValid(oldPos, newPos, false);
}

double CellInformator::updateX() {
    return 0;
}

double CellInformator::updateY() {
    return 0;
}

bool CellInformator::isCurrentFigureName(QString name) {
    return ((p_connector->isCurrentPlayer1() == true && name[0] == 'b') ||
     (p_connector->isCurrentPlayer1() == false && name[0] == 'w')) ? false : true;
}

QString CellInformator::highlightCell(bool isTarget) {
    return p_connector->getValidCells(isTarget);
}

bool CellInformator::isTestMode() {
    return p_connector->isTest;
}

void CellInformator::deactivateFirstCurMove() {
    p_connector->isCurMoveFirst = false;
}

void CellInformator::activateGameAI(bool isAI) {
    p_connector->isGameAI = isAI;
}

void CellInformator::moveAI() {
    std::pair<int, int> res = p_connector->moveAI();
    from_AI = res.first;
    to_AI = res.second;
}

bool CellInformator::isTotalMoveAI() {
    delay(1000);
    return (p_connector->players.second.moveInfo.first == 0 ? true : false);
}

void CellInformator::activateSwitch() {
    p_connector->switchPlayer();
}

void CellInformator::activateUpdateEnableMoves() {
    p_connector->updateEnableMoves();
}


bool CellInformator::isEnableMovesAIExist() {
    auto iter = std::find_if(p_connector->players.second.enableMoves.begin(),
                             p_connector->players.second.enableMoves.end(),
                             [](auto& prLst){
                                 return !(prLst.second.empty());
                             });
    return (iter == p_connector->players.second.enableMoves.end() ? false : true);
}

void CellInformator::activateShowTest() {
    p_connector->showTest();
}
