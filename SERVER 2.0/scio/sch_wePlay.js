function wePlayWrapper(){

    //console.log("Filter Pump Schedule script triggered");

    var moment = new Date();
    var current_day = moment.getDay();      //0-6
    var current_hour = moment.getHours();   //0-23
    var current_min = moment.getMinutes();  //0-59
    var current_time = (current_hour*100)+current_min;
    var day_ID = 0;

    var presentDayFiller = 0;
    var presentDayWePlay = 0;
    var showData = fillerShow;
    
    weeknweekD[0] = fillerShow.Sunday;
    weeknweekD[1] = fillerShow.Monday;
    weeknweekD[2] = fillerShow.Tuesday;
    weeknweekD[3] = fillerShow.Wednesday;
    weeknweekD[4] = fillerShow.Thursday;
    weeknweekD[5] = fillerShow.Friday;
    weeknweekD[6] = fillerShow.Saturday;

    // watchDog.eventLog('Today is Weekend   '+weeknweekD);

    // if weeknweekD[current_day] == 1{
    //     watchDog.eventLog('Today is Weekend');
    // } else {
    //     watchDog.eventLog('Today is Weekday');
    // }
}

module.exports = wePlayWrapper;