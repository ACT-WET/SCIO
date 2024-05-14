function wePlayWrapper(){

    //console.log("Filter Pump Schedule script triggered");

    var moment = new Date();
    var current_day = moment.getDay();      //0-6
    var current_hour = moment.getHours();   //0-23
    var current_min = moment.getMinutes();  //0-59
    var current_time = (current_hour*100)+current_min;
    var day_ID = 0;

    var presentDayFiller = filler;
    var presentDayWePlay = weplay;
    var showData = fillerShow;
    var presentStartTimeFillerArr = [];
    var presentStartTimeWeplayArr = [];
    var presentEndTimeFillerArr   = [];
    var presentEndTimeWeplayArr   = [];
    
    weeknweekD[0] = fillerShow.Sunday;
    weeknweekD[1] = fillerShow.Monday;
    weeknweekD[2] = fillerShow.Tuesday;
    weeknweekD[3] = fillerShow.Wednesday;
    weeknweekD[4] = fillerShow.Thursday;
    weeknweekD[5] = fillerShow.Friday;
    weeknweekD[6] = fillerShow.Saturday;

    current_day = Number(current_day);

    //watchDog.eventLog('Today is Weekend   '+weeknweekD[current_day]);

    if (weeknweekD[current_day] === 0){
        presentDayFiller = filler;
        presentDayWePlay = weplay;
        //watchDog.eventLog('Weekend Filler is  :: '+presentDayFiller);
        //watchDog.eventLog('Weekend WePlay is  :: '+presentDayWePlay);
        for (let i = 0; i < presentDayFiller.length; i+=2) {
          if (current_time>presentDayFiller[i]){
            //Do Nothing
          } else {
            if (current_time == presentDayFiller[i]){
                if (fillerShow.FillerShow_Enable == 1){
                    if (wePlayRunning != 1){
                        //Send FillerShow Commands To SGS to Start a Show and break the loop beacuse it will enter this condition every 1 sec adn we dont want to execute this command 60 times 
                    } else {
                        //watchDog.eventLog('Filler Start Time is Ignored as WePlay is Running Current Time is ::    '+current_time); 
                        break;
                    }
                   
                   //WePlay takes precedence over FillerShow. So if weplay is running dont send comands
                }
            } else {
                 //watchDog.eventLog('Waiting for Filler Start Time is :: '+presentDayFiller[i] + "Current Time is ::  "+current_time); 
                //Wait till FillerShow Time == Current Time
            }
            break;
          }
        }

        for (let i = 0; i < presentDayWePlay.length; i+=2) {
          if (current_time>presentDayWePlay[i]){
            //Do Nothing
          } else {
            if (current_time == presentDayWePlay[i]){
                if (fillerShow.Weplay_Enable == 1){
                   //Send WePlay Commands To SGS to Start a Show and break the loop beacuse it will enter this condition every 1 sec adn we dont want to execute this command 60 times 
                   wePlayRunning = 1;
                   //watchDog.eventLog('WePlay Running Now    '+wePlayRunning);
                }
            } else {
                 //watchDog.eventLog('Waiting for WePlay Start Time is :: '+presentDayWePlay[i] + "Current Time is ::  "+current_time); 
                //Wait till WePlay Time == Current Time
            }
            break;
          }
        }

    } else {
        presentDayFiller = wfiller;
        presentDayWePlay = wweplay;
        //watchDog.eventLog('Weekday Filler is  :: '+presentDayFiller);
        //watchDog.eventLog('Weekday WePlay is  :: '+presentDayWePlay);
    }
}

module.exports = wePlayWrapper;