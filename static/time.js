var formatDigits = function(num, digits){
    var format = num.toString();
    while(format.length < digits){
        format = '0' + format;
    }
    return format;
}
var months = ["Januar","Februar","März","April","Mai","Juni","July","August","September","Oktober","November"];
var days = ["Sonntag","Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag"]

function getFormatedTime(){
    var time = new Date();
    var h=formatDigits(time.getHours(),2),
    m=formatDigits(time.getMinutes(),2),
    s=formatDigits(time.getSeconds(),2);
    return h+":"+m+":"+s
}
function getFormatedDate(){
    var time = new Date();
    var M=months[time.getMonth()],
    wd=days[time.getDay()],
    d=time.getDate(),
    y=time.getFullYear();
    return wd+" der "+d+". "+M+" "+y
}