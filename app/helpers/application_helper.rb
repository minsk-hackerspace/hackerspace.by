module ApplicationHelper

  #TODO
  def page_title
    @project.try(:name) || @news.try(:title) || t('site_title')
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

  def show_afisha
    if news = News.homepage.where("show_on_homepage_till_date > ? ", Time.now).order(created_at: :desc).limit(2)

      html = ""
      image_style = news.count < 2 ? 'margin: auto 25%' : ''
      column_class = news.count < 2 ? "col-md" : "col-md-6"

      news.each do |news|
        url = news.url.present? ? news.url : news_path(news)

        html << content_tag(:div, class: column_class) do
          link_to(url, target: '_blank', rel: 'no-follow', title: strip_tags(news.short_desc)) do
            image_tag(image_path(news.photo.url(:original)), class: "featurette-image img-responsive center",
                      style: "float:left; #{image_style}", alt: strip_tags(news.short_desc)
            )
          end
        end
      end
      html.html_safe
    end
  end
end
