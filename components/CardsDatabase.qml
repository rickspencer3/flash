import QtQuick 2.0
import U1db 1.0 as U1db

Item {
    property var setNames: namesQuery.results

    function addCardByDocId(docId, front, back) {
        var setDoc = cardsDatabase.getDoc(docId)
        setDoc["cards"].push({"front":front,"back":back,"trials":[]})
        cardsDatabase.putDoc(setDoc, docId)
    }
    function deleteSet(docId){
        cardsDatabase.deleteDoc(docId)
    }
    function deleteCard(docId, index){
        var doc = cardsDatabase.getDoc(docId)
        doc["cards"].splice(index, 1)
        cardsDatabase.putDoc(doc, docId)
    }

    function addCardBySetName(setName, front, back){
        var setDocId = ""
        var docs = cardsDatabase.listDocs()
        for(var d in docs){
            var doc = cardsDatabase.getDoc(docs[d])
            if(doc["name"] === setName){
                setDocId = docs[d]
                break
            }
        }
        if(setDocId === ""){
            setDocId = "d" + Math.random() * 1000000
            var docString = "import QtQuick 2.0; import U1db 1.0 as U1db;U1db.Document{database: cardsDatabase;docId:'{{{docId}}}';create: true;defaults:{'name':'{{{name}}}','cards':[]}}"
            docString = docString.replace("{{{name}}}",setName)
            docString = docString.replace('{{{docId}}}',setDocId)
            Qt.createQmlObject(docString,cardsDatabase)
        }
        var setDoc = getSet(setName)
        setDoc["cards"].push({"front":front,"back":back,"trials":[]})
        cardsDatabase.putDoc(setDoc, setDocId)
    }
    
    function createEmptySet(setName) {
        var setDocId = "d" + Math.random() * 1000000
        var docString = "import QtQuick 2.0; import U1db 1.0 as U1db;U1db.Document{database: cardsDatabase;docId:'{{{docId}}}';create: true;defaults:{'name':'{{{name}}}','cards':[]}}"
        docString = docString.replace("{{{name}}}",setName)
        docString = docString.replace('{{{docId}}}',setDocId)
        Qt.createQmlObject(docString,cardsDatabase)
        return setDocId;
    }

    function newSet(setName) {
        if(getSet(setName) === null){
            createEmptySet(setName)
        }
    }

    function getSet(setName) {
        var docs = cardsDatabase.listDocs()
        for(var d in docs){
            var doc = cardsDatabase.getDoc(docs[d])

            if(doc["name"] === setName){
                doc["docId"] = docs[d]
                return doc
            }
        }
        return null
    }


    function addTrial(docId, cardIndex, correct) {
        var doc = cardsDatabase.getDoc(docId)
        var timestamp = new Date().getTime()
        if(!doc["cards"][cardIndex]["trials"]) {
            doc["cards"][cardIndex]["trials"] = []
        }

        doc["cards"][cardIndex]["trials"].push({"timestamp":timestamp,"result":correct})
        cardsDatabase.putDoc(doc, docId)
    }

    function editCard(docId, index, front, back) {
        var doc = cardsDatabase.getDoc(docId)
        doc["cards"][index]["front"] = front
        doc["cards"][index]["back"] = back
        cardsDatabase.putDoc(doc, docId)
    }

    function rename(oldName, newName) {
        var set = getSet(oldName)
        set["name"] = newName
        
        cardsDatabase.putDoc(set, set["docId"])
    }


    U1db.Database{
        id: cardsDatabase
        path: "cardsDatabase"
    }
    U1db.Index
    {
        database: cardsDatabase
        id: namesIndex
        expression: ["name"]
    }
    U1db.Query
    {
        id: namesQuery
        index: namesIndex
    }
    U1db.Document{
         database: cardsDatabase
         docId: "sampleCards"
         create: true
         defaults: {
             "name": "Sample Cards",
             "cards": [{
                      "front":"1 + 1",
                      "back":"2",
                      "trials": []
                  },{
                       "front":"2 + 2",
                       "back":"4",
                        "trials": []
                  },{
                       "front":"3 + 3",
                       "back":"6",
                       "trials": []
                  },{
                       "front":"4 + 4",
                       "back":"8",
                        "trials": []
                   },{
                      "front":"5 + 5",
                      "back":"10",
                       "trials": []
                 }
             ]
         }
     }
}
