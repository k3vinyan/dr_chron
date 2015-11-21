$("#showPatientUpdate").on("click", function (event) {
  $(event.target).hide();
  $("#patientUpdate").show();
});

$("#advancedFormBtn").on("click", function (event) {
  event.preventDefault();
  $(event.target).hide();
  $("#advancedForm").show();
  $("#basicFormBtn").show();
});

$("#basicFormBtn").on("click", function (event) {
  event.preventDefault();
  $(event.target).hide();
  $("#advancedForm").hide();
  $("#advancedFormBtn").show();
});
