// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require filterrific/filterrific-jquery
//= require rails-ujs
//= require activestorage
//= require bootstrap
//= require popper
//= require main
//= require_tree .

$( document ).ready(function() {
  Filterrific.init();
});

function timeoutWindow() {
  window.setTimeout(function () {
    // When the user is given an error message, we should not auto-hide it so that
    // they can fully read it and potentially copy/paste it into an issue.
    $(".alert")
      .not(".alert-danger")
      .fadeTo(1000, 0)
      .slideUp(1000, function () {
        $(this).remove();
      });
    timeoutWindow();
  }, 2500);
}
timeoutWindow();
