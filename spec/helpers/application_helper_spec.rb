require 'rails_helper'

describe ApplicationHelper do
  describe "#markdown" do
    it "returns text with markdown" do
      expect(helper.markdown("text")).to eq("<p>text</p>\n")
    end
  end

  describe "#markup2html" do
    it ""
  end

  describe "#og_static_pages_map" do
    it "returns hash data" do
      expect(helper.og_static_pages_map).to eq({
                                                 'projects' => %w[index],
                                                 'news' => %w[index],
                                                 'main' => %w[contacts index board calendar rules tariffs howtopay procedure],
                                                 'thanks' => %w[index]
                                               })
    end
  end

  describe "#og_dynamic_pages_map" do
    it "returns hash data" do
      expect(helper.og_dynamic_pages_map).to eq({
                                                 'projects' => { 'show' => { 'title' => 'name', 'description' => 'short_desc' } },
                                                 'news' => { 'show' => { 'title' => 'title', 'description' => 'short_desc' } },
                                                 'thanks' => { 'show' => { 'title' => 'name', 'description' => 'short_desc' } }
                                               })
    end
  end

  describe "#get_og_meta(name)" do
    context 'projects (static pages map)' do
      before do
        allow(helper).to receive(:controller_name).and_return('projects')
        allow(helper).to receive(:action_name).and_return('index')
      end

      it "returns og_meta tag for projects" do
        expect(helper.get_og_meta('title')).to_not be(I18n.t("og_meta.projects.index.title"))
      end
    end

    context 'projects (dynamic pages map)' do
      before do
        allow(helper).to receive(:controller_name).and_return('projects')
        allow(helper).to receive(:action_name).and_return('show')
        assign(:project, Project.new(name: 'Project #1'))
      end

      it "returns og_meta tag for projects" do
        expect(helper.get_og_meta('title')).to eql('Project #1')
      end
    end

    context 'news (dynamic pages map)' do
      before do
        allow(helper).to receive(:controller_name).and_return('news')
        allow(helper).to receive(:action_name).and_return('show')
        assign(:news, News.new(title: 'News #1'))
      end

      it "returns og_meta tag for news" do
        expect(helper.get_og_meta('title')).to eql('News #1')
      end
    end

    context 'thanks (dynamic pages map)' do
      before do
        allow(helper).to receive(:controller_name).and_return('thanks')
        allow(helper).to receive(:action_name).and_return('show')
        assign(:thank, Thank.new(name: 'Thank #1'))
      end

      it "returns og_meta tag for thanks" do
        expect(helper.get_og_meta('title')).to eql('Thank #1')
      end
    end
  end

  describe "#page_title" do
    it "returns site title" do
      expect(helper.page_title).to eql(I18n.t(:site_title))
    end
  end

  describe "#page_description" do
    it "returns description" do
      expect(helper.page_description).to eql(helper.strip_tags(t('index.what_is_it_content')))
    end
  end

  describe "#og_page_image" do
    it "returns default page image" do
      expect(helper.og_page_image).to eql(helper.image_url('/images/logo_site.svg'))
    end

    context 'projects#show page' do
      let(:project) { create :project }

      before do
        allow(helper).to receive(:controller_name).and_return('projects')
        allow(helper).to receive(:action_name).and_return('show')
        assign(:project, project.reload)
      end

      it "returns project image url" do
        image_url = helper.image_url(url_for(project.photo.variant(:original)))
        expect(helper.og_page_image).to eql(image_url)
      end
    end
  end

end
