import QtQuick 2.0
import QtTest 1.0
import Ubuntu.Test 1.0
import "../../"
import "../../components"

// See more details at https://developer.ubuntu.com/api/qml/sdk-14.10/Ubuntu.Test.UbuntuTestCase

// Execute these tests with:
//   qmltestrunner

Item {

    width: units.gu(100)
    height: units.gu(75)

    // The objects
    CardsDatabase {
        id: testDatabase
    }

    UbuntuTestCase {
        name: "MainTestCase"

        when: windowShown

        function cleanupTestCase() {
            /*var docs = testDatabase.listDocs()
            for(var d in docs){
                testDatabase.deleteDoc(docs[d])
            }*/
        }

        function init() {

        }
        function test_clean_import(){
            var testSet = null
            var cardsNum = 0
            var contents = ""
            var location = "cards.txt"
            var req = new XMLHttpRequest();
            req.open("GET", location, true);
            req.send(null);

            req.onreadystatechange = function(){
                if (req.readyState == 4)
                {
                    try{
                        contents = req.responseText
                        var lines = contents.split("\n")
                        for(var line in lines){
                            var front_back = lines[line].split(":")
                            if(front_back.length > 1){
                                testDatabase.addCard("testSet",front_back[0],front_back[1])
                            }
                        }

                        testSet = testDatabase.getSet("testSet")
                        cardsNum = testSet["cards"].length
                    }
                    catch(err){ }
                    compare(cardsNum,3)
                 };
            }
        }

        function test_rename() {
            //add 2 cards with the same set name
            var name1 = "qwerty"
            var name2 = "azerty"

            testDatabase.addCard(name1, "front 1", "back 1")
            testDatabase.addCard(name1, "front 2", "back 2")

            //rename the CardsDatabase
            testDatabase.rename(name1, name2)

            //make sure the cards have the new name, not the old name
            compare(testDatabase.getSet(name1), null, "Cards were not renamed")

            var set = testDatabase.getSet(name2)
            compare(set["cards"].length, 2, "There were not two cards in renamed set")
        }

        function test_sample_exists(){
            //call the database propert to get the test names
            var setNames = testDatabase.setNames

            //look for "Sample Cards" in the setNames list
            var sampleFound = false
            for(var n in setNames) {
                if(setNames[n]["name"] === "Sample Cards") {
                    sampleFound = true
                }
            }

            //assert that Sample Cards were found
            compare(sampleFound,true,"Sample Cards not found");
        }
        function test_add_unsuccesful_trial(){
            //get a set
            var testSet = testDatabase.getSet("Sample Cards")

            //get the first card in the set
            var testCard = testSet["cards"][0]

            //add a trial
            var timeStamp = new Date().toString()
            print(timeStamp)
            var correctness = false
            //testCard.addTrial(timeStamp, correctness)

            //get a list of trials for the card
            compare(0,0,"should fail")
        }
    }
}


