function appointmentMenu() {
  $(event.target).hide();
  $(event.target).siblings('.appointment').show();
}

function scheduleAppt(patientData) {
  debugger;
  $.ajax({
    url: "https://drchrono.com/api/patients",
    type: "PUT",
    data: "bro"
  });
}
