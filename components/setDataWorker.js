WorkerScript.onMessage = function (message) {
    var set = message.set
    var numCorrect = 0.0
    var numTotal = 0.0
    var daysSinceRun = -1
    var maxTimestamp = -1
    var today = new Date().getTime() / (1000 * 60 * 60 * 24)
    var showAfterDays = 5
    var hideAfterConsecutiveCorrect = 3

    for(var c in set["cards"]) {
        var cardCorrect = 0
        var consecutiveCorrect = 0
        var mostRecentIncorrect = ""
        if(set["cards"][c]["trials"].length === 0) {
            set["cards"][c]["visible"] = true
        }

        if(set["cards"][c]["trials"].length < 1)numTotal += 1
        for(var t in set["cards"][c]["trials"]) {
            var ts = set["cards"][c]["trials"][t]["timestamp"]
            if(set["cards"][c]["trials"][t]["result"]) {            
                numCorrect += 1
                consecutiveCorrect += 1
                cardCorrect += 1
            }
            else {
                consecutiveCorrect = 0
                //assuming that timestamps are always in order
                mostRecentIncorrect = ts
            }
            if(ts > maxTimestamp) maxTimestamp = ts
            numTotal += 1
        }
        set["cards"][c]["streak"] = consecutiveCorrect
        if(set["cards"][c]["trials"].length === 0) {
            set["cards"][c]["rate"] = 0
        }
        else {
            set["cards"][c]["rate"] = cardCorrect / set["cards"][c]["trials"].length
        }

        if(set["cards"][c]["trials"].length > 0){
            set["cards"][c]["days"] = today - ( set["cards"][c]["trials"][set["cards"][c]["trials"].length - 1]["timestamp"] / (1000 * 60 * 60 * 24))
        }
        else {
            set["cards"][c]["days"]  = -1
        }

        if((today - (mostRecentIncorrect / (1000 * 60 * 60 * 24)) < showAfterDays) & consecutiveCorrect >= hideAfterConsecutiveCorrect)
        {
            set["cards"][c]["visible"] = false
        }
        else {
            set["cards"][c]["visible"] = true
        }
        //this case is likely only to happen in testing
        if(consecutiveCorrect > 4 & mostRecentIncorrect == "")
        {
            set["cards"][c]["visible"] = false
        }
    }

    if(maxTimestamp > -1) {
        daysSinceRun =  today -(maxTimestamp / (1000 * 60 * 60 * 24))
    }

    var sc = -1
    if(numTotal !== 0) sc = numCorrect/numTotal

    WorkerScript.sendMessage({'score':sc, "days": daysSinceRun, "set": set})
}
