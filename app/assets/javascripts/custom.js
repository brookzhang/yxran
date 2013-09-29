function submit_parameter_with_form_id(form_id, param_name, param_value) {
  var form = $("#"+form_id);
  $("input[name='"+param_name+"']").val(param_value);
  form.submit();
}