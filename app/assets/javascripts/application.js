// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
// require turbolinks
//= require_tree .

function clearFocusDiv() {
  $('#current_focus_div').hide()
}

$(document).ready(function() {
  $('#clear-focus-link').click(function() {
    $.ajax({
      url: '/current_focus/reset',
      type: 'POST',
      success: function() { clearFocusDiv() },
      error: function() { alert('Error sending clear request to server.')}
    })
  })
  
  $('#bookmark_form_submit').click(function() {
    var form = $('#new_web_link')
//    console.log(form.serialize())
    $.ajax({
      url: '/web_links/bookmark',
      type: 'POST',
      data: form.serializeArray(),
      success: function() { window.close() },
      error: function() { alert('Error sending clear request to server.')}
    })
  })
})
