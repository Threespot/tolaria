class Admin::FormBuilder < ActionView::Helpers::FormBuilder
  include Tolaria::FormBuildable
  delegate :content_tag, :tag, :render, to: :@template
end

class Ransack::Helpers::FormBuilder
  include Tolaria::FormBuildable
  delegate :content_tag, :tag, :render, to: :@template
end
