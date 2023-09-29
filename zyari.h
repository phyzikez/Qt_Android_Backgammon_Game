#pragma once
#include <QObject>
#include <random>

// (In Indigenous Game Dice Cube Called "Zyarya")
class Zyari : public QObject {
private:
    std::pair<int, int> pm_zyari;
    // Random Generating Engine
    std::default_random_engine pm_dre;
    // Random Generating Device
    std::random_device pm_rd;
    // Adjucent Randomization
    std::uniform_int_distribution<> pm_uid;
public:
    // CTOR (Initialize Randomizer)
    Zyari();
    // "Drop" zyari (Get Random Values For Player Next Move)
    const std::pair<int, int>& drop(bool isFirstGreater = true);
    // Check If The Both Zyarya Values Are Equal --> "Kosha" State
    bool isKosha();
    // Getters For Zyara
    const int& z1 = pm_zyari.first;
    const int& z2 = pm_zyari.second;
    // Makes Rand Value
    int makeRnd(int from, int to);
};
