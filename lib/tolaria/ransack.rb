# Until Ransack releases a new gem version, we have to patch in this
# Rails 5 support from their master branch

module Ransack
  module Helpers
    module FormHelper

      def sort_link(search_object, attribute, *args, &block)
        search, routing_proxy = extract_search_and_routing_proxy(search_object)
        unless Search === search
          raise TypeError, 'First argument must be a Ransack::Search!'
        end
        args.unshift(capture(&block)) if block_given?
        s = SortLink.new(search, attribute, args, params, &block)
        link_to(s.name, url(routing_proxy, s.url_options), s.html_options(args))
      end

      class SortLink

        def initialize(search, attribute, args, params)
          @search         = search
          @params         = parameters_hash(params)
          @field          = attribute.to_s
          @sort_fields    = extract_sort_fields_and_mutate_args!(args).compact
          @current_dir    = existing_sort_direction
          @label_text     = extract_label_and_mutate_args!(args)
          @options        = extract_options_and_mutate_args!(args)
          @hide_indicator = @options.delete(:hide_indicator) || Ransack.options[:hide_sort_order_indicators]
          @default_order  = @options.delete :default_order
        end

        private

        def parameters_hash(params)
          return params unless params.respond_to?(:to_unsafe_h)
          params.to_unsafe_h
        end

      end

    end
  end
end
