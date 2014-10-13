$(document).ready(function() {

  // ALERTS TOGGLE
    var alertsListLink = $('a.alerts-toggle');
      alertsListLink.on('click', function (e) {
    var $this = $(this),
        box = $(this).siblings('div.alerts-box');
      box.slideToggle(300);
      $this.text() == $this.data("text-swap")
      ? $this.text($this.data("text-original"))
      : $this.text($this.data("text-swap"));
      e.preventDefault();
    });

  // DIRECTIONS TOGGLE
    var directions = $('ul.directions');
      directions.hide().filter(':first').show();
    $('a.toggle').on('click', function (e) {
    var $this = $(this),
        instructions = $(this).siblings(directions);
      instructions.slideToggle(300);
       $this.text() == $this.data("text-swap")
        ? $this.text($this.data("text-original"))
        : $this.text($this.data("text-swap"));
        e.preventDefault();
    });

  // DETAILS TOGGLE
    var details = $('div.details');
      details.hide();
  $('.detail-link').on('click', function (e) {
  var $this = $(this),
      detail = $this.siblings(details);
      detail.slideToggle(300)
      e.preventDefault();
  });
});
