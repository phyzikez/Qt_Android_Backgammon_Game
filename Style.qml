import QtQuick
import QtQuick.Window
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Qt.labs.platform
import Qt3D.Core
import Qt3D.Render
import Qt3D.Input
import Qt3D.Extras
import QtQuick.Scene3D
import QtQuick.Particles
import QtMultimedia
import CellInfo

// Main Window
Window {
    id: container
    objectName: "container"
    width: 1200
    height: 1841
    visible: true
    property int interval : 100
    property bool isFixedInitPos : false
    property int time : 0
    Rectangle {
        id: containerRect
        width: parent.width
        height: parent.height
        color: "black"
        // Game Timer
        Timer {
            id: timer
            objectName: "timer"
            interval: 1000
            running: false
            repeat: true
            onTriggered: {
                ++time
                timeText.text = (time < 600 ? "0" : "") + Math.floor(time/60) + ":" + (time%60 < 10 ? "0" : "") + time%60
            }
        }

        // Connector Provider
        CellInformator {
            id: informator
        }

        // Sound Button Press
        SoundEffect {
            id: soundButton
            source: "qrc:/res/res/wav/click.wav"
        }
        // Sound Switcher Checked
        SoundEffect {
            id: soundSwitch
            source: "qrc:/res/res/wav/switch.wav"
        }
        // Sound Fire
        SoundEffect {
            id: soundFire
            source: "qrc:/res/res/wav/fire.wav"
        }
        // Sound Intro 1
        SoundEffect {
            id: soundIntro1
            source: "qrc:/res/res/wav/intro1.wav"
        }
        // Sound Intro 2
        SoundEffect {
            id: soundIntro2
            source: "qrc:/res/res/wav/intro2.wav"
        }
        // Sound Intro 3
        SoundEffect {
            id: soundIntro3
            source: "qrc:/res/res/wav/intro3.wav"
        }
        // Sound Intro 4
        SoundEffect {
            id: soundIntro4
            source: "qrc:/res/res/wav/intro4.wav"
        }
        // Sound Crack
        SoundEffect {
            id: soundCrack
            source: "qrc:/res/res/wav/crack.wav"
        }
        // Sound Glass
        SoundEffect {
            id: soundGlass
            source: "qrc:/res/res/wav/glass.wav"
        }
        // Sound Exit Cell Oprn
        SoundEffect {
            id: soundPortal
            source: "qrc:/res/res/wav/portal.wav"
        }
        // Sound Pick Game Character
        SoundEffect {
            id: soundPickPers
            source: "qrc:/res/res/wav/success.wav"
        }
        // Sound Winner
        SoundEffect {
            id: soundWinner
            source: "qrc:/res/res/wav/winner.wav"
        }
        // Sound Start Game
        SoundEffect {
            id: soundGame
            source: "qrc:/res/res/wav/game.wav"
        }
        // ZYARA SOUNDS //////////////////
        SoundEffect {
            id: sound12
            source: "qrc:/res/res/wav/12.wav"
        }
        SoundEffect {
            id: sound13
            source: "qrc:/res/res/wav/13.wav"
        }
        SoundEffect {
            id: sound14
            source: "qrc:/res/res/wav/14.wav"
        }
        SoundEffect {
            id: sound15
            source: "qrc:/res/res/wav/15.wav"
        }
        SoundEffect {
            id: sound16
            source: "qrc:/res/res/wav/16.wav"
        }
        SoundEffect {
            id: sound23
            source: "qrc:/res/res/wav/23.wav"
        }
        SoundEffect {
            id: sound24
            source: "qrc:/res/res/wav/24.wav"
        }
        SoundEffect {
            id: sound25
            source: "qrc:/res/res/wav/25.wav"
        }
        SoundEffect {
            id: sound26
            source: "qrc:/res/res/wav/26.wav"
        }
        SoundEffect {
            id: sound34
            source: "qrc:/res/res/wav/34.wav"
        }
        SoundEffect {
            id: sound35
            source: "qrc:/res/res/wav/35.wav"
        }
        SoundEffect {
            id: sound36
            source: "qrc:/res/res/wav/36.wav"
        }
        SoundEffect {
            id: sound45
            source: "qrc:/res/res/wav/45.wav"
        }
        SoundEffect {
            id: sound46
            source: "qrc:/res/res/wav/46.wav"
        }
        SoundEffect {
            id: sound56
            source: "qrc:/res/res/wav/56.wav"
        }
        //////////////////////////////////
        // Sound Zyara Drop
        SoundEffect {
            id: soundDrop
            source: "qrc:/res/res/wav/drop.wav"
        }
        // Sound Figure Move
        SoundEffect {
            id: soundMove
            source: "qrc:/res/res/wav/move.wav"
        }

        // Background Board Pic
        Image {
            id: boardImage
            objectName: "boardImage"
            source: "qrc:/res/res/board.png"
            width: parent.width
            height: parent.height
            visible: false
            // TOP MENU
            Row {
                id: rowMenu
                width: parent.width
                // 0.08746 -> Correcting Koef Of Menu Tab Height Scaling
                height: parent.height*0.08746

                // Player's 2 Pic
                Image {
                    id: player2lavrapic
                    width: parent.height
                    height: parent.height
                    source: "qrc:/res/res/lavr.png"
                    ParallelAnimation {
                        id: avarat2Animation
                        objectName: "avarat2Animation"
                        running: false
                        loops: Animation.Infinite
                        NumberAnimation {
                            target: player2pic
                            property: "scale"
                            from: 1.1
                            to: 0.9
                            duration: 2300
                            easing.type: Easing.InOutQuad
                        }
                        onRunningChanged: { // LEFT P2
                            if (avarat2Animation.running === true) {
                                // Hide All Hints
                                for (var i=0; i<260; i++) {
                                    highlightRepeaterTarget.itemAt(i).opacity = 0.0;
                                }

                                // Hide Zyara Block
                                zyara_p1.visible = false;

                                // Start Zyara Animation
                                soundDrop.play();
                                rowZyaraDropAnimation.opacity = 1.0;
                                zyara1DropAnimation.running = true;
                                zyara2DropAnimation.running = true;
                            }
                        }
                    }
                    Image {
                        id: player2pic
                        width: parent.height
                        height: parent.height
                        source: "qrc:/res/res/pers3.png"
                        scale: 0.95
                        mirror: true
                    }
                }

                // Player's Left Info (Player 2)
                Column {
                    width: (parent.width - 2*parent.height)/3
                    height: parent.height

                    // Player's 2 Name
                    Text {
                        id: player2Name
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignLeft
                        width: parent.width
                        height: parent.height/2
                        topPadding: 7
                        leftPadding: 5
                        font.capitalization: "AllUppercase"
                        font.pixelSize: parent.height/4
                        color: "white"
                        text: "-"
                    }

                    // Current Zyara
                    Row {
                        id: zyara_p2
                        objectName: "zyara_p2"
                        width: parent.width
                        height: parent.height/2
                        anchors.left: parent.left
                        spacing: 2
                        visible: false

                        // Current Zyara 2 Pic
                        Image {
                            id: cur_1zyara_p2
                            objectName: "cur_1zyara_p2"
                            width: parent.height
                            height: parent.height
                            source: "qrc:/res/res/z1.png"
                        }

                        // Current Zyara 2 Pic
                        Image {
                            id: cur_2zyara_p2
                            objectName: "cur_2zyara_p2"
                            width: parent.height
                            height: parent.height
                            source: "qrc:/res/res/z1.png"
                        }

                        function makeMoveUI() {
                            var _from = informator.get_from()
                            var _to = informator.get_to()
                            if (_from >= 0 && _from < 260) {
                                if (_to !== -1) {
                                    console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get FROM: " + _from + " -> get TO: " + _to)
                                    // Move From Head
                                    if (_from >= 65 && _from <= 247 && _from%13 === 0) {
                                        console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> MOVING FROM HEAD");
                                        // Calc Head Pos
                                        var corrected_from = (_from - 65)/13;
                                        console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get CORRECTED FROM: " + corrected_from);
                                        blackRepeater.itemAt(corrected_from).parent = gridRepeater.itemAt(_to)
                                        blackRepeater.itemAt(corrected_from).anchors.centerIn = gridRepeater.itemAt(_to)
                                        blackRepeater.itemAt(corrected_from).cid = _to
                                        blackRepeater.itemAt(corrected_from).name = gridRepeater.itemAt(_to).name
                                        columnBlackHome.height -= container.width/15
                                        console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> MOVED FROM HEAD");
                                    }
                                    // Move Not From Head
                                    else {
                                        gridRepeater.itemAt(_from).childAt(0, 0).parent = gridRepeater.itemAt(_to)
                                        gridRepeater.itemAt(_from).childAt(0, 0).anchors.centerIn = gridRepeater.itemAt(_to)
                                        //gridRepeater.itemAt(_from).childAt(0, 0).name = gridRepeater.itemAt(_to).name
                                        console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> MOVED FROM GRID");
                                    }
                                }
                                // Move To End Point
                                else {
                                    gridRepeater.itemAt(_from).childAt(0, 0).parent = exitCellBlack
                                    gridRepeater.itemAt(_from).childAt(0, 0).anchors.centerIn = exitCellBlack
                                    console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> MOVED TO END POINT");
                                }
                            }
                        }

                        onVisibleChanged:
                            if ((zyara_p2.visible === true) && (informator.get_isAI() === true)) {
                                ////////// CHANGING PARENT ////////
                                console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> onVisibleChanged")
                                var i = 0;
                                do {
                                    console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> LOOP ITER " + i)
                                    informator.activateUpdateEnableMoves()
                                    var isExist = informator.isEnableMovesAIExist()
                                    if (isExist === true) {
                                        console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> EXIST")
                                        informator.moveAI()
                                        console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> MOVED BACK")
                                        makeMoveUI()
                                        console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> MOVED FRONT")
                                        //informator.deactivateFirstCurMove();
                                        informator.activateShowTest()
                                    }
                                    else {
                                        break;
                                    }
                                    i++
                                } while (informator.isTotalMoveAI() === false)
                                informator.activateSwitch()
                                ///////////////////////////////////
                            }
                    }
                }

                // Central Menu Info
                Column {
                    id: menuContainer
                    width: (parent.width - 2*parent.height)/3
                    height: parent.height

                    // Go-To-Menu Button
                    Button {
                        id: menuButton
                        objectName: "menuButton"
                        width: parent.width/1.3
                        height: parent.height/1.8
                        text: "MENU"
                        highlighted: true
                        anchors.horizontalCenter: menuContainer.horizontalCenter
                        anchors.leftMargin: parent.width/4
                        anchors.topMargin: 5
                        background: Rectangle {
                            color: menuButton.down ? "#535353" : "#f9aa4f"
                            radius: 8
                        }
                        font.family: "Calibri"
                        font.pixelSize: 22

                        signal menuClicked()
                        onClicked: {
                            soundButton.play()
                            timer.stop()
                            menuClicked()
                        }
                    }

                    // Game Time Elapsed
                    Text {
                        id: timeText
                        objectName: "timeText"
                        width: parent.width/1.3
                        height: parent.height/1.8
                        x: parent.width/3
                        y: parent.height/2
                        anchors.topMargin: 10
                        font.pixelSize: parent.height/4
                        color: "white"
                        text: "00:00"
                    }
                }

                // Player's Right Info (Player 1)
                Column {
                    width: (parent.width - 2*parent.height)/3
                    height: parent.height

                    // Player's 1 Name
                    Text {
                        id: player1Name
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignRight
                        width: parent.width
                        height: parent.height/2
                        topPadding: 7
                        rightPadding: 5
                        font.capitalization: "AllUppercase"
                        font.pixelSize: parent.height/4
                        color: "white"
                        text: "---"
                    }

                    // Current Zyara
                    Row {
                        id: zyara_p1
                        objectName: "zyara_p1"
                        width: parent.width
                        height: parent.height/2
                        visible: false

                        // Current Zyara 1 Pic
                        Image {
                            id: cur_1zyara_p1
                            objectName: "cur_1zyara_p1"
                            width: parent.height
                            height: parent.height
                            source: "qrc:/res/res/z1.png"
                            anchors.right: cur_2zyara_p1.left
                            anchors.rightMargin: 2
                        }

                        // Current Zyara 2 Pic
                        Image {
                            id: cur_2zyara_p1
                            objectName: "cur_2zyara_p1"
                            width: parent.height
                            height: parent.height
                            source: "qrc:/res/res/z1.png"
                            anchors.right: parent.right
                        }
                    }
                }

                // Player's 1 Pic
                Image {
                    id: player1lavrpic
                    width: parent.height
                    height: parent.height
                    source: "qrc:/res/res/lavr.png"
                    ParallelAnimation {
                        id: avarat1Animation
                        objectName: "avarat1Animation"
                        running: false
                        loops: Animation.Infinite
                        NumberAnimation {
                            target: player1pic
                            property: "scale"
                            from: 1.1
                            to: 0.9
                            duration: 2300
                            easing.type: Easing.InOutQuad
                        }
                        onRunningChanged: { // RIGHT P1
                            if (avarat1Animation.running === true) {
                                // Hide All Hints
                                for (var i=0; i<260; i++) {
                                    highlightRepeaterTarget.itemAt(i).opacity = 0.0;
                                }

                                // Hide Zyara Block
                                zyara_p2.visible = false;

                                // Start Zyara Animation
                                soundDrop.play();
                                rowZyaraDropAnimation.opacity = 1.0;
                                zyara1DropAnimation.running = true;
                                zyara2DropAnimation.running = true;
                            }
                        }
                    }
                    Image {
                        id: player1pic
                        width: parent.height
                        height: parent.height
                        source: "qrc:/res/res/pers7.png"
                        scale: 0.95
                    }
                }
            }

            // Left Board
            Column {
                id: leftBoard
                width: container.width/15
                height: (container.width*4)/3
                anchors {
                    left: rowMenu.left
                    top: rowMenu.bottom
                }
                DropItem {
                    id: exitCellBlack
                    objectName: "exitCellBlack";
                    width: container.width/15
                    height: container.width/15
                    anchors {
                        left: leftBoard.left
                        bottom: leftBoard.bottom
                    }
                    name: "cell_exit_black"
                    index: -1
                    path: "qrc:/res/res/highlight_to.png"
                    visible: false;
                    onVisibleChanged: {
                        if (visible === true) {
                            soundPortal.play()
                        }
                    }
                }
            }

            //////////////////////// TO /////////////////////////////
            Grid {
                id: gridHighlightTarget
                rows: 20
                columns: 13
                width: container.width*13/15
                height: (container.width*4)/3
                anchors {
                    left: leftBoard.right
                    top: rowMenu.bottom
                }
                Repeater {
                    id: highlightRepeaterTarget
                    model: 260
                    Item {
                        width: container.width/15
                        height: container.width/15
                        Image {
                            id: highlightCellImgTarget
                            width: container.width/15
                            height: container.width/15
                            source: "qrc:/res/res/highlight_to.png"
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: highlightCellImgTarget
                                property: "scale"
                                from: 0.1
                                to: 0.95
                                duration: 2000
                                easing.type: Easing.InOutBack
                            }
                            NumberAnimation {
                                target: highlightCellImgTarget
                                property: "opacity"
                                easing.overshoot: 5
                                from: 1.0
                                to: 0.1
                                duration: 2000
                                easing.type: Easing.InOutQuad
                            }
                            running: true
                            loops: Animation.Infinite
                        }
                    }
                }
            }
            ///////////////////////////////////////////////////////////

            // Board Grid
            Grid {
                id: gridBoard
                rows: 20
                columns: 13
                width: container.width*13/15
                height: (container.width*4)/3
                anchors {
                    left: leftBoard.right
                    top: rowMenu.bottom
                }
                Repeater {
                    id: gridRepeater
                    model: 260
                    delegate: DropItem {
                        //isActiveKey: (index+7)%13 === 0 ? false : true
                        name: "cell_"+index.toString()
                        path: "qrc:/res/res/fake.png"
                    }
                }
            }

            // Right Board
            Column {
                id: rightBoard
                width: container.width/15
                height: container.width/15
                anchors {
                    left: gridBoard.right
                    top: rowMenu.bottom
                }
                DropItem {
                    id: exitCellWhite
                    objectName: "exitCellWhite";
                    width: parent.width
                    height: parent.height
                    anchors.topMargin: container.width/15
                    //isActiveKey: true
                    name: "cell_exit_white"
                    index: 260
                    path: "qrc:/res/res/highlight_to.png"
                    visible: false;
                    onVisibleChanged: {
                        if (visible === true) {
                            soundPortal.play()
                        }
                    }
                }
            }

            // Bottom Line
            Row {
                id: bottomLine
                width: container.width
                height: container.width/15
                anchors {
                    left: leftBoard.left
                    top: leftBoard.bottom
                    topMargin: 4
                }
                Item {
                    width: parent.width
                    height: parent.height
                    //color: "brown"

                    // Mute Sounds
                    Switch {
                        id: switchMute
                        objectName: "switchMute"
                        width: parent.width/3
                        height: parent.height
                        text: "Sound On"
                        anchors.verticalCenter: parent.verticalCenter
                        checked: true
                        signal switched()
                        onCheckedChanged: {
                            // Better To Use Array To Prevent Spagetti Umfavoritto
                            if (checked === true) {
                                soundSwitch.play()
                                soundButton.volume = 1.0;
                                soundCrack.volume = 1.0;
                                soundDrop.volume = 1.0;
                                soundFire.volume = 1.0;
                                soundGame.volume = 1.0;
                                soundGlass.volume = 1.0;
                                soundIntro1.volume = 1.0;
                                soundIntro2.volume = 1.0;
                                soundIntro3.volume = 1.0;
                                soundIntro4.volume = 1.0;
                                soundMove.volume = 1.0;
                                soundPickPers.volume = 1.0;
                                soundSwitch.volume = 1.0;
                                soundWinner.volume = 1.0;
                                sound12.volume = 1.0;
                                sound13.volume = 1.0;
                                sound14.volume = 1.0;
                                sound15.volume = 1.0;
                                sound16.volume = 1.0;
                                sound23.volume = 1.0;
                                sound24.volume = 1.0;
                                sound25.volume = 1.0;
                                sound26.volume = 1.0;
                                sound34.volume = 1.0;
                                sound35.volume = 1.0;
                                sound36.volume = 1.0;
                                sound45.volume = 1.0;
                                sound46.volume = 1.0;
                                sound56.volume = 1.0;
                            }
                            else {
                                soundButton.volume = 0.0;
                                soundCrack.volume = 0.0;
                                soundDrop.volume = 0.0;
                                soundFire.volume = 0.0;
                                soundGame.volume = 0.0;
                                soundGlass.volume = 0.0;
                                soundIntro1.volume = 0.0;
                                soundIntro2.volume = 0.0;
                                soundIntro3.volume = 0.0;
                                soundIntro4.volume = 0.0;
                                soundMove.volume = 0.0;
                                soundPickPers.volume = 0.0;
                                soundSwitch.volume = 0.0;
                                soundWinner.volume = 0.0;
                                sound12.volume = 0.0;
                                sound13.volume = 0.0;
                                sound14.volume = 0.0;
                                sound15.volume = 0.0;
                                sound16.volume = 0.0;
                                sound23.volume = 0.0;
                                sound24.volume = 0.0;
                                sound25.volume = 0.0;
                                sound26.volume = 0.0;
                                sound34.volume = 0.0;
                                sound35.volume = 0.0;
                                sound36.volume = 0.0;
                                sound45.volume = 0.0;
                                sound46.volume = 0.0;
                                sound56.volume = 0.0;
                            }
                            switched()
                        }
                    }
                    // Mute Sounds

                    Switch {
                        id: switchHint
                        objectName: "switchHint"
                        width: parent.width/3
                        height: parent.height
                        text: "Hints On"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: switchMute.right
                        checked: true
                        signal hinted()
                        onCheckedChanged: {
                            soundSwitch.play()
                            hinted()
                            text = (switchHint.checked === true) ? "Hints On" : "Hints Off";
                            var to_s = informator.highlightCell(true).split(',');
                            for (var j=0; j<to_s.length; j++) {
                                highlightRepeaterTarget.itemAt(to_s[j]).opacity = (switchHint.checked === true) ? 1.0 : 0.0;
                            }
                        }
                    }
                }
            }

            // Black Home
            Column {
                id: columnBlackHome
                width: parent.width/15
                height: parent.width
                anchors {
                    left: leftBoard.right
                    bottom: bottomLine.top
                }

                Repeater {
                    id: blackRepeater
                    objectName: "blackRepeater"
                    model: 15
                    delegate: DragItem {
                        id: columnBlack
                        //isActiveKey: true
                        objectName: "black_"+index.toString()
                        name: "black_"+index.toString()
                        cid: (index+5)*13
                        photoPath: "qrc:/res/res/black.png"
                    }
                }
            }

            // White Home
            Column {
                anchors {
                    right: rightBoard.left
                    top: rightBoard.top
                }
                width: parent.width/15
                height: parent.width

                Repeater {
                    id: whiteRepeater
                    objectName: "whiteRepeater"
                    model: 15
                    delegate: DragItem {
                        id: columnWhite
                        //isActiveKey: true
                        name: "white_"+index.toString()
                        cid: (13*index)+12
                        photoPath: "qrc:/res/res/white.png"
                    }
                }
            }
            Desaturate {
                id: boardEffect
                objectName: "boardEffect"
                anchors.fill: boardImage
                source: boardImage
                desaturation: 1.0
                visible: false
            }
        }

        // Menu
        Column {
            id: menuContext
            objectName: "menuContext"
            width: container.width/4
            height: container.height/4;
            x: (container.width - width)/2;
            y: (container.height - height)/2;
            visible: false;
            Button {
                id: buttonMainMenu
                objectName: "buttonMainMenu"
                text: "MENU"
                width: parent.width
                height: parent.height/4
                onClicked: {
                    soundButton.play()
                    msgMainMenuDialog.visible = true
                }
            }
            Button {
                id: buttonStatistics
                objectName: "buttonStatistics"
                text: "GAME STATISTICS"
                width: parent.width
                height: parent.height/4
                signal menuClicked()
                onClicked: {
                    soundButton.play()
                    menuClicked()
                }
            }
            Button {
                id: buttonReturn
                objectName: "buttonReturn"
                text: "BACK TO GAME"
                width: parent.width
                height: parent.height/4
                signal menuClicked()
                onClicked: {
                    soundButton.play()
                    timer.start()
                    menuClicked()
                }
            }
        }

        // Confirm Go To Main Menu Dialog
        MessageDialog {
            id: msgMainMenuDialog
            objectName: "msgMainMenuDialog"
            text: "You are leaving the game."
            informativeText: "Are you sure?"
            buttons: MessageDialog.Ok | MessageDialog.Cancel
            visible: false;
            signal menuClicked()
            onOkClicked: {
                menuClicked()
                container.isFixedInitPos = true;
                boardImage.visible = false;
            }
        }

        // Confirm Exit Game
        MessageDialog {
            id: msgExitGame
            objectName: "msgExitGame"
            text: "You will exit the game."
            informativeText: "Are you sure?"
            buttons: MessageDialog.Ok | MessageDialog.Cancel
            visible: false;
            signal exitApp()
            onOkClicked: exitApp()
        }

        // Statistics
        Image {
            id: statistics
            objectName: "statistics"
            width: parent.width
            height: parent.height
            source: "qrc:/res/res/bg_blur.png"
            visible: false

            Item {
                id: textStat
                width: parent.width/1.2
                height: parent.height/5
                anchors.topMargin: 5
                anchors.top: parent.top
                Text {
                    text: "CURRENT GAME STATISTICS -> %"
                    color: "white"
                    font.pixelSize: 40
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Grid {
                id: upperGridStat
                rows: 6
                columns: 3
                width: parent.width
                height: parent.height/4
                anchors.top: textStat.bottom
                anchors.topMargin: parent.height/12
                anchors.leftMargin: 5
                spacing: 10
                // 1:1
                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii0
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z1.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp0
                        anchors.left: ii0.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z1.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt0
                        anchors.left: pp0.right
                        objectName: "stat11"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }
                // 2:2

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii1
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z2.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp1
                        anchors.left: ii1.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z2.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt1
                        anchors.left: pp1.right
                        objectName: "stat22"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 3:3

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii2
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z3.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp2
                        anchors.left: ii2.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z3.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt2
                        anchors.left: pp2.right
                        objectName: "stat33"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 1:2

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii3
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z1.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp3
                        anchors.left: ii3.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z2.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt3
                        anchors.left: pp3.right
                        objectName: "stat12"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 2:3

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii4
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z2.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp4
                        anchors.left: ii4.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z3.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt4
                        anchors.left: pp4.right
                        objectName: "stat23"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 3:4

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii5
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z3.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp5
                        anchors.left: ii5.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z4.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt5
                        anchors.left: pp5.right
                        objectName: "stat34"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 1:3

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii6
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z1.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp6
                        anchors.left: ii6.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z3.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt6
                        anchors.left: pp6.right
                        objectName: "stat13"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 2:4

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii7
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z2.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp7
                        anchors.left: ii7.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z4.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt7
                        anchors.left: pp7.right
                        objectName: "stat24"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 3:5

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii8
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z3.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp8
                        anchors.left: ii8.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z5.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt8
                        anchors.left: pp8.right
                        objectName: "stat35"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 1:4

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii9
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z1.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp9
                        anchors.left: ii9.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z4.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt9
                        anchors.left: pp9.right
                        objectName: "stat14"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 2:5

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii10
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z2.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp10
                        anchors.left: ii10.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z5.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt10
                        anchors.left: pp10.right
                        objectName: "stat25"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 3:6

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii11
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z3.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp11
                        anchors.left: ii11.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z6.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt11
                        anchors.left: pp11.right
                        objectName: "stat36"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 1:5

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii12
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z1.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp12
                        anchors.left: ii12.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z5.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt12
                        anchors.left: pp12.right
                        objectName: "stat15"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 2:6

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii13
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z2.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp13
                        anchors.left: ii13.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z6.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt13
                        anchors.left: pp13.right
                        objectName: "stat26"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // Fake

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii14
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/fake.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp14
                        anchors.left: ii14.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/fake.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt14
                        anchors.left: pp14.right
                        width: parent.width/3
                        height: parent.height
                        text: "";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 1:6

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii15
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z1.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp15
                        anchors.left: ii15.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z6.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt15
                        anchors.left: pp15.right
                        objectName: "stat16"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

            }

            Grid {
                rows: 3
                columns: 3
                width: parent.width
                height: parent.height/4
                anchors.top: upperGridStat.bottom
                anchors.topMargin: parent.height/12
                spacing: 10
                // 4:4
                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii16
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z4.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp16
                        anchors.left: ii16.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z4.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt16
                        anchors.left: pp16.right
                        objectName: "stat44"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }
                // 5:5

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii17
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z5.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp17
                        anchors.left: ii17.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z5.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt17
                        anchors.left: pp17.right
                        objectName: "stat55"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 6:6

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii18
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z6.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp18
                        anchors.left: ii18.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z6.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt18
                        anchors.left: pp18.right
                        objectName: "stat66"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 4:5

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii19
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z4.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp19
                        anchors.left: ii19.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z5.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt19
                        anchors.left: pp19.right
                        objectName: "stat45"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 5:6

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii20
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z5.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp20
                        anchors.left: ii20.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z6.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt20
                        anchors.left: pp20.right
                        objectName: "stat56"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // fake

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii21
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/fake.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp21
                        anchors.left: ii21.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/fake.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt21
                        anchors.left: pp21.right
                        width: parent.width/3
                        height: parent.height
                        text: "";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

                // 4:6

                Row {
                    width: parent.width/3
                    height: parent.width/14
                    Image {
                        id: ii22
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z4.png"
                        anchors.leftMargin: 5
                    }
                    Image {
                        id: pp22
                        anchors.left: ii22.right
                        width: parent.width/4
                        height: parent.width/4
                        source: "qrc:/res/res/z6.png"
                        anchors.leftMargin: 5
                    }
                    Text {
                        id: tt22
                        anchors.left: pp22.right
                        objectName: "stat46"
                        width: parent.width/3
                        height: parent.height
                        text: " -> 0%";
                        color: "white"
                        font.pixelSize: 24
                    }
                }

            }

            Button {
                id: closeStatistics
                objectName: "closeStatistics"
                text: "BACK TO MENU"
                width: parent.width/4
                height: parent.height/12
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: parent.height/12
                signal menuClicked()
                onClicked: {
                    soundButton.play()
                    menuClicked()
                }
            }
        }

        ///////////////////////////// DROP + SHAMAN /////////////////////////////////////
        // Animation Drop
        Row {
           id: rowZyaraDropAnimation
           width: container.width
           height: container.height/2
           opacity: 0.0
           anchors.bottom: parent.bottom
           anchors.horizontalCenter: parent.horizontalCenter
           AnimatedSprite {
               id: zyara1DropAnimation
               width: parent.width/2
               height: parent.height
               anchors.left: parent.left
               source: "qrc:/res/res/zyara_sprite.png"
               frameWidth: 1080
               frameHeight: 1920
               frameCount: 23
               frameDuration: 50
               loops: 1
               interpolate: true;
               running: false
               onCurrentFrameChanged: {
                   if (currentFrame == 22) {
                       // Stop Moving Zyara
                       running = false;
                       currentFrame = 22;
                   }
               }
           }
           AnimatedSprite {
               id: zyara2DropAnimation
               width: parent.width/2
               height: parent.height
               anchors.right: parent.right
               source: "qrc:/res/res/zyara_sprite.png"
               frameWidth: 1080
               frameHeight: 1920
               frameCount: 23
               frameDuration: 60
               loops: 1
               interpolate: true;
               running: false
               onCurrentFrameChanged: {
                   if (currentFrame == 22) {
                       // Stop Moving Zyara
                       running = false;
                       currentFrame = 22;
                       // Replace Real Generated Zayra
                       // (Better To Use Char As Index To Prevent Spagetti-Code)
                       if (avarat1Animation.running === true) {
                           // If Not Kusha --> Just Replace With Generated Nums
                           if (cur_1zyara_p1.source != cur_2zyara_p1.source) {
                               // z1
                               if (cur_1zyara_p1.source == "qrc:/res/res/z1.png") {
                                   zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 6
                               }
                               else if (cur_1zyara_p1.source == "qrc:/res/res/z2.png") {
                                   zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 5
                               }
                               else if (cur_1zyara_p1.source == "qrc:/res/res/z3.png") {
                                   zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 4
                               }
                               else if (cur_1zyara_p1.source == "qrc:/res/res/z4.png") {
                                   zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 3
                               }
                               else if (cur_1zyara_p1.source == "qrc:/res/res/z5.png") {
                                   zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 2
                               }
                               else if (cur_1zyara_p1.source == "qrc:/res/res/z6.png") {
                                   zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 1
                               }
                               // z2
                               if (cur_2zyara_p1.source == "qrc:/res/res/z1.png") {
                                   zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 6
                               }
                               else if (cur_2zyara_p1.source == "qrc:/res/res/z2.png") {
                                   zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 5
                               }
                               else if (cur_2zyara_p1.source == "qrc:/res/res/z3.png") {
                                   zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 4
                               }
                               else if (cur_2zyara_p1.source == "qrc:/res/res/z4.png") {
                                   zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 3
                               }
                               else if (cur_2zyara_p1.source == "qrc:/res/res/z5.png") {
                                   zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 2
                               }
                               else if (cur_2zyara_p1.source == "qrc:/res/res/z6.png") {
                                   zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 1
                               }

                               // Make Sound For 1:2
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z1.png" && cur_2zyara_p1.source == "qrc:/res/res/z2.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z2.png" && cur_2zyara_p1.source == "qrc:/res/res/z1.png")) {
                                   sound12.play();
                               }
                               // Make Sound For 1:3
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z1.png" && cur_2zyara_p1.source == "qrc:/res/res/z3.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z3.png" && cur_2zyara_p1.source == "qrc:/res/res/z1.png")) {
                                   sound13.play();
                               }
                               // Make Sound For 1:4
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z1.png" && cur_2zyara_p1.source == "qrc:/res/res/z4.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z4.png" && cur_2zyara_p1.source == "qrc:/res/res/z1.png")) {
                                   sound14.play();
                               }
                               // Make Sound For 1:5
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z1.png" && cur_2zyara_p1.source == "qrc:/res/res/z5.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z5.png" && cur_2zyara_p1.source == "qrc:/res/res/z1.png")) {
                                   sound15.play();
                               }
                               // Make Sound For 1:6
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z1.png" && cur_2zyara_p1.source == "qrc:/res/res/z6.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z6.png" && cur_2zyara_p1.source == "qrc:/res/res/z1.png")) {
                                   sound16.play();
                               }
                               // Make Sound For 2:3
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z2.png" && cur_2zyara_p1.source == "qrc:/res/res/z3.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z3.png" && cur_2zyara_p1.source == "qrc:/res/res/z2.png")) {
                                   sound23.play();
                               }
                               // Make Sound For 2:4
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z2.png" && cur_2zyara_p1.source == "qrc:/res/res/z4.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z4.png" && cur_2zyara_p1.source == "qrc:/res/res/z2.png")) {
                                   sound24.play();
                               }
                               // Make Sound For 2:5
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z2.png" && cur_2zyara_p1.source == "qrc:/res/res/z5.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z5.png" && cur_2zyara_p1.source == "qrc:/res/res/z2.png")) {
                                   sound25.play();
                               }
                               // Make Sound For 2:6
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z2.png" && cur_2zyara_p1.source == "qrc:/res/res/z6.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z6.png" && cur_2zyara_p1.source == "qrc:/res/res/z2.png")) {
                                   sound26.play();
                               }
                               // Make Sound For 3:4
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z3.png" && cur_2zyara_p1.source == "qrc:/res/res/z4.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z4.png" && cur_2zyara_p1.source == "qrc:/res/res/z3.png")) {
                                   sound34.play();
                               }
                               // Make Sound For 3:5
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z3.png" && cur_2zyara_p1.source == "qrc:/res/res/z5.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z5.png" && cur_2zyara_p1.source == "qrc:/res/res/z3.png")) {
                                   sound35.play();
                               }
                               // Make Sound For 3:6
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z3.png" && cur_2zyara_p1.source == "qrc:/res/res/z6.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z6.png" && cur_2zyara_p1.source == "qrc:/res/res/z3.png")) {
                                   sound36.play();
                               }
                               // Make Sound For 4:5
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z4.png" && cur_2zyara_p1.source == "qrc:/res/res/z5.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z5.png" && cur_2zyara_p1.source == "qrc:/res/res/z4.png")) {
                                   sound45.play();
                               }
                               // Make Sound For 4:6
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z4.png" && cur_2zyara_p1.source == "qrc:/res/res/z6.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z6.png" && cur_2zyara_p1.source == "qrc:/res/res/z4.png")) {
                                   sound46.play();
                               }
                               // Make Sound For 5:6
                               if ((cur_1zyara_p1.source == "qrc:/res/res/z5.png" && cur_2zyara_p1.source == "qrc:/res/res/z6.png") ||
                                   (cur_1zyara_p1.source == "qrc:/res/res/z6.png" && cur_2zyara_p1.source == "qrc:/res/res/z5.png")) {
                                   sound56.play();
                               }

                               // Hide Zyara
                               rowZyaraHideAnimation.running = true;
                           }
                           // Call Shaman
                           else {
                               // Set Fake Nums (2:1)
                               zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 6
                               zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 5
                               // Call Shaman If Required (Id Kosha)
                               shamanInAnimation.running = true;
                           }
                       }
                       else {
                           // If Not Kusha --> Just Replace With Generated Nums
                           if (cur_1zyara_p2.source != cur_2zyara_p2.source) {
                               // z1
                               if (cur_1zyara_p2.source == "qrc:/res/res/z1.png") {
                                   zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 6
                               }
                               else if (cur_1zyara_p2.source == "qrc:/res/res/z2.png") {
                                   zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 5
                               }
                               else if (cur_1zyara_p2.source == "qrc:/res/res/z3.png") {
                                   zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 4
                               }
                               else if (cur_1zyara_p2.source == "qrc:/res/res/z4.png") {
                                   zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 3
                               }
                               else if (cur_1zyara_p2.source == "qrc:/res/res/z5.png") {
                                   zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 2
                               }
                               else if (cur_1zyara_p2.source == "qrc:/res/res/z6.png") {
                                   zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 1
                               }
                               // z2
                               if (cur_2zyara_p2.source == "qrc:/res/res/z1.png") {
                                   zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 6
                               }
                               else if (cur_2zyara_p2.source == "qrc:/res/res/z2.png") {
                                   zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 5
                               }
                               else if (cur_2zyara_p2.source == "qrc:/res/res/z3.png") {
                                   zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 4
                               }
                               else if (cur_2zyara_p2.source == "qrc:/res/res/z4.png") {
                                   zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 3
                               }
                               else if (cur_2zyara_p2.source == "qrc:/res/res/z5.png") {
                                   zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 2
                               }
                               else if (cur_2zyara_p2.source == "qrc:/res/res/z6.png") {
                                   zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 1
                               }

                               // Make Sound For 1:2
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z1.png" && cur_2zyara_p2.source == "qrc:/res/res/z2.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z2.png" && cur_2zyara_p2.source == "qrc:/res/res/z1.png")) {
                                   sound12.play();
                               }
                               // Make Sound For 1:3
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z1.png" && cur_2zyara_p2.source == "qrc:/res/res/z3.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z3.png" && cur_2zyara_p2.source == "qrc:/res/res/z1.png")) {
                                   sound13.play();
                               }
                               // Make Sound For 1:4
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z1.png" && cur_2zyara_p2.source == "qrc:/res/res/z4.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z4.png" && cur_2zyara_p2.source == "qrc:/res/res/z1.png")) {
                                   sound14.play();
                               }
                               // Make Sound For 1:5
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z1.png" && cur_2zyara_p2.source == "qrc:/res/res/z5.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z5.png" && cur_2zyara_p2.source == "qrc:/res/res/z1.png")) {
                                   sound15.play();
                               }
                               // Make Sound For 1:6
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z1.png" && cur_2zyara_p2.source == "qrc:/res/res/z6.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z6.png" && cur_2zyara_p2.source == "qrc:/res/res/z1.png")) {
                                   sound16.play();
                               }
                               // Make Sound For 2:3
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z2.png" && cur_2zyara_p2.source == "qrc:/res/res/z3.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z3.png" && cur_2zyara_p2.source == "qrc:/res/res/z2.png")) {
                                   sound23.play();
                               }
                               // Make Sound For 2:4
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z2.png" && cur_2zyara_p2.source == "qrc:/res/res/z4.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z4.png" && cur_2zyara_p2.source == "qrc:/res/res/z2.png")) {
                                   sound24.play();
                               }
                               // Make Sound For 2:5
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z2.png" && cur_2zyara_p2.source == "qrc:/res/res/z5.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z5.png" && cur_2zyara_p2.source == "qrc:/res/res/z2.png")) {
                                   sound25.play();
                               }
                               // Make Sound For 2:6
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z2.png" && cur_2zyara_p2.source == "qrc:/res/res/z6.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z6.png" && cur_2zyara_p2.source == "qrc:/res/res/z2.png")) {
                                   sound26.play();
                               }
                               // Make Sound For 3:4
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z3.png" && cur_2zyara_p2.source == "qrc:/res/res/z4.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z4.png" && cur_2zyara_p2.source == "qrc:/res/res/z3.png")) {
                                   sound34.play();
                               }
                               // Make Sound For 3:5
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z3.png" && cur_2zyara_p2.source == "qrc:/res/res/z5.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z5.png" && cur_2zyara_p2.source == "qrc:/res/res/z3.png")) {
                                   sound35.play();
                               }
                               // Make Sound For 3:6
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z3.png" && cur_2zyara_p2.source == "qrc:/res/res/z6.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z6.png" && cur_2zyara_p2.source == "qrc:/res/res/z3.png")) {
                                   sound36.play();
                               }
                               // Make Sound For 4:5
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z4.png" && cur_2zyara_p2.source == "qrc:/res/res/z5.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z5.png" && cur_2zyara_p2.source == "qrc:/res/res/z4.png")) {
                                   sound45.play();
                               }
                               // Make Sound For 4:6
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z4.png" && cur_2zyara_p2.source == "qrc:/res/res/z6.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z6.png" && cur_2zyara_p2.source == "qrc:/res/res/z4.png")) {
                                   sound46.play();
                               }
                               // Make Sound For 5:6
                               if ((cur_1zyara_p2.source == "qrc:/res/res/z5.png" && cur_2zyara_p2.source == "qrc:/res/res/z6.png") ||
                                   (cur_1zyara_p2.source == "qrc:/res/res/z6.png" && cur_2zyara_p2.source == "qrc:/res/res/z5.png")) {
                                   sound56.play();
                               }

                               // Hide Zyara
                               rowZyaraHideAnimation.running = true;
                           }
                           // Call Shaman
                           else {
                               // Set Fake Nums (2:1)
                               zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 6
                               zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 5
                               // Call Shaman If Required (Id Kosha)
                               shamanInAnimation.running = true;
                           }
                       }


                   }
               }
           }
        }

        // Shaman
        Image {
           id: shaman
           source: "qrc:/res/res/shaman.png"
           width: parent.width/1.8
           height: parent.width/1.8
           x: parent.width + parent.width/1.8
           y: parent.height + parent.width/1.8
        }

        // Shaman Intro
        ParallelAnimation {
           id: shamanInAnimation
           running: false;
           onStarted: {
               shaman.visible = true;
           }

           NumberAnimation {
               target: shaman
               property: "x"
               from: container.width + container.width/1.8
               to: container.width - container.width/1.8
               duration: 1000
               easing.type: Easing.InOutCubic
           }
           NumberAnimation {
               target: shaman
               property: "y"
               from: container.height + container.width/1.8
               to: container.height - container.width/1.8
               duration: 1000
               easing.type: Easing.InOutCubic
           }
           onFinished: {
               soundFire.play();
               //shamanInAnimation.running = false;
               fireAnimation.visible = true;
               fireAnimation.running = true;
           }
        }

        // Fire
        AnimatedSprite {
           id: fireAnimation
           width: parent.width
           x: parent.width/2-fireAnimation.width/2
           y: parent.height/2-fireAnimation.height/2
           source: "qrc:/res/res/fire_sprite.png"
           visible: false
           rotation: 45
           frameWidth: 640
           frameHeight: 360
           frameCount: 73
           frameRate: 30
           loops: 1
           running: false
           onCurrentFrameChanged: {
               if (currentFrame > frameCount/2) {
                   if (avarat1Animation.running === true) {
                       if (cur_1zyara_p1.source == "qrc:/res/res/z1.png") {
                           zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 6
                           zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 6
                       }
                       else if (cur_1zyara_p1.source == "qrc:/res/res/z2.png") {
                           zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 5
                           zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 5
                       }
                       else if (cur_1zyara_p1.source == "qrc:/res/res/z3.png") {
                           zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 4
                           zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 4
                       }
                       else if (cur_1zyara_p1.source == "qrc:/res/res/z4.png") {
                           zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 3
                           zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 3
                       }
                       else if (cur_1zyara_p1.source == "qrc:/res/res/z5.png") {
                           zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 2
                           zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 2
                       }
                       else if (cur_1zyara_p1.source == "qrc:/res/res/z6.png") {
                           zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 1
                           zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 1
                       }
                   }
                   else  {
                       if (cur_1zyara_p2.source == "qrc:/res/res/z1.png") {
                           zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 6
                           zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 6
                       }
                       else if (cur_1zyara_p2.source == "qrc:/res/res/z2.png") {
                           zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 5
                           zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 5
                       }
                       else if (cur_1zyara_p2.source == "qrc:/res/res/z3.png") {
                           zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 4
                           zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 4
                       }
                       else if (cur_1zyara_p2.source == "qrc:/res/res/z4.png") {
                           zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 3
                           zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 3
                       }
                       else if (cur_1zyara_p2.source == "qrc:/res/res/z5.png") {
                           zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 2
                           zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 2
                       }
                       else if (cur_1zyara_p2.source == "qrc:/res/res/z6.png") {
                           zyara1DropAnimation.currentFrame = zyara1DropAnimation.frameCount - 1
                           zyara2DropAnimation.currentFrame = zyara2DropAnimation.frameCount - 1
                       }
                   }
                   rowZyaraHideAnimation.running = true;
               }
           }
           onFinished: {
               shamanInAnimation.running = false;
               shamanOutAnimation.running = true;
               shaman.visible = false;
               rowZyaraHideAnimation.running = true;
           }
        }

        // Shaman Outro
        ParallelAnimation {
           id: shamanOutAnimation
           running: false;
           NumberAnimation {
               target: shaman
               property: "x"
               from: container.width - container.width/1.8
               to: container.width + container.width/1.8
               duration: 1000
               easing.type: Easing.InOutCubic
           }
           NumberAnimation {
               target: shaman
               property: "y"
               from: container.height - container.width/1.8
               to: container.height + container.width/1.8
               duration: 1000
               easing.type: Easing.InOutCubic
           }
        }

        SequentialAnimation {
           id: rowZyaraHideAnimation
           running: false;
           NumberAnimation {
               target: rowZyaraDropAnimation
               property: "opacity"
               from: 1.0
               to: 0.0
               duration: 200
               easing.type: Easing.InOutBack
           }
           onFinished: {
               shamanOutAnimation.running = false;

               // Show Zyara Block
               if (avarat1Animation.running === true) {
                   zyara_p1.visible = true;
               }
               else {
                   zyara_p2.visible = true;
               }
               // Get Valid Cells
               var to_s = informator.highlightCell(true).split(',')

               // Set Valid Cells To Move To
               if (switchHint.checked === true) {
                   for (var j=0; j<to_s.length; j++){
                       //console.log(to_s[j] + " ")
                       highlightRepeaterTarget.itemAt(to_s[j]).opacity = 1.0;
                   }
               }
           }
       }
        /////////////////////////////////////////////////////////////////////////////

        // Main Menu
        Image {
            id: mainMenu
            objectName: "mainMenu"
            width: parent.width
            height: parent.height
            source: "qrc:/res/res/bg2_blur.png"
            visible: false
            Column {
                id: mainMenuRect
                width: container.width/4
                height: container.height/4;
                x: (container.width - width)/2;
                y: (container.height - height)/2;
                Button {
                    id: newGameAI
                    objectName: "newGameAI"
                    text: "PLAYER VS AI"
                    width: parent.width
                    height: parent.height/4
                    signal startGameAI()
                    onClicked: {
                        soundButton.play()
                        informator.activateGameAI(true);
                        startGameAI()
                    }
                }
                Button {
                    id: newGamePlayer
                    objectName: "newGamePlayer"
                    text: "PLAYER VS PLAYER"
                    width: parent.width
                    height: parent.height/4
                    signal startGamePlayer()
                    onClicked: {
                        soundButton.play()
                        informator.activateGameAI(false);
                        startGamePlayer()
                    }
                }

                ////////////// TEST CASE EXIT ///////////////////
//                Button {
//                    id: newGameTestExit
//                    objectName: "newGameTestExit"
//                    text: "GAME EXIT"
//                    width: parent.width
//                    height: parent.height/4
//                    signal startGameTestExit()
//                    onClicked: {
//                        soundButton.play()
//                        informator.activateGameAI(false);
//                        startGameTestExit()
//                    }
//                }
                /////////////////////////////////////////////////

                Button {
                    id: exitGame
                    objectName: "exitGame"
                    text: "EXIT"
                    width: parent.width
                    height: parent.height/4
                    signal menuClicked()
                    onClicked: {
                        soundButton.play()
                        msgExitGame.visible = true
                    }
                }
            }
        }

        // Select Player 1 Frame
        Image {
            id: selectPlayer
            objectName: "selectPlayer"
            width: container.width
            height: container.height
            source: "qrc:/res/res/bg_players.png"
            visible: false
            Column {
                id: mainSelectPlayer
                width: parent.width
                height: parent.height
                Item {
                    width: parent.width/4
                    height: container.height/6
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        id: uiSelectAvatarPlayer
                        text: "Choose Person #1:"
                        font.pixelSize: 24
                        color: "#DFDFDF"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.topMargin: container.height/12
                    }
                }

                //////////////////////////////////////  GRID START //////////////////////////////////////

                Grid {
                    id: gridPlayers
                    rows: 2
                    columns: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.rightMargin: 5
                    spacing: 10
                    width: parent.width*4/5
                    height: parent.height/3
                    property string playerAvatar: "qrc:/res/res/pers1.png"

                    /////////////////////// PERS 1
                    Item {
                        width: parent.width/4
                        height: parent.width/4
                        Image {
                            id: persActiveFrame1
                            width: parent.width
                            height: parent.width
                            source: "qrc:/res/res/frame_active.png"
                            visible: true
                        }
                        Image {
                            id: persFrame1
                            width: parent.width
                            height: parent.width
                            anchors.left: persActiveFrame1.left
                            anchors.top: persActiveFrame1.top
                            source: "qrc:/res/res/frame.png"
                            Image {
                                id: pers1
                                objectName: "Pers1"
                                width: parent.width
                                height: parent.height
                                scale: 0.85
                                source: "qrc:/res/res/pers1.png"
                                anchors.centerIn: parent
                            }
                        }
                        MouseArea {
                            anchors.fill: persActiveFrame1
                            onPressed: {
                                soundPickPers.play()
                                player1Input.text = pers1.objectName
                                gridPlayers.playerAvatar = pers1.source
                                persActiveFrame1.visible = true
                                persActiveFrame2.visible = false
                                persActiveFrame3.visible = false
                                persActiveFrame4.visible = false
                                persActiveFrame5.visible = false
                                persActiveFrame6.visible = false
                                persActiveFrame7.visible = false
                                persActiveFrame8.visible = false
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: persActiveFrame1
                                property: "scale"
                                from: 1.1
                                to: 0.9
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            NumberAnimation {
                                target: persActiveFrame1
                                property: "opacity"
                                from: 1.0
                                to: 0.7
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            running: true
                            loops: Animation.Infinite
                        }
                    }

                    /////////////////////// PERS 2
                    Item {
                        width: parent.width/4
                        height: parent.width/4
                        Image {
                            id: persActiveFrame2
                            width: parent.width
                            height: parent.width
                            source: "qrc:/res/res/frame_active.png"
                            visible: false
                        }
                        Image {
                            id: persFrame2
                            width: parent.width
                            height: parent.width
                            anchors.left: persActiveFrame2.left
                            anchors.top: persActiveFrame2.top
                            source: "qrc:/res/res/frame.png"
                            Image {
                                id: pers2
                                objectName: "Pers2"
                                width: parent.width
                                height: parent.height
                                scale: 0.85
                                source: "qrc:/res/res/pers2.png"
                                anchors.centerIn: parent
                            }
                        }
                        MouseArea {
                            anchors.fill: persActiveFrame2
                            onPressed: {
                                soundPickPers.play()
                                player1Input.text = pers2.objectName
                                gridPlayers.playerAvatar = pers2.source
                                persActiveFrame2.visible = true
                                persActiveFrame1.visible = false
                                persActiveFrame3.visible = false
                                persActiveFrame4.visible = false
                                persActiveFrame5.visible = false
                                persActiveFrame6.visible = false
                                persActiveFrame7.visible = false
                                persActiveFrame8.visible = false
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: persActiveFrame2
                                property: "scale"
                                from: 1.1
                                to: 0.9
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            NumberAnimation {
                                target: persActiveFrame2
                                property: "opacity"
                                from: 1.0
                                to: 0.7
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            running: true
                            loops: Animation.Infinite
                        }
                    }


                    /////////////////////// PERS 3
                    Item {
                        width: parent.width/4
                        height: parent.width/4
                        Image {
                            id: persActiveFrame3
                            width: parent.width
                            height: parent.width
                            source: "qrc:/res/res/frame_active.png"
                            visible: false
                        }
                        Image {
                            id: persFrame3
                            width: parent.width
                            height: parent.width
                            anchors.left: persActiveFrame3.left
                            anchors.top: persActiveFrame3.top
                            source: "qrc:/res/res/frame.png"
                            Image {
                                id: pers3
                                objectName: "Pers3"
                                width: parent.width
                                height: parent.height
                                scale: 0.85
                                source: "qrc:/res/res/pers3.png"
                                anchors.centerIn: parent
                            }
                        }
                        MouseArea {
                            anchors.fill: persActiveFrame3
                            onPressed: {
                                soundPickPers.play()
                                player1Input.text = pers3.objectName
                                gridPlayers.playerAvatar = pers3.source
                                persActiveFrame3.visible = true
                                persActiveFrame1.visible = false
                                persActiveFrame2.visible = false
                                persActiveFrame4.visible = false
                                persActiveFrame5.visible = false
                                persActiveFrame6.visible = false
                                persActiveFrame7.visible = false
                                persActiveFrame8.visible = false
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: persActiveFrame3
                                property: "scale"
                                from: 1.1
                                to: 0.9
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            NumberAnimation {
                                target: persActiveFrame3
                                property: "opacity"
                                from: 1.0
                                to: 0.7
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            running: true
                            loops: Animation.Infinite
                        }
                    }


                    /////////////////////// PERS 4
                    Item {
                        width: parent.width/4
                        height: parent.width/4
                        Image {
                            id: persActiveFrame4
                            width: parent.width
                            height: parent.width
                            source: "qrc:/res/res/frame_active.png"
                            visible: false
                        }
                        Image {
                            id: persFrame4
                            width: parent.width
                            height: parent.width
                            anchors.left: persActiveFrame4.left
                            anchors.top: persActiveFrame4.top
                            source: "qrc:/res/res/frame.png"
                            Image {
                                id: pers4
                                objectName: "Pers4"
                                width: parent.width
                                height: parent.height
                                scale: 0.85
                                source: "qrc:/res/res/pers4.png"
                                anchors.centerIn: parent
                            }
                        }
                        MouseArea {
                            anchors.fill: persActiveFrame4
                            onPressed: {
                                soundPickPers.play()
                                player1Input.text = pers4.objectName
                                gridPlayers.playerAvatar = pers4.source
                                persActiveFrame4.visible = true
                                persActiveFrame1.visible = false
                                persActiveFrame2.visible = false
                                persActiveFrame3.visible = false
                                persActiveFrame5.visible = false
                                persActiveFrame6.visible = false
                                persActiveFrame7.visible = false
                                persActiveFrame8.visible = false
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: persActiveFrame4
                                property: "scale"
                                from: 1.1
                                to: 0.9
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            NumberAnimation {
                                target: persActiveFrame4
                                property: "opacity"
                                from: 1.0
                                to: 0.7
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            running: true
                            loops: Animation.Infinite
                        }
                    }


                    /////////////////////// PERS 5
                    Item {
                        width: parent.width/4
                        height: parent.width/4
                        Image {
                            id: persActiveFrame5
                            width: parent.width
                            height: parent.width
                            source: "qrc:/res/res/frame_active.png"
                            visible: false
                        }
                        Image {
                            id: persFrame5
                            width: parent.width
                            height: parent.width
                            anchors.left: persActiveFrame5.left
                            anchors.top: persActiveFrame5.top
                            source: "qrc:/res/res/frame.png"
                            Image {
                                id: pers5
                                objectName: "Pers5"
                                width: parent.width
                                height: parent.height
                                scale: 0.85
                                source: "qrc:/res/res/pers5.png"
                                anchors.centerIn: parent
                            }
                        }
                        MouseArea {
                            anchors.fill: persActiveFrame5
                            onPressed: {
                                soundPickPers.play()
                                player1Input.text = pers5.objectName
                                gridPlayers.playerAvatar = pers5.source
                                persActiveFrame5.visible = true
                                persActiveFrame1.visible = false
                                persActiveFrame2.visible = false
                                persActiveFrame3.visible = false
                                persActiveFrame4.visible = false
                                persActiveFrame6.visible = false
                                persActiveFrame7.visible = false
                                persActiveFrame8.visible = false
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: persActiveFrame5
                                property: "scale"
                                from: 1.1
                                to: 0.9
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            NumberAnimation {
                                target: persActiveFrame5
                                property: "opacity"
                                from: 1.0
                                to: 0.7
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            running: true
                            loops: Animation.Infinite
                        }
                    }


                    /////////////////////// PERS 6
                    Item {
                        width: parent.width/4
                        height: parent.width/4
                        Image {
                            id: persActiveFrame6
                            width: parent.width
                            height: parent.width
                            source: "qrc:/res/res/frame_active.png"
                            visible: false
                        }
                        Image {
                            id: persFrame6
                            width: parent.width
                            height: parent.width
                            anchors.left: persActiveFrame6.left
                            anchors.top: persActiveFrame6.top
                            source: "qrc:/res/res/frame.png"
                            Image {
                                id: pers6
                                objectName: "Pers6"
                                width: parent.width
                                height: parent.height
                                scale: 0.85
                                source: "qrc:/res/res/pers6.png"
                                anchors.centerIn: parent
                            }
                        }
                        MouseArea {
                            anchors.fill: persActiveFrame6
                            onPressed: {
                                soundPickPers.play()
                                player1Input.text = pers6.objectName
                                gridPlayers.playerAvatar = pers6.source
                                persActiveFrame6.visible = true
                                persActiveFrame1.visible = false
                                persActiveFrame2.visible = false
                                persActiveFrame3.visible = false
                                persActiveFrame4.visible = false
                                persActiveFrame5.visible = false
                                persActiveFrame7.visible = false
                                persActiveFrame8.visible = false
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: persActiveFrame6
                                property: "scale"
                                from: 1.1
                                to: 0.9
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            NumberAnimation {
                                target: persActiveFrame6
                                property: "opacity"
                                from: 1.0
                                to: 0.7
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            running: true
                            loops: Animation.Infinite
                        }
                    }


                    /////////////////////// PERS 7
                    Item {
                        width: parent.width/4
                        height: parent.width/4
                        Image {
                            id: persActiveFrame7
                            width: parent.width
                            height: parent.width
                            source: "qrc:/res/res/frame_active.png"
                            visible: false
                        }
                        Image {
                            id: persFrame7
                            width: parent.width
                            height: parent.width
                            anchors.left: persActiveFrame7.left
                            anchors.top: persActiveFrame7.top
                            source: "qrc:/res/res/frame.png"
                            Image {
                                id: pers7
                                objectName: "Pers7"
                                width: parent.width
                                height: parent.height
                                scale: 0.85
                                source: "qrc:/res/res/pers7.png"
                                anchors.centerIn: parent
                            }
                        }
                        MouseArea {
                            anchors.fill: persActiveFrame7
                            onPressed: {
                                soundPickPers.play()
                                player1Input.text = pers7.objectName
                                gridPlayers.playerAvatar = pers7.source
                                persActiveFrame7.visible = true
                                persActiveFrame1.visible = false
                                persActiveFrame2.visible = false
                                persActiveFrame3.visible = false
                                persActiveFrame4.visible = false
                                persActiveFrame5.visible = false
                                persActiveFrame6.visible = false
                                persActiveFrame8.visible = false
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: persActiveFrame7
                                property: "scale"
                                from: 1.1
                                to: 0.9
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            NumberAnimation {
                                target: persActiveFrame7
                                property: "opacity"
                                from: 1.0
                                to: 0.7
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            running: true
                            loops: Animation.Infinite
                        }
                    }


                    /////////////////////// PERS 8
                    Item {
                        width: parent.width/4
                        height: parent.width/4
                        Image {
                            id: persActiveFrame8
                            width: parent.width
                            height: parent.width
                            source: "qrc:/res/res/frame_active.png"
                            visible: false
                        }
                        Image {
                            id: persFrame8
                            width: parent.width
                            height: parent.width
                            anchors.left: persActiveFrame8.left
                            anchors.top: persActiveFrame8.top
                            source: "qrc:/res/res/frame.png"
                            Image {
                                id: pers8
                                objectName: "Pers8"
                                width: parent.width
                                height: parent.height
                                scale: 0.85
                                source: "qrc:/res/res/pers8.png"
                                anchors.centerIn: parent
                            }
                        }
                        MouseArea {
                            anchors.fill: persActiveFrame8
                            onPressed: {
                                soundPickPers.play()
                                player1Input.text = pers8.objectName
                                gridPlayers.playerAvatar = pers8.source
                                persActiveFrame8.visible = true
                                persActiveFrame1.visible = false
                                persActiveFrame2.visible = false
                                persActiveFrame3.visible = false
                                persActiveFrame4.visible = false
                                persActiveFrame5.visible = false
                                persActiveFrame6.visible = false
                                persActiveFrame7.visible = false
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: persActiveFrame8
                                property: "scale"
                                from: 1.1
                                to: 0.9
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            NumberAnimation {
                                target: persActiveFrame8
                                property: "opacity"
                                from: 1.0
                                to: 0.7
                                duration: 1700
                                easing.type: Easing.InOutSine
                            }
                            running: true
                            loops: Animation.Infinite
                        }
                    }
                }

                //////////////////////////////////////  GRID END  //////////////////////////////////////

                Item {
                    width: parent.width/4
                    height: parent.height/12
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        id: uiSelectNamePlayer
                        font.pixelSize: 24
                        color: "#DFDFDF"
                        text: "(Change Character's Name)"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Item {
                    width: parent.width/2
                    height: parent.height/12
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        width: parent.width
                        height: parent.height/2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.margins: 7
                        radius: 5
                        color: "orange"
                        TextInput {
                            id: player1Input
                            font.pixelSize: 24
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.margins: 7
                            color: "#DFDFDF"
                            text: pers1.objectName
                        }
                    }
                }

                Item {
                    width: parent.width/3
                    height: parent.height/6
                    anchors.horizontalCenter: parent.horizontalCenter
                    Button {
                        id: confirmPlayer
                        objectName: "confirmPlayer"
                        width: parent.width
                        height: parent.height/2
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "To Second Player"
                        property bool isFirst: true
                        signal startGame()
                        onClicked: {
                            soundButton.play()
                            mainMenu.visible = false;
                            if (isFirst === true) {
                                uiSelectAvatarPlayer.text = "Choose Second Character"
                                uiSelectNamePlayer.text = "(Change Name)"
                                confirmPlayer.text = "PLAY"
                                if (player1Input.text != "") {
                                    if (player1Input.text.length > 12) {
                                        player1Input.text = player1Input.text.substring(0, 12)
                                    }
                                    player1Name.text = player1Input.text
                                    player1pic.source = gridPlayers.playerAvatar;
                                }
                            }
                            else {
                                uiSelectAvatarPlayer.text = "Choose Frist Player Character"
                                uiSelectNamePlayer.text = "(Change Name)"
                                confirmPlayer.text = "NEXT"
                                if (player1Input.text != "") {
                                    if (player1Input.text.length > 12) {
                                        player1Input.text = player1Input.text.substring(0, 12)
                                    }
                                    player2Name.text = player1Input.text
                                    player2pic.source = gridPlayers.playerAvatar;
                                    selectPlayer.visible = false;

                                    // Start Game
                                    soundGame.play();
                                    boardImage.visible = true;
                                    timeText.text = "00:00";
                                    container.time = 0
                                    timer.restart()

                                    //////////////////// TEST //////////////////////////
                                    if (informator.isTestMode() === true) {
                                        var white_items = [228, 230, 235, 241, 243, 244, 245, 248, 249, 254, 255, 256, 257, 258, 259]
                                        var black_items = [0,   1,   2,   3,   4,   5,   9,   10,  16,  17,  18,  23,  29,  31,  44]
                                        for (var i=0; i<15; i++) {
                                            blackRepeater.itemAt(i).parent = gridRepeater.itemAt(black_items[i])
                                            blackRepeater.itemAt(i).anchors.centerIn = gridRepeater.itemAt(black_items[i])
                                            blackRepeater.itemAt(i).cid = black_items[i]
                                            whiteRepeater.itemAt(i).parent = gridRepeater.itemAt(white_items[i])
                                            whiteRepeater.itemAt(i).anchors.centerIn = gridRepeater.itemAt(white_items[i])
                                            whiteRepeater.itemAt(i).cid = white_items[i]
                                            // !!! anchors.centerIn: parent
                                        }
                                    }
                                    ////////////////////////////////////////////////////

                                    startGame()
                                }
                            }
                            isFirst = !isFirst;
                        }
                    }
                }
            }
        }

        // Winner Frame
        Image {
            id: winnerWindow
            objectName: "winnerWindow"
            width: container.width
            height: container.height
            source: "qrc:/res/res/bg_winner.png"
            visible: false
            Text {
                id: winnerName
                font.pixelSize: 56
                width: container.width/2
                height: 0.039*container.height
                color: "#eedcdc"
                horizontalAlignment: Text.AlignHCenter
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 0.232*container.height
                onVisibleChanged: {
                    if (visible === true) {
                        soundWinner.play();
                        winnerName.text = (zyara_p1.visible === true) ? player1Name.text : player2Name.text
                    }
                }
            }
            Image {
                id: winnerAvatar
                width: parent.width/2.7
                height: parent.width/2.7
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 150
                onVisibleChanged: {
                    if (visible === true) {
                        winnerAvatar.source = (zyara_p1.visible === true) ? player1pic.source : player2pic.source
                        animAvatarWinner.running = true;
                        meatForWinner.running = true;
                    }
                }
            }
            ParallelAnimation {
                id: animAvatarWinner
                NumberAnimation {
                    targets: [winnerAvatar, winnerName]
                    property: "scale"
                    easing.period: 0.26
                    from: 2.5
                    to: 1.0
                    duration: 1200
                    easing.type: Easing.InOutQuart
                }
                NumberAnimation {
                    targets: [winnerAvatar, winnerName]
                    property: "opacity"
                    easing.overshoot: 5
                    from: 0.0
                    to: 1.0
                    duration: 1200
                    easing.type: Easing.InOutQuad
                }
                running: false
            }
            Button {
                id: menuButFromWin
                width: container.width/3
                height: container.height/12
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 200
                text: "GO TO MENU"
                onPressed: {
                    soundButton.play()
                    if (soundWinner.playing === true) {
                        soundWinner.stop();
                    }

                    winnerWindow.visible = false;
                    mainMenu.visible = true
                }
            }

            // Particale Animation
            ParticleSystem {
                id: meatForWinner
                anchors.fill: parent
                running: false;
                ImageParticle {
                    source: "qrc:/res/res/meat.png"
                    rotation: 180
                    rotationVariation: 90
                    rotationVelocity: 45
                    rotationVelocityVariation: 30
                }
                Wander {
                    pace: 2
                    xVariance: 200
                    yVariance: 200
                }
                Emitter {
                    width: parent.width
                    height: parent.height
                    lifeSpan: 3000
                    sizeVariation: 16
                    size: 200
                    endSize: 20
                    emitRate: 3
                    velocity: AngleDirection {
                        angle: 270
                        angleVariation: Math.round(360*Math.random())
                        magnitude: 50
                        magnitudeVariation: 50
                    }
                }
            }
        }

        Image {
            id: intro4
            objectName: "intro4"
            width: parent.width
            height: parent.height
            source: "qrc:/res/res/intro4.png"
            opacity: 0.0
            onOpacityChanged: {
                if (opacity > 0.3) {
                    soundIntro4.play();
                }
            }
        }
        Text {
            id: remainText
            text: "lite Version"
            color: "#f1cc67"
            font.family: "Segoe Script"
            font.pixelSize: 36
            x: eChar.x + eChar.width
            y: parent.height/8
            opacity: 0.0
        }
        Text {
            id: eChar
            text: "E"
            color: "#f1cc67"
            font.family: "Segoe Script"
            font.pixelSize: 36
            x: parent.width/2 - remainText.width/2
            y: parent.height/8
            opacity: 0.0
            onOpacityChanged: {
                if (opacity == 1.0) {
                    transformOrigin = Item.BottomLeft
                    soundCrack.play();
                }
            }
            onYChanged: {
                if (y > (container.height-container.height/2)) {
                    soundGlass.play();
                    eChar.visible = false;
                    remainText.visible = false;
                }
            }
        }
        Image {
            id: intro3
            objectName: "intro3"
            width: parent.width
            height: parent.height
            source: "qrc:/res/res/intro3.png"
            opacity: 0.0
            onOpacityChanged: {
                if (opacity === 1.0) {
                    soundIntro3.play();
                }
            }
        }
        Image {
            id: intro2
            objectName: "intro2"
            width: parent.width
            height: parent.height
            source: "qrc:/res/res/intro2.png"
            opacity: 0.0
            onOpacityChanged: {
                if (opacity === 1.0) {
                    soundIntro2.play();
                }
            }
        }
        Image {
            id: intro1
            objectName: "intro1"
            width: parent.width
            height: parent.height
            source: "qrc:/res/res/intro1.png"
            opacity: 0.0
            onOpacityChanged: {
                if (opacity === 1.0) {
                    soundIntro1.play();
                }
            }
        }

        SequentialAnimation {
            id: animIntro
            objectName: "animIntro"
            running: false
            onRunningChanged: {
                if (running === true) {
                    soundIntro1.play();
                }
            }

            NumberAnimation {
                target: intro1
                duration: interval
                easing.type: Easing.InOutQuad
                from: 0.0
                to: 1.0
                properties: "opacity"
            }
            PauseAnimation {
                duration: interval
            }
            NumberAnimation {
                target: intro1
                duration: interval
                easing.type: Easing.InOutQuad
                from: 1.0
                to: 0.0
                properties: "opacity"
            }

            NumberAnimation {
                target: intro2
                duration: interval
                easing.type: Easing.InOutQuad
                from: 0.0
                to: 1.0
                properties: "opacity"
            }
            PauseAnimation {
                duration: interval
            }
            NumberAnimation {
                target: intro2
                duration: interval
                easing.type: Easing.InOutQuad
                from: 1.0
                to: 0.0
                properties: "opacity"
            }

            NumberAnimation {
                target: intro3
                duration: interval
                easing.type: Easing.InOutQuad
                from: 0.0
                to: 1.0
                properties: "opacity"
            }
            PauseAnimation {
                duration: interval
            }
            NumberAnimation {
                target: intro3
                duration: interval
                easing.type: Easing.InOutQuad
                from: 1.0
                to: 0.0
                properties: "opacity"
            }

            NumberAnimation {
                target: intro4
                duration: interval
                easing.type: Easing.InOutQuad
                from: 0.0
                to: 1.0
                properties: "opacity"
            }
            PauseAnimation {
                duration: interval*1.2
            }
            ParallelAnimation {
                NumberAnimation {
                    target: eChar
                    duration: 300
                    easing.type: Easing.InOutQuad
                    from: 0.0
                    to: 1.0
                    properties: "opacity"
                }
                NumberAnimation {
                    target: remainText
                    duration: 300
                    easing.type: Easing.InOutQuad
                    from: 0.0
                    to: 1.0
                    properties: "opacity"
                }
            }
            PauseAnimation {
                duration: 1000
            }
            SequentialAnimation {
                RotationAnimation {
                    target: eChar
                    from: 0
                    to: 180
                    direction: RotationAnimation.Counterclockwise
                    duration: 500
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    target: eChar
                    property: "y"
                    from: container.height/8
                    to: container.height + container.height/2
                    duration: 520
                    easing.type: Easing.InQuart
                }
            }
            PauseAnimation {
                duration: 1000
            }
            onFinished: {
                intro4.opacity = 0.0
                mainMenu.visible = true
                boardImage.visible = true
            }
        }
    }
}
