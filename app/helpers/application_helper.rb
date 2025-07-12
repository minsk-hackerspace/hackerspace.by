# frozen_string_literal: true

module ApplicationHelper
  def og_static_pages_map
    {
      'projects' => %w[index],
      'news' => %w[index],
      'main' => %w[contacts index board calendar rules tariffs howtopay procedure],
      'thanks' => %w[index]
    }
  end

  def og_dynamic_pages_map
    {
      'projects' => { 'show' => { 'title' => 'name', 'description' => 'short_desc' } },
      'news' => { 'show' => { 'title' => 'title', 'description' => 'short_desc' } },
      'thanks' => { 'show' => { 'title' => 'name', 'description' => 'short_desc' } }
    }
  end

  def get_og_meta(name)
    if og_static_pages_map[controller_name]&.include?(action_name)
      I18n.t("og_meta.#{controller_name}.#{action_name}.#{name}")
    elsif og_dynamic_pages_map[controller_name]&.include?(action_name)
      instance_variable_get("@#{controller_name.singularize}")&.send(
        og_dynamic_pages_map[controller_name].try(:[], action_name).try(:[], name.to_s)
      )
    end
  end

  def page_title
    get_og_meta(:title) || t('site_title')
  end

  def page_description
    get_og_meta(:description) || strip_tags(t('index.what_is_it_content'))
  end

  def og_page_image
    if action_name == 'show' && og_dynamic_pages_map.keys.include?(controller_name)
      image_url(instance_variable_get("@#{controller_name.singularize}")&.send(:photo)&.url(:original))
    else
      image_url('/images/logo_site.svg')
    end
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
