import QtQuick
import Qt5Compat.GraphicalEffects
import CellInfo

DropArea {
    required property int index
    required property string name
    required property string path

    width: container.width/15
    height: container.width/15

    Image {
        id: dropCell
        anchors.fill: parent
        source: path
    }
}
