# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  $('#variants').dataTable( {
    "sScrollX": "100%",
    "sScrollY": "470",
    "iDisplayLength": 50,
    "bScrollCollapse": true
  });