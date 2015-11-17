var $hours = $("#timeSelect select").first();
var $amPm = $("#am_pm")
var pstTime = hoursToPST($hours.val());

$hours.val(pstTime.hour);
$amPm.val(pstTime.amPm);
// CHANGE RANGE OF STUFF

$("#newAppointment").on("submit", function (event) {
  var $hours = $("#timeSelect select").first();
  var $amPm = $("#am_pm");

  var utcTime = backToUTC($hours.val(), $amPm.val());
  debugger;
});

function hoursToPST(hour) {
  var amPm = "AM";
  var hour = parseInt(hour);

  if (hour < 8) {
    hour += 16;
    amPm = "PM";
  } else {
    hour -= 8; 
  }
  
  if (hour >= 13)
    hour -= 12;

  hour = hour.toString();
  if (hour.length < 2)
    hour = "0" + hour;

  return {hour: hour, amPm: amPm};
}


function backToUTC(hour, amPm) {
  var hour = parseInt(hour);
  if (amPm === "AM" && hour < 4) {
    return {hour: hour + 8, amPm: amPm};
  } else if (amPm === "AM" && hour < 5) {
    return {hour: hour + 8, amPm: "PM"};
  } else if (amPm === "AM" && hour == 12) {
    return {hour: hour - 4, amPm: "AM"};
  } else if (amPm === "AM" && hour >= 5) {
    return {hour: hour - 4, amPm: "PM"};
  } else if (amPm === "PM" && hour == 12) {
    return {hour: hour - 4, amPm: "PM"};
  } else if (amPm === "PM" && hour < 4) {
    return {hour: hour + 8, amPm: "PM"};
  } else {
    return {hour: hour - 4, amPm: "AM"};
  }
}

var hourOptions = [1,2,3,4,5,6,7,8,9,10,11,12];
var amPms = ["AM","PM"];
amPms.forEach(function (amPm) {
  hourOptions.forEach(function (hour) {
    console.log(hour.toString()+" "+amPm, backToUTC(hour, amPm));
  });
});
