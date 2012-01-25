module ApplicationHelper
  # Given a gif, returns hash of options for specified gif's anchor
  # gif should have tag_ids, title, gif (asset)
  def popover_for(gif, direction = "right")
    {href: gif.gif.url, html: 'true',
     title: "<div class='tagtitle'>#{gif.title+":" if gif.title} </div>#{gif.tag_ids.inject(''){|s, tag| s+= '<div class="label labeltag success">'; s+= tag; s+= '</div>'}}",
     'data-content' => "<img src='#{gif.gif.preview}'/>", 'data-placement' => direction}
  end
end
