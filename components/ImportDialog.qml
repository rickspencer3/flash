import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Content 1.1

Dialog {
    id: importDialog
    property var activeTransfer
    property var importedDoc
    signal cardsImported(string setName)

    title: "Import Cards"
    Column{
        height: mainView.height
        width: mainView.width
            Connections {
                target: activeTransfer
                onStateChanged:{
                     if(activeTransfer.state === ContentTransfer.Charged) {
                        importedDoc = activeTransfer.items[0]
                        peerPicker.visible = false
                        fileParseProgressBar.visible = true
                         fileParseProgressBar.uri = importedDoc.url
                    }
                }
            }
             ContentPeerPicker {
                            id: peerPicker
                            visible: true

                            // Type of handler: Source, Destination, or Share
                            handler: ContentHandler.Source

                            // well know content type
                            contentType: ContentType.All

                            onPeerSelected: {
                                peer.selectionType = ContentTransfer.Single
                                activeTransfer = peer.request();
                            }
                            onCancelPressed: {
                                PopupUtils.close(importDialog)
                            }
                        }
         }
         ProgressBar{
             id: fileParseProgressBar

             property string uri: ""

             indeterminate: false
             minimumValue: 0
             value: 0
             onUriChanged: {
                 if(uri === "")return
                 var ds = uri.split("/")
                 var setName = ds[ds.length-1]
                 var req = new XMLHttpRequest();

                 req.open("GET", uri, true);
                 req.send(null);

                 req.onreadystatechange = function(){

                     if (req.readyState == 4)
                     {
                         try{
                             var lines = req.responseText.split("\n")
                             maximumValue = lines.length

                             for(var line in lines){
                                 var front_back = lines[line].split(":")
                                 value += 1
                                 if(front_back.length > 1) {
                                     cardsDatabase.addCardBySetName(setName,front_back[0],front_back[1])
                                 }
                             }
                         }
                         catch(err){print(err) }
                      };
                     PopupUtils.close(importDialog)
                     cardsImported(setName)
                 }
             }

             width: parent.width
             visible: false
         }
}

