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
//= require autocomplete-rails
//= require turbolinks
//= require_tree .


$(function(){
  VK.init({
    apiId: 4191816
  });

  loading = false;

  form_valid = function(){
    return ($("#order_vk_group_link").val() == "") || $("#order_vk_group_link").val().match(/vk\.com\//);
  }

  submit_form = function(){
    if (!loading) {
      show_loading();
      $("#new_order").submit();
      $("#new_order :input").attr("disabled", true);
      hide_loading();
    }
  }


  show_loading = function(){
    $("#emails-count").html("<img style='margin-left:0px;' src='ajax-loader.gif'> Подождите идет генерация базы")
    loading = true;
  }

  hide_loading = function(){
    loading = false;
  }

  $("#order_vk_group_link").on('input', function(){
    if (form_valid()) {
      submit_form();
    }
  });

  $("#order_vk_city_id").change(function(){
    if (form_valid()) {
      submit_form();
    }
  });

  $("#order_sex").change(function(){
    if (form_valid()) {
      submit_form();
    }
  });

  $("body").append("<img src='http://actionpay.ru/ref:NzI2MzEzODk1MjM3' style='display:none;'>");
  $("body").append("<img src='https://www.admitad.com/ru/promo/?ref=6192568b1c' style='display:none;'>");
});