$(document).on('click', '[data-add-target][data-add-template]', (event) => {
  var button = $(event.target)
  var target = button.data('add-target');
  var template = button.data("add-template");
  var templateId = new Date().getTime();
  var rendered = template.replace(/(_attributes[\]\[_]{1,2})([0-9]+)/g, "$1" + templateId);

  $(target).append(rendered);

  event.preventDefault();
});

$(document).on('click', '[data-remove-item]', (event) => {
  $(event.target).closest('tr').hide();
  $(event.target).prev('input[type=hidden]').val('1');
  event.preventDefault();
});
