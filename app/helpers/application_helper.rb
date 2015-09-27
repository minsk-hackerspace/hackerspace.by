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

  def show_afisha
    if news = News.homepage.where("show_on_homepage_till_date > ? ", Time.now).order(created_at: :desc).first
      url = news.url.present? ? news.url : news_path(news)

      html = link_to url, target: '_blank', rel: 'no-follow', title: news.short_desc do
        image_tag(image_path(news.photo.url(:original)), width: '50%', style: 'margin: auto 25%', alt: news.short_desc)
      end
      html << tag(:hr)
      html
    end
  end
end
