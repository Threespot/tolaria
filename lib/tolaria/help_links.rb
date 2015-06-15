module Tolaria

  @help_links = []

  def self.initialize_help_links!
    @help_links = []
    self.config.help_links.each do |hashy|
      @help_links << Tolaria::HelpLink.new(**hashy)
    end
  end

  def self.help_links
    @help_links ||= []
  end

  class HelpLink

    # The title of the link
    attr_reader :title
    # Part part of the link at `/admin/help/:slug` when rendering a Markdown file
    attr_reader :slug
    # The file path to the Markdown file
    attr_reader :markdown_file
    # The path to link to when not rendering a Markdown file
    attr_reader :link_to

    # Create a new HelpLink with the passed settings.
    # You must provide +title+, the title of the link.
    # To configure automatic rendering of a Markdown file, provide
    # a string +slug+ and the path to a +markdown_file+.
    # A route to view the file will be constructed for you at `/admin/help/:slug`.
    # To link to an arbirary path or URI, provide it as +link_to+.
    def initialize(title:, slug:nil, markdown_file:nil, link_to:nil)
      @title = title.to_s.freeze
      @slug = slug.to_s.freeze
      @markdown_file = markdown_file.to_s.freeze
      @link_to = link_to.to_s.freeze
      validate!
    end

    # True if this HelpLink is a link to an arbirary path
    def link_type?
      link_to.present?
    end

    # True if this HelpLink is a Markdown file
    def markdown_type?
      markdown_file.present?
    end

    # Quack like an ActiveRecord::Base model
    def to_param
      slug
    end

    # Raises RuntimeError if this HelpLink is incorrectly configured
    def validate!

      if title.blank?
        raise RuntimeError, "HelpLinks must provide a string title"
      end

      file_configured = (slug.present? && markdown_file.present?)
      link_configured = link_to.present?

      unless file_configured || link_configured
        raise RuntimeError, "Incomplete HelpLink config. You must provide link_to, or both slug and markdown_file."
      end

      if file_configured && link_configured
        raise RuntimeError, "Ambiguous HelpLink config. You must provide link_to, or both slug and markdown_file, but not all three."
      end

    end

  end

end
