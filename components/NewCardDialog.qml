import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0

Dialog {
    id: newCardDialog
    property string docId
    signal cardAdded (string front, string back)

    title: i18n.tr("New Card")
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
                        placeholderText: i18n.tr("Front")
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
                        placeholderText: i18n.tr("Back")
                    }
                }
            }


            Row {
                spacing: units.gu(2)

                Button {
                    text: i18n.tr("Ok")
                    enabled: front.text !== "" & back.text !== ""
                    onTriggered: {
                        cardsDatabase.addCardByDocId(docId,front.text,back.text)
                        cardAdded(front.text, back.text)
                        PopupUtils.close(newCardDialog)
                    }
                }
                Button {
                    text: i18n.tr("Cancel")
                    onTriggered: {
                        PopupUtils.close(newCardDialog)
                    }
                }
            }
        }
        CardsDatabase {
            id: cardsDatabase
        }
}

