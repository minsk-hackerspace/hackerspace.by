module ApplicationHelper

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true,
      space_after_headers: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end

  def markup2html(text, lang = 'html')
    case lang
    when 'html'
      text.html_safe
    when 'markdown'
      markdown(text)
    else
      text.html_safe
    end
  end
end
