/*global $, document, Chart, LINECHART, data, options, window*/
$(document).ready(function () {

    'use strict';

    // Main Template Color
    var brandPrimary = '#fff';
    var scrollbg = '#e8a249';

    // ------------------------------------------------------- //
    // For demo purposes only
    // ------------------------------------------------------ //

    $("#colour").change(function () {

        if ($(this).val() !== '') {

            var theme_csspath = 'css/style.' + $(this).val() + '.css';

            $('link#theme-stylesheet').attr("href", theme_csspath);

            $.cookie("theme_csspath", theme_csspath, { expires: 365, path: document.URL.substr(0, document.URL.lastIndexOf('/')) });
        }

        return false;
    });

    // ------------------------------------------------------- //
    // Custom Scrollbar
    // ------------------------------------------------------ //

    if ($(window).outerWidth() > 992) {
        $("nav.side-navbar").niceScroll({
            cursorcolor: scrollbg,
            cursorwidth: '3px',
            cursorborder: 'none'
        });
    }


    // ------------------------------------------------------- //
    // Side Navbar Functionality
    // ------------------------------------------------------ //
    $('#toggle-btn').on('click', function (e) {

        e.preventDefault();

        if ($(window).outerWidth() > 1194) {
            $('nav.side-navbar').toggleClass('shrink');
            $('.page').toggleClass('active');
        } else {
            $('nav.side-navbar').toggleClass('show-sm');
            $('.page').toggleClass('active-sm');
        }
    });


    // ------------------------------------------------------- //
    // Login  form validation
    // ------------------------------------------------------ //
    $('#login-form').validate({
        messages: {
            loginUsername: 'please enter your username',
            loginPassword: 'please enter your password'
        }
    });

    // ------------------------------------------------------- //
    // Register form validation
    // ------------------------------------------------------ //
    $('#register-form').validate({
        messages: {
            registerUsername: 'please enter your first name',
            registerEmail: 'please enter a vaild Email Address',
            registerPassword: 'please enter your password'
        }
    });

    // ------------------------------------------------------- //
    // Transition Placeholders
    // ------------------------------------------------------ //
    $('input').on('focus', function () {
        $(this).siblings('.label-custom').addClass('active');
    });

    $('input').on('blur', function () {
        $(this).siblings('.label-custom').removeClass('active');

        if ($(this).val() !== '') {
            $(this).siblings('.label-custom').addClass('active');
        } else {
            $(this).siblings('.label-custom').removeClass('active');
        }
    });


    // ------------------------------------------------------- //
    // Jquery Progress Circle
    // ------------------------------------------------------ //
    var machine_1 = $("#machine1_1").gmpc({
        color: brandPrimary,
        line_width: 5,
        starting_position: 0,
        percent: 5
    });
    var machine_2 = $("#machine1_2").gmpc({
        color: brandPrimary,
        line_width: 5,
        starting_position: 0,
        percent: 5
    });
    // var machine_3 = $("#machine2_1").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"200px",
    //     percent: 5
    // });
    // var machine_4 = $("#machine2_2").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"110px",
    //     percent: 5
    // });
    // var machine_5 = $("#machine3_1").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"200px",
    //     percent: 5, 

    // });
    // var machine_6 = $("#machine3_2").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"110px",
    //     percent: 5, 
    // });
    // var machine_7 = $("#machine4_1").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"200px",
    //     percent: 5, 
    // });
    // var machine_8 = $("#machine4_2").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"110px",
    //     percent: 5, 

    // });


    // var machine_9 = $("#machine5_1").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"200px",
    //     percent: 5
    // });
    // var machine_10 = $("#machine5_2").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"110px",
    //     percent: 5
    // });
    // var machine_11 = $("#machine6_1").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"200px",
    //     percent: 5
    // });
    // var machine_12 = $("#machine6_2").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"110px",
    //     percent: 5
    // });
    // var machine_13 = $("#machine7_1").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"200px",
    //     percent: 5, 

    // });
    // var machine_14 = $("#machine7_2").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"200px",
    //     percent: 5,
    // });
    // var machine_15 = $("#machine8_1").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"200px",
    //     percent: 5, 
    // });
    // var machine_16 = $("#machine8_2").gmpc({
    //     color: brandPrimary,
    //     line_width: 5,
    //     starting_position: 0,
    //     width:"110px",
    //     percent: 5,

    // });

    machine_1.gmpc('animate', 80, 3000);
    machine_2.gmpc('animate', 80, 3000);
    // machine_3.gmpc('animate', 80, 3000);
    // machine_4.gmpc('animate', 80, 3000);
    // machine_5.gmpc('animate', 80, 3000);
    // machine_6.gmpc('animate', 80, 3000);
    // machine_7.gmpc('animate', 80, 3000);
    // machine_8.gmpc('animate', 80, 3000);
    // machine_9.gmpc('animate', 80, 3000);
    // machine_10.gmpc('animate', 80, 3000);
    // machine_11.gmpc('animate', 80, 3000);
    // machine_12.gmpc('animate', 80, 3000);
    // machine_13.gmpc('animate', 80, 3000);
    // machine_14.gmpc('animate', 80, 3000);
    // machine_15.gmpc('animate', 80, 3000);
    // machine_16.gmpc('animate', 80, 3000);                            

    // ------------------------------------------------------- //
    // External links to new window
    // ------------------------------------------------------ //

    $('.external').on('click', function (e) {

        e.preventDefault();
        window.open($(this).attr("href"));
    });

});


