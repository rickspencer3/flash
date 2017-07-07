import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Content 1.1
import Ubuntu.Components.Popups 1.0
import "components"

MainView {
    id: mainView
    objectName: "mainView"
    applicationName: "flash.rickspencer3"
    useDeprecatedToolbar: false

    width: units.gu(50)
    height: units.gu(75)
    Component.onCompleted: mainStack.push(Qt.resolvedUrl("components/CardsListPage.qml"))
    PageStack {
        id: mainStack

     }

    CardsDatabase{
        id: cardsDatabase
    }
}

