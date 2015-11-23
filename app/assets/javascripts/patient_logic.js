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


$("#patientForm").on("submit", function (event) {
  if ($("#patient_photo").val() !== "") {
    $.ajax({
      type: "POST",
      url: $(event.target).attr("action"),
      data: $(event.target).serialize(),
      dataType: "JSON"
    })

    .success(function (data) {
      console.log("success", data);
      $("#patient_id_photo").val(data["id"]);
      $("#gender_photo").val(data["gender"]);
      $("#dob_photo").val(data["date_of_birth"]);
      $("#photoForm").submit();
    })

    .fail(function (response) {
      console.error("failure", response);
    })

    event.preventDefault();
  }
});
