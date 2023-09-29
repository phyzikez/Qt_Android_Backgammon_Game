import QtQuick
import Qt5Compat.GraphicalEffects
import CellInfo

Item {
    id: root
    required property int index

    property var oldParent
    property string photoPath
    property string name
    property int cid

    signal moved(int i)

    width: parent.width
    height: parent.width

    CellInformator {
        id: cellInformator
    }

    MouseArea {
        id: mouseArea
        width: parent.width
        height: parent.width
        anchors.centerIn: parent
        hoverEnabled: false;

        drag.target: figure

        // Board Edge Limits (Optional)
        /*drag.axis: Drag.XAndYAxis
        drag.minimumX: 0
        drag.minimumY: -figure.width*(5+figureItemBlack.index)
        drag.maximumX: container.width-3*figure.width
        drag.maximumY: (14-figureItemBlack.index)*figure.width*/

        onReleased: {
            if ((cellInformator.get_isAI() === false) ||
                ((cellInformator.get_isAI() === true) &&
                 (cellInformator.isCurrentFigureName("white") === true))) {
                soundMove.play();
                var oldPos = root.cid;
                oldParent = parent

                // Check Valid target Cell
                if (cellInformator.isCurrentFigureName(figure.objectName) === true &&
                    figure.Drag.target !== null &&
                    cellInformator.isTargetValid(oldPos, figure.Drag.target.index) === true) {
                    parent = figure.Drag.target
                    root.cid = parent.index
                    cellInformator.deactivateFirstCurMove();
                }
                else {
                    parent = oldParent
                }

                // Update
                cellInformator.updateCellInfo(oldPos, root.cid);

                // Update Highlights
                var to_s = cellInformator.highlightCell(true).split(',');
                for (var j=0; j<to_s.length; j++) {
                    highlightRepeaterTarget.itemAt(to_s[j]).opacity = (switchHint.checked === true) ? 1.0 : 0.0;
                }
            }
            figure.width = parent.width;
            figure.height = parent.width;
            //console.log(">>>>>>>>>>>>>>>>>>>>>>>>>> [ ON_RELEASED ] FIGURE,  WHO's PARENT IS : " + parent.name)
        }
        onEntered: {
            //console.log(">>>>>>>>>>>>>>>>>>>>>>>>>> [ ON_ENTERED ] FIGURE,  WHO's PARENT IS : " + parent.name)
            figure.width = parent.width*1.2;
            figure.height = parent.width*1.2;
        }

        Image {
            id: figure
            objectName: name
            width: parent.width
            height: parent.width
            source: photoPath
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

            Drag.active: mouseArea.drag.active
            Drag.hotSpot.x: parent.width/2
            Drag.hotSpot.y: parent.width/2

            states:
            State {
                when: mouseArea.drag.active
                AnchorChanges {
                    target: figure
                    anchors {
                        verticalCenter: undefined
                        horizontalCenter: undefined
                    }
                }
            }
        }
    }
}
