// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require turbolinks
//= require bootstrap-sprockets
//= require ../jquery-sortable.js
//= require_tree .

function appendFlashMessage(type, message){
  var el = $('<div class="alert alert-' + type + '"></div>');
  el.append("<button class='close' data-dismiss='alert'>x</button>")
  el.append(message);
  el.appendTo('div#flash-message-box');
  setTimeout(function(){
    el.fadeOut(2000, function(){ $(this).remove() });
  }, 5000);
}