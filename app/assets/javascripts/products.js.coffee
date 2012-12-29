# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


hide_form = () ->
  $('modal').hide()

submit_form = () ->
  $(this).form.submit() 

$('btn').on click:->
  alert '111' 
  hide_form()
  submit_form()
  false