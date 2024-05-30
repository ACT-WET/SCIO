function wePlayWrapper(){

    //console.log("Filter Pump Schedule script triggered");

    var moment = new Date();
    var current_day = moment.getDay();      //0-6
    var current_hour = moment.getHours();   //0-23
    var current_min = moment.getMinutes();  //0-59
    var current_time = (current_hour*100)+current_min;
    var day_ID = 0;
    var now = moment.getHours()*10000 + moment.getMinutes()*100 + moment.getSeconds();

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

    if ((weeknweekD[current_day] === 0) && (autoMan === 0)){
        presentDayFiller = filler;
        presentDayWePlay = weplay;
        // watchDog.eventLog('Weekend Filler is  :: '+presentDayFiller);
        for (let i = 0; i < presentDayFiller.length; i+=2) {
          //watchDog.eventLog('Weekend Filler is  :: '+presentDayFiller[i]);
          if (current_time<presentDayFiller[i]){
            //Do Nothing
            // watchDog.eventLog('current_time is  :: '+current_time);
            // watchDog.eventLog('presentDayFiller[i]  :: '+presentDayFiller[i]);
          } else {
            // watchDog.eventLog('current_time is  :: '+current_time);
            // watchDog.eventLog('presentDayFiller[i]  :: '+presentDayFiller[i]);
            // watchDog.eventLog('presentDayFiller[i+1]  :: '+presentDayFiller[i+1]);

            if (current_time == presentDayFiller[i+1]){
                // when filler show schedule ends issue stopcommand when show is playing
                if (playing == 1){
                    if (stopCmdIssued == 0){
                        watchDog.eventLog("FillerShow Schedule Ends ");
                        stopCmd();
                        stopCmdIssued = 1;
                    } 
                    //change the filler show back to Silent show 1 (show 5) after EOD
                    if (now === 220000){
                       fillerShow.FillerShow_Number = 5;
                    }
                }
            }
            if ((current_time >= presentDayFiller[i]) && (current_time < presentDayFiller[i+1])){
                // at 7:00pm we are changing the filler show to Show 3 (Lights only show) 
                if (now >= 190000){
                   fillerShow.FillerShow_Number = 3;
                }
                if ((fillerShow.FillerShow_Enable == 1) && (playing == 0)){
                    // if (wePlayRunning != 1){
                    //     //Send FillerShow Commands To SGS to Start a Show and break the loop beacuse it will enter this condition every 1 sec adn we dont want to execute this command 60 times 
                    // } else {
                    //     //watchDog.eventLog('Filler Start Time is Ignored as WePlay is Running Current Time is ::    '+current_time); 
                    //     break;
                    // }
                        // when filler show schedule starts issue playcommand when show is not playing
                        if (playCmdIssued == 0){
                            watchDog.eventLog("About to Start Filler Show ");
                            show = fillerShow.FillerShow_Number;
                            startCmd(shows[show].name);
                            watchDog.eventLog('Filler Start Time is ::    '+now);
                            watchDog.eventLog('PlayCommand Issued Was ::    '+playCmdIssued);
                            playCmdIssued = 1;
                            moment1 = moment;   //displays time on iPad
                            timeLastCmnd = now;
                            watchDog.eventLog("FILLER Show: Playing Show number " +show);
                            if (now > 190000){
                               fillerShow.FillerShow_Number = 3;
                            } else {
                               // we are alternating show 4 and 5 to be filler show playing continuosly till end of the schedule.
                               if (fillerShow.FillerShow_Number == 4){
                                fillerShow.FillerShow_Number = 5;
                               } else {
                                fillerShow.FillerShow_Number = 4;
                               }
                            }
                            
                            jumpToStep_manual = 0;
                        }
                }
            }  else {
                //do nothing
            }
          }
        }

        // for (let i = 0; i < presentDayWePlay.length; i+=2) {
        //   if (current_time>presentDayWePlay[i]){
        //     //Do Nothing
        //   } else {
        //     if (current_time == presentDayWePlay[i]){
        //         if (fillerShow.Weplay_Enable == 1){
        //            //Send WePlay Commands To SGS to Start a Show and break the loop beacuse it will enter this condition every 1 sec adn we dont want to execute this command 60 times 
        //            wePlayRunning = 1;
        //            //watchDog.eventLog('WePlay Running Now    '+wePlayRunning);
        //         }
        //     } else {
        //          //watchDog.eventLog('Waiting for WePlay Start Time is :: '+presentDayWePlay[i] + "Current Time is ::  "+current_time); 
        //         //Wait till WePlay Time == Current Time
        //     }
        //     break;
        //   }
        // }

    } else {
        presentDayFiller = wfiller;
        presentDayWePlay = wweplay;
        //watchDog.eventLog('Weekday Filler is  :: '+presentDayFiller);
        //watchDog.eventLog('Weekday WePlay is  :: '+presentDayWePlay);
    }
}

module.exports = wePlayWrapper;