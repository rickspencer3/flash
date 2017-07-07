import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0

Dialog {
    id: runDialog

    width: parent.width
    property var cards
    property var docId
    property var activeCards: []
    property int currentCardIndex: 0
    property var currentCard: cards[activeCards[currentCardIndex]]
    property bool cardsCompleted: false
    signal cardsRun

    onCardsChanged: {
        resetCards(false)
    }

    function resetCards(overrideStats) {
        activeCards = []
        currentCardIndex = 0
        for(var c in cards) {
            if(cards[c]["visible"] | overrideStats) {
                activeCards.push(c)
            }
        }
        cardsCompleted = activeCards.length < 1
        completeBar.value = 0
        currentCardIndex = 0
        currentCard = cards[activeCards[currentCardIndex]]
    }

    title: i18n.tr("Learn")

        Column {
            spacing: units.gu(2)
            width: parent.width

            Label {
                width: parent.width
                visible: cardsCompleted
                wrapMode: Text.Wrap
                text: i18n.tr("Good job! You don't have any cards that you need to practice in this set.")
            }
            Button {
                visible: cardsCompleted
                text: i18n.tr("Practice anyway")
                onClicked: resetCards(true)
            }

            MouseArea
            {
                width: parent.width
                height: units.gu(10)
                visible: !cardsCompleted

                onClicked: {
                    flashCard.flipped = !flashCard.flipped
                }

                Flipable
                {
                    anchors.fill: parent
                    id: flashCard
                    property bool flipped: false

                    front:
                        Rectangle
                        {
                            border.color: "black"
                            anchors.fill: parent
                            anchors.margins: units.gu(1)
                            color: "white"
                            Label
                            {
                                id: frontLabel
                                wrapMode: Text.Wrap
                                anchors.fill: parent
                                anchors.margins: units.gu(1)
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: currentCard["front"]
                            }

                    }
                    back:
                        Rectangle
                        {
                            border.color: "black"
                            anchors.margins: units.gu(1)
                            anchors.fill: parent
                            color: "yellow"
                            Label
                            {
                                id: backLabel
                                wrapMode: Text.Wrap
                                anchors.fill: parent
                                anchors.margins: units.gu(1)
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: currentCard["back"]
                            }
                        }

                    transform: Rotation
                    {
                        id: rotation
                        origin.x: flashCard.width/2
                        origin.y: flashCard.height/2
                        axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                        angle: 0    // the default angle
                    }

                    states: State
                    {
                        name: "back"
                        PropertyChanges { target: rotation; angle: 180 }
                        when: flashCard.flipped
                    }

                    transitions: Transition
                    {
                        NumberAnimation { target: rotation; property: "angle"; duration: 100 }
                    }
                }
            }
            ProgressBar{
                id: completeBar
                width: parent.width
                indeterminate: false
                maximumValue: cards.length
                minimumValue: 0
            }

            Row {
                visible: !cardsCompleted
                spacing: units.gu(2)
                Button {
                    text: i18n.tr("Incorrect")
                    enabled: flashCard.flipped
                    onTriggered: {
                        nextCard(false)
                    }
                }
                Button {
                    text: i18n.tr("Correct")
                    enabled: flashCard.flipped
                    onTriggered: {
                        nextCard(true)
                    }
                }
            }

            Row {
                spacing: units.gu(2)
                Button {
                    text: i18n.tr("Close")
                    onTriggered: {
                        PopupUtils.close(runDialog)
                        cardsRun()
                    }
                }
            }
        }


    function nextCard(correct) {
        if(correct === null) correct = false
        flashCard.flipped = false

        cardsDatabase.addTrial(docId,activeCards[currentCardIndex],correct)

        if(correct) {
            //remove the card from the rotation
            activeCards.splice(currentCardIndex, 1)

            //check if we are done
            if(activeCards.length === 0) {
                cardsCompleted = true
            }

            //if it was the last card, start rotating from the beginning
            if(currentCardIndex >= activeCards.length) currentCardIndex = 0
            completeBar.value = cards.length - activeCards.length
        }
        //if it was the last card, start rotating from the beginning
        else if(currentCardIndex + 1 >= activeCards.length) {
            currentCardIndex = 0
        } //otherwise, go to the next card
        else currentCardIndex += 1

        //set the current card
        currentCard = cards[activeCards[currentCardIndex]]
    }
}

