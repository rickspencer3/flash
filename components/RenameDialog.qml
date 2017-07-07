import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0

Dialog {
    id: renameDialog

    property string oldName: ""
    property var activeTransfer
    property var importedDoc
    signal renamed (string newName)
    title: "Rename Set"
        Column {
            spacing: units.gu(2)
            Label {
                text:i18n.tr("Rename ") + renameDialog.oldName
            }
            TextField {
                id: newNameField
                placeholderText: i18n.tr("new name")
            }

            Row {
                spacing: units.gu(2)

                Button {
                    text: i18n.tr("Ok")

                    onTriggered: {
                        if(newNameField.text === "")return
                        PopupUtils.close(renameDialog)
                        cardsDatabase.rename(oldName, newNameField.text)
                        renamed(newNameField.text)
                    }
                }
                Button {
                    text: i18n.tr("Cancel")
                    onTriggered: {
                        PopupUtils.close(renameDialog)
                    }
                }
            }
        }    
}

