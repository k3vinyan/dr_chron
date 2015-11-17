function hoursToPST(hour) {
  var amPm = "AM";

  if (hour < 8) {
    hour += 16;
    amPm = "PM";
  } else {
    hour -= 8; 
  }
  
  if (hour >= 13)
    hour -= 12;

  return {hour: hour, amPm: amPm};
}
