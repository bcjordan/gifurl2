$(function () { $('a.popovers') .popover({ offset: 10, html: true })})


$(function() {
  // 1. select all form inputs and the textarea
  $('form input')

  // 2. add focus handler
  .focus(function() {
    // a. cache current element
    var $this = $(this);

    // b. set the default value if it hasn't been set
    if (!$this.data('default')) {
      $this.data('default', $this.val());
    }

    // c. blank out the field and change color to black
    //    if the user hasn't entered text in it
    if ($this.val() == $this.data('default')) {
      $this.val('')
      .css('color', '#000');
    }
  })

  // 3. add blur handler
  .blur(function() {
    // a. cache current element
    var $this = $(this);

    // b. return field to default value and change color to gray
    //    if the field is empty
    if ($this.val() == '') {
      $(this).val($this.data('default'))
      .css('color', '#666');
    }
  })

  // 4. change text color to gray
  .css('color', '#666')
});
