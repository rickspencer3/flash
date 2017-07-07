import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Content 1.1
import Ubuntu.Components.Popups 1.0

Page {
    id: cardsReviewPage
    property var docId
    property var cards
    property string setName
    signal setChanged

    title: setName
    head.actions: [
        Action {
            text: i18n.tr("Run")
            onTriggered: {
                var rDiag = PopupUtils.open(Qt.resolvedUrl("RunDialog.qml"),cardsReviewPage, {
                                               docId: docId,
                                                cards:cards
                                               })
                rDiag.cardsRun.connect(function(){
                    setChanged()
                    mainStack.pop()}
                )
            }
            iconName: "media-playback-start"
        },
        Action {
            text: i18n.tr("Add Card")
            onTriggered: {
                var aDiag = PopupUtils.open(Qt.resolvedUrl("NewCardDialog.qml"),cardsReviewPage,{
                                docId: docId })
                aDiag.cardAdded.connect(newCard)
            }

            iconName: "add"
        },
        Action {
            text: i18n.tr("Rename Set")
            onTriggered: {
                var reDiag = PopupUtils.open(Qt.resolvedUrl("RenameDialog.qml"),cardsReviewPage, {
                                               oldName: setName})
                reDiag.renamed.connect(renamed)
            }
            iconSource: Qt.resolvedUrl("../assets/rename.png")
        }
    ]

    function renamed(newName) {
        title = newName
    }

    function updateCard(cardIndex, front, back){
        var newModel = cardsListView.model
        newModel[cardIndex]["front"] = front
        newModel[cardIndex]["back"] = back
        setChanged()
    }
    function newCard(front, back) {
        var newModel = cardsListView.model
        var card = {"front": front, "back":back}
        newModel.push(card)
        cardsListView.model = newModel
        setChanged()
    }

    UbuntuListView{
        id: cardsListView
        model: cards
        anchors.fill: parent
        spacing: units.gu(2)

        delegate: ListItem.Empty {
            height: units.gu(20)
            width: parent.width

            removable: true
            confirmRemoval: true

            onItemRemoved: {
                var diag2 = PopupUtils.open(Qt.resolvedUrl("DeleteDialog.qml"),cardsListView,{
                                           message: i18n.tr("Do you really want to permamently and irrevocably delete this card?")
                                           })
                diag2.deleteResult.connect(handleCardResult)
                function handleCardResult(result) {
                    if(!result){
                        cancelItemRemoval()
                        //reset the height to make the row re-appear
                        height = units.gu(20)
                    }
                    else {
                        cardsDatabase.deleteCard(docId,index)
                        setChanged()
                        var newModel = cardsListView.model
                        newModel.splice(index,1)
                        cardsListView.model = newModel
                    }
                }
            }

            Row {
                width: parent.width
                spacing: units.gu(1)
                Rectangle {
                    id: frontRect
                    border.color: "black"
                    width: parent.width / 3
                    height: units.gu(20)
                    MouseArea{
                        anchors.centerIn: parent
                        height: childrenRect.height
                        width: childrenRect.width
                        Label {
                            height: units.gu(15)
                            width:frontRect.width - units.gu(5)
                            wrapMode: Text.Wrap
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: modelData["front"]
                        }
                        onClicked: editCard()
                    }
                }
                Rectangle {
                    id: backRect
                    border.color: "black"
                    width: parent.width / 3
                    height: units.gu(20)
                    MouseArea{
                        anchors.centerIn: parent
                        height: childrenRect.height
                        width: childrenRect.width
                        Label {
                            height: units.gu(15)
                            width:backRect.width - units.gu(5)
                            wrapMode: Text.Wrap
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: modelData["back"]
                        }
                        onClicked: editCard()
                    }
                }
                Rectangle {
                    id: statsRects
                    border.color: "black"
                    width: parent.width / 3
                    height: units.gu(20)
                    Column {

                        anchors.centerIn: parent
                        height: childrenRect.height
                        width: childrenRect.width
                        Label {
                                horizontalAlignment: Text.AlignHCenter
                                text: i18n.tr("Stats")
                                font.underline: true
                         }
                        Label {
                                horizontalAlignment: Text.AlignHCenter
                                visible: modelData["streak"] !== undefined
                                text: i18n.tr("Streak: ") + modelData["streak"]
                         }

                        Label {
                                horizontalAlignment: Text.AlignHCenter
                                visible: modelData["trials"] !== undefined
                                text: {
                                    if(modelData["trials"] === undefined) return ""
                                    if(!modelData["trials"])modelData["trials"] = 0
                                    i18n.tr("Trials: ") + modelData["trials"].length
                                }
                         }
                        Label {
                                horizontalAlignment: Text.AlignHCenter
                                visible: modelData["rate"] !== undefined
                                text: {
                                    if(modelData["rate"] === undefined) return ""
                                    i18n.tr("Rate: ") + Math.floor(modelData["rate"] * 100) + "%"
                                }
                         }
                        Label {
                                wrapMode: Text.Wrap
                                width:statsRects.width - units.gu(1)
                                visible: modelData["days"] !== undefined
                                text: {
                                    if(modelData["days"] <= 0){
                                            return i18n.tr("Seen: Never")
                                        }
                                    if(modelData["days"] <= 1){
                                            return i18n.tr("Seen: Today")
                                        }
                                    else if(modelData["days"] <= 2){
                                            return i18n.tr("Seen: Yesterday")
                                        }
                                    else{
                                        return i18n.tr("Seen: ") + Math.floor(modelData["days"]) + i18n.tr(" days")
                                    }
                                }
                         }
                    }
                }
            }
            function editCard() {
                                var diag = PopupUtils.open(Qt.resolvedUrl("EditDialog.qml"),cardsReviewPage,{
                                                docId: docId,
                                                card: modelData,
                                                index: index})
                                diag.cardEdited.connect(updateCard)
            }
        }
    }
}
