$(document).on('click', '[data-add-target][data-add-template]', (event) => {
  var button = $(event.target)
  var target = button.data('add-target');
  var template = button.data("add-template");
  var templateId = new Date().getTime();
  var rendered = template.replace(/([\[_])([0-9]+)([\]_])/g, "$1" + templateId + '$3');

  $(target).append(rendered);

  event.preventDefault();
});

$(document).on('click', '[data-remove-item]', (event) => {
  var button = $(event.target)
  var wrapper = button.closest('tr')
  if (button.data("remove-item") === "soft") {
    wrapper.hide();
    button.prev('input[type=hidden]').val('1');
  } else {
    wrapper.remove()
  }
  event.preventDefault();
});
