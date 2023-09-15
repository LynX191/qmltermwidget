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
    onValueChanged: {
        itemScroll.y = value / totalLines * terminal.height
    }
    anchors.right: terminal.right
    height: terminal.height
    Behavior on opacity {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }
    function showScrollbar() {
        itemScroll.opacity = 1;
        hideTimer.restart();
        itemScroll.y = (terminal.height / (totalLines)) * (value - minimum)
    }
    Rectangle{
        anchors.fill: parent
        color: "transparent"
        Rectangle{
            id: itemScroll
            width: parent.width * 1/2
            height: terminal.height * (lines / (totalLines - minimum))
            anchors.left: parent.left
            anchors.leftMargin: parent.width / 2 - 5
            radius: 15
            color: "white"
            opacity: 1
        }
        MouseArea{
            id: mouseScroll
            anchors.fill: parent
            onMouseYChanged: {
                itemScroll.y = mouseY - itemScroll.height / 2
                if(itemScroll.y < 0) itemScroll.y = 0
                if(itemScroll.y > terminal.height - itemScroll.height) itemScroll.y = terminal.height - itemScroll.height
                terminal.scrollbarCurrentValue = (totalLines - 39)*(mouseY - itemScroll.height / 2) / (terminal.height - itemScroll.height)
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
            itemScroll.opacity = 0.5
        }
    }
}
