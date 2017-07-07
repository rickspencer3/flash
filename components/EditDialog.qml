import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0

Dialog {
    id: editDialog
    property var card
    property string docId
    property int index
    signal cardEdited (int index, string front, string back)

    title: "Edit Card"
        Column {
            spacing: units.gu(2)
            Row {
                spacing: units.gu(1)
                height: units.gu(20)
                width: parent.width
                Rectangle {
                    border.color: "black"
                    width: parent.width / 2
                    height: units.gu(20)

                    TextArea{
                        id: front
                        anchors.fill: parent
                        anchors.margins: units.gu(1)
                        width:parent.width
                        text: card["front"]
                    }
                }
                Rectangle {
                    border.color: "black"
                    width: parent.width / 2
                    height: units.gu(20)
                    TextArea {
                        id: back
                        anchors.fill: parent
                        anchors.margins: units.gu(1)
                        width:parent.width
                        text: card["back"]
                    }
                }
            }


            Row {
                spacing: units.gu(2)

                Button {
                    text: i18n.tr("Ok")

                    onTriggered: {
                        cardsDatabase.editCard(docId, index, front.text, back.text)
                        cardEdited(index, front.text, back.text)
                        PopupUtils.close(editDialog)
                    }
                }
                Button {
                    text: i18n.tr("Cancel")
                    onTriggered: {
                        PopupUtils.close(editDialog)
                    }
                }
            }
        }
        CardsDatabase {
            id: cardsDatabase
        }
}

