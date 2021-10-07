module ApplicationHelper

  #TODO
  def page_title
    @project.try(:name) || @news.try(:title) || t('site_title')
  end

  #TODO
  def page_description
    strip_tags(t('index.what_is_it_content'))
  end

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

class AppFormBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {}, &block)
    options['class'] = '' if options['class'].nil?
    options['class'] += ' form-label small'
    @template.label(@object_name, method, text, objectify_options(options), &block)
  end
end
