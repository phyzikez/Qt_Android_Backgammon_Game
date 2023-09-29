#include "zyari.h"

// CTOR
Zyari::Zyari() {
    pm_dre.seed(pm_rd());
    pm_zyari.first = drop().first;
    pm_zyari.second = drop().second;
}

// Check If Kosha
bool Zyari::isKosha() {
    return (pm_zyari.first == pm_zyari.second);
}

// Generate Rand Num
int Zyari::makeRnd(int from, int to) {
    return pm_uid(pm_dre, std::uniform_int_distribution<>::param_type(from, to));
}

// Drop Zyari
const std::pair<int, int>& Zyari::drop(bool isFirstGreater){
    pm_zyari = { makeRnd(1, 6), makeRnd(1, 6) };
    if (isFirstGreater && pm_zyari.second > pm_zyari.first) {
        std::swap(pm_zyari.first, pm_zyari.second);
    }
    return pm_zyari;
}
