


// nav-toggle

    $('#sidebarCollapse').on('click', function (e) {
        $('.page').toggleClass('active');
    });

      $('#sidebarCollapse').on('click', function() {
        $('#sidebar').toggleClass('active');
      });


//collapse
      $(document).ready(function () {
        $('.collapse_tbl[aria-controls="collapseExample1"]').click(function (){
            $('.collapse_tbl[aria-controls="collapseExample1"] i').toggleClass("fa-plus-circle fa-minus-circle");
        });        
        $('.collapse_tbl[aria-controls="collapseExample2"]').click(function (){
            $('.collapse_tbl[aria-controls="collapseExample2"] i').toggleClass("fa-minus-circle fa-plus-circle");
        });
      });

//Scroll

      $(document).ready(function () {
        $('.notification_scroll').slimScroll();
      });


//Hide Notifications

      $(document).ready(function () {
        $('#noti_Button').click(function (){
            $('#notifications2').hide();
            $('#notifications1').hide();

            // CHECK IF NOTIFICATION COUNTER IS HIDDEN.
            if (($('#noti_Counter2').is(':hidden')) || ($('#noti_Counter1').is(':hidden'))){
                // CHANGE BACKGROUND COLOR OF THE BUTTON.
                $('#noti_Button2').css('color', '#2e60ad');
                $('#noti_Button1').css('color', '#2e60ad');
            }          
        });
        $('#noti_Button2').click(function (){
            $('#notifications').hide();
            $('#notifications1').hide();

            // CHECK IF NOTIFICATION COUNTER IS HIDDEN.
            if (($('#noti_Counter').is(':hidden')) || ($('#noti_Counter1').is(':hidden'))) {
                // CHANGE BACKGROUND COLOR OF THE BUTTON.
                $('#noti_Button').css('color', '#2e60ad');
                $('#noti_Button1').css('color', '#2e60ad');
            }          
        });

        $('#noti_Button1').click(function (){
            $('#notifications').hide();
            $('#notifications2').hide();

            // CHECK IF NOTIFICATION COUNTER IS HIDDEN.
            if (($('#notifications').is(':hidden')) || ($('#notifications2').is(':hidden'))) {
                // CHANGE BACKGROUND COLOR OF THE BUTTON.
                $('#noti_Button').css('color', '#2e60ad');
                $('#noti_Button2').css('color', '#2e60ad');
            }          
        });

      });


//Notifications(Issues)

    $(document).ready(function () {

        // ANIMATEDLY DISPLAY THE NOTIFICATION COUNTER.
        $('#noti_Counter')
            .css({ opacity: 0 })
             // ADD DYNAMIC VALUE (YOU CAN EXTRACT DATA FROM DATABASE OR XML).
            .css({ top: '-10px' })
            .animate({ top: '-2px', opacity: 1 }, 500);

        $('#noti_Button').click(function () {

            // TOGGLE (SHOW OR HIDE) NOTIFICATION WINDOW.
            $('#notifications').fadeToggle('fast', 'linear', function () {
                if ($('#notifications').is(':hidden')) {
                    $('#noti_Button').css('color', '#2e60ad');
                }
                else $('#noti_Button').css('color', '#fdc006');        // CHANGE BACKGROUND COLOR OF THE BUTTON.
            });

            $('#noti_Counter').fadeOut('slow');                 // HIDE THE COUNTER.

            return false;
        });

        // HIDE NOTIFICATIONS WHEN CLICKED ANYWHERE ON THE PAGE.
        $(document).click(function () {
            $('#notifications').hide();

            // CHECK IF NOTIFICATION COUNTER IS HIDDEN.
            if ($('#notifications').is(':hidden')) {
                // CHANGE BACKGROUND COLOR OF THE BUTTON.
                $('#noti_Button').css('color', '#2e60ad');
            }
        });

        $('#notifications').click(function () {
            return true;       // DO WHEN CONTAINER IS CLICKED.
        });
    });


//Notifications1(Mail)

    $(document).ready(function () {

        // ANIMATEDLY DISPLAY THE NOTIFICATION COUNTER.
        $('#noti_Counter1')
            .css({ opacity: 0 })
             // ADD DYNAMIC VALUE (YOU CAN EXTRACT DATA FROM DATABASE OR XML).
            .css({ top: '-10px' })
            .animate({ top: '-2px', opacity: 1 }, 500);

        $('#noti_Button1').click(function () {

            // TOGGLE (SHOW OR HIDE) NOTIFICATION WINDOW.
            $('#notifications1').fadeToggle('fast', 'linear', function () {
                if ($('#notifications1').is(':hidden')) {
                    $('#noti_Button1').css('color', '#2e60ad');
                }
                else $('#noti_Button1').css('color', '#fdc006');        // CHANGE BACKGROUND COLOR OF THE BUTTON.
            });

            $('#noti_Counter1').fadeOut('slow');                 // HIDE THE COUNTER.

            return false;
        });

        // HIDE NOTIFICATIONS WHEN CLICKED ANYWHERE ON THE PAGE.
        $(document).click(function () {
            $('#notifications1').hide();

            // CHECK IF NOTIFICATION COUNTER IS HIDDEN.
            if ($('#noti_Counter1').is(':hidden')) {
                // CHANGE BACKGROUND COLOR OF THE BUTTON.
                $('#noti_Button1').css('color', '#2e60ad');
            }
        });

        $('#notifications1').click(function () {
            return false;       // DO NOTHING WHEN CONTAINER IS CLICKED.
        });
    });


// Notifications2(Appointments)

    $(document).ready(function () {

        // ANIMATEDLY DISPLAY THE NOTIFICATION COUNTER.
        $('#noti_Counter2')
            .css({ opacity: 0 })
                         // ADD DYNAMIC VALUE (YOU CAN EXTRACT DATA FROM DATABASE OR XML).
            .css({ top: '-10px' })
            .animate({ top: '-2px', opacity: 1 }, 500);

        $('#noti_Button2').click(function () {

            // TOGGLE (SHOW OR HIDE) NOTIFICATION WINDOW.
            $('#notifications2').fadeToggle('fast', 'linear', function () {
                if ($('#notifications2').is(':hidden')) {
                    $('#noti_Button2').css('color', '#2e60ad');
                }
                else $('#noti_Button2').css('color', '#fdc006');        // CHANGE BACKGROUND COLOR OF THE BUTTON.
            });

            $('#noti_Counter2').fadeOut('slow');                 // HIDE THE COUNTER.

            return false;
        });

        // HIDE NOTIFICATIONS WHEN CLICKED ANYWHERE ON THE PAGE.
        $(document).click(function () {
            $('#notifications2').hide();

            // CHECK IF NOTIFICATION COUNTER IS HIDDEN.
            if ($('#notifications2').is(':hidden')) {
                // CHANGE BACKGROUND COLOR OF THE BUTTON.
                $('#noti_Button2').css('color', '#2e60ad');
            }
        });

        $('#notifications2').click(function () {
            return true;       // DO WHEN CONTAINER IS CLICKED.
        });
    });