import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0

Dialog {
    id: newSetDialog
    signal setAdded(string setName)

    title: i18n.tr("New Set")
        Column {
            spacing: units.gu(2)

            TextField {
                id: newNameField
                placeholderText: i18n.tr("name the new set")
            }

            Row {
                spacing: units.gu(2)

                Button {
                    text: i18n.tr("Ok")

                    onTriggered: {
                        if(newNameField.text === "")return
                        PopupUtils.close(newSetDialog)
                        cardsDatabase.newSet(newNameField.text)
                        setAdded(newNameField.text)
                    }
                }
                Button {
                    text: i18n.tr("Cancel")
                    onTriggered: {
                        PopupUtils.close(newSetDialog)
                    }
                }
            }
        }
}

