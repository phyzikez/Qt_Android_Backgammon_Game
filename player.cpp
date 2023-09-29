#include "player.h"

Player::Player(QString zyaraRow, QString column, std::array<std::tuple<int, int, char, int>, 24>& ConRow) :
    zyaraRowIdName { zyaraRow },
    columnFigures { column },
    row { ConRow },
    isWinner { false },
    isLeaveBoard { false },
    isFirstMove { true },
    countFromHead { 1 }
{

}
