import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Content 1.1
import Ubuntu.Components.Popups 1.0


/*!
    \brief MainView with a Label and Button elements.
*/

Page {
    title: i18n.tr("Card Sets")
    head.actions: [
        Action {
            text: i18n.tr("Add New")
            onTriggered: {
                var nDiag = PopupUtils.open(Qt.resolvedUrl("NewSetDialog.qml"))
            }

            iconName: "add"
        }
        ,
        Action {
            text: i18n.tr("Import")
            onTriggered: {
                var iDiag = PopupUtils.open(Qt.resolvedUrl("ImportDialog.qml"))
                iDiag.cardsImported.connect(refreshItem)
            }
            
            iconSource: Qt.resolvedUrl("../assets/import-icon")
        },
        Action {
            text: i18n.tr("Help")
            onTriggered: {
                Qt.openUrlExternally(i18n.tr("https://wiki.ubuntu.com/RickSpencer/Flash"))
            }

            iconName: "help"
        }
    ]


    UbuntuListView{
        id: setsListView
        anchors.fill: parent
        objectName: "setsList"
        model:cardsDatabase.setNames

        delegate: ListItem.Standard
        {
            property string docId
            property var cards
            property string setName

            text: modelData["name"]
            objectName: index + "o"
            progression: true
            control: Text{
                id: daysText
                text: ""
            }

            removable: true
            confirmRemoval: true

            onItemRemoved: {
                var dDiag = PopupUtils.open(Qt.resolvedUrl("DeleteDialog.qml"),setsListView,{
                                           message: i18n.tr("Do you really want to permamently and irrevocably delete the entire set of cards?")
                                           })
                dDiag.deleteResult.connect(handleSetResult)
                function handleSetResult(result) {
                    if(!result){
                        cancelItemRemoval()
                    }
                    else {
                        cardsDatabase.deleteSet(docId)
                    }
                }
            }

            onClicked:
            {
                var rPage = mainStack.push(Qt.resolvedUrl("CardsReviewPage.qml"),{
                                              docId: docId,
                                              cards: cards,
                                              setName: setName
                                              })
                rPage.setChanged.connect(refreshSet)
            }

            WorkerScript {
                id: worker
                source: "setDataWorker.js"
                onMessage: {
                    var days = Math.floor(messageObject.days)

                    var t = ""
                    switch(days) {
                    case -1:
                        t = i18n.tr("Never")
                        break;
                    case 0:
                        t = i18n.tr("Today")
                        break;
                    case 1:
                        t = i18n.tr("Yesterday")
                        break;
                    default:
                        t = days + i18n.tr(" days")
                    }
                    daysText.text = t
                    if(messageObject.score > .96) {
                        iconSource = "../assets/stars/10.png"
                    }
                    else if(messageObject.score < 0) {
                        iconSource = "../assets/stars/0.png"
                    }

                    else {
                        var sc = Math.floor(messageObject.score * 10)
                        iconSource = "../assets/stars/" + sc + ".png"
                    }

                    cards = messageObject.set["cards"]
                }
            }

            Component.onCompleted: {
                refreshSet()
            }

            function refreshSet() {
                var set = cardsDatabase.getSet(modelData["name"])
                docId = set["docId"]
                setName = set["name"]
                worker.sendMessage({"set":set})
            }
        }
    }
    function refreshItem(setName) {
        for(var i in setsListView.contentItem.children){
            var childItem = setsListView.contentItem.children[i]

            if(childItem.text === setName) {
                childItem.refreshSet()
                break;
            }
        }
    }
}
