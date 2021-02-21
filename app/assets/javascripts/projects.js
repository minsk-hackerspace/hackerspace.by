document.addEventListener("turbolinks:load", () => {

  if ($('#project_markup_type').val() == "html")
    TinyMCERails.initialize('default', {});

  $('#project_markup_type').on("change", (e) => {
    var selector = e.target;

    if (selector.value != "html") {
      if (tinymce.get(0) != null)
        tinymce.activeEditor.hide();
    } else {
      if (tinymce.get(0) == null)
        TinyMCERails.initialize('default', {});

      tinymce.activeEditor.show();
    }
  });
});
