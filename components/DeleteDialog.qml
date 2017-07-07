import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0

Dialog {
    id: deleteDialog
    property string message
    signal deleteResult(bool result)

    title: i18n.tr("Confirm Delete")
        Column {
            spacing: units.gu(2)
            Label {
                width: parent.width
                text: message
                wrapMode: Text.Wrap
            }

            Row {
                spacing: units.gu(2)

                Button {
                    text: i18n.tr("Delete")

                    onTriggered: {
                        PopupUtils.close(deleteDialog)
                        deleteResult(true)
                    }
                }
                Button {
                    text: i18n.tr("Cancel")
                    onTriggered: {
                        PopupUtils.close(deleteDialog)
                        deleteResult(false)
                    }
                }
            }
        }
        CardsDatabase {
            id: cardsDatabase
        }
}

