import QtQuick 2.9
import QMLTermWidget 1.0

Item {
    id: terminalScrollbar
    property QMLTermWidget terminal
    property int value: terminal.scrollbarCurrentValue
    property int minimum: terminal.scrollbarMinimum
    property int maximum: terminal.scrollbarMaximum
    property int lines: terminal.lines
    property int totalLines: lines + maximum

    anchors.right: terminal.right

    opacity: 1

    height: terminal.height //* (lines / (totalLines - minimum))
//    y: (terminal.height / (totalLines)) * (value - minimum)

    Behavior on opacity {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }
    function showScrollbar() {
        opacity = 1.0;
        hideTimer.restart();
    }
    Rectangle{
        anchors.fill: parent
        Rectangle{
            id: itemScroll
            width: parent.width * 2/3
            height: terminal.height * (lines / (totalLines - minimum))
            y: (terminal.height / (totalLines)) * (value - minimum)
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 15
        }

        color: "transparent"
        MouseArea{
            id: mouseScroll
            anchors.fill: parent
            onMouseYChanged: {
                itemScroll.y = mouseY - itemScroll.height / 2
                if(itemScroll.y < 0) itemScroll.y = 0
                if(itemScroll.y > terminal.height - itemScroll.height) itemScroll.y = terminal.height - itemScroll.height
                terminal.scrollbarCurrentValue = (totalLines - 39)*(mouseY - itemScroll.height / 2) / (terminal.height - itemScroll.height)
                return
            }
        }
    }

    Connections {
        target: terminal
        onScrollbarValueChanged: showScrollbar()
    }

    Timer {
        id: hideTimer
        onTriggered: {
            parent.opacity = 1
        }
    }
}
