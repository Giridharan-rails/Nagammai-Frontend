    $(function() {
      $("#btnAdd").bind("click", function() {
        var div = $("<div />");
        div.html(GetDynamicTextBox(""));
        $("#TextBoxContainer").append(div);
      });
      $("#btnGet").bind("click", function() {
        var values =
          $.map($("input[name=DynamicTextBox]"), function(el) {
            return el.value
          }).join(",\n");
        $("#anotherTextbox").val(values);
      });
      $("body").on("click", ".remove", function() {
        $(this).closest("div").remove();
      });
    });

    function GetDynamicTextBox(value) {
      return '<div class="d-flex align-items-center mrgn_add"><select class="form-control field_width"><option value="volvo">07:34 PM</option><option value="saab">9:00 AM</option><option value="mercedes">9:30 AM</option><option value="audi">10:00 AM</option><option value="volvo">10:30 AM</option><option value="saab">11:00 AM</option><option value="mercedes">11:30 AM</option><option value="audi">12:00 PM</option><option value="volvo">12:30 PM</option><option value="saab">01:00 PM</option><option value="mercedes">01:30 PM</option><option value="audi">02:00 PM</option></select>' +
        '<button type="button" class="btn remove btn_pad"> <i class="fa fa-minus-circle pad" aria-hidden="true"></i></button></div>'
    }