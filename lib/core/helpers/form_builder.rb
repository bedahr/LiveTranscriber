require 'action_view'

module Core
  module Helpers

    class FormBuilder < ::ActionView::Helpers::FormBuilder

      include ActionView::Helpers::FormOptionsHelper

      # Inserts a select dropdown with choser
      def choser(method, collection, value_method=:id, text_method=:name, options = {}, html_options={})
        options[:include_blank] = true

        html_options['class']            ||= 'choser-select'
        html_options['data-placeholder'] ||= "Choose a #{method.to_s.humanize} ..." if method

        @template.collection_select(@object_name, method, collection, value_method, text_method, objectify_options(options), @default_options.merge(html_options))
      end

      # Wraps stuff inside a bootstrap control-group
      def control_group(method=nil, &block)
        label = method ? label(method, method.to_s.titleize, :class => 'control-label') : content_tag(:span, "")
        content_tag(:div, label + @template.content_tag(:div, nil, { :class => 'controls' }, true, &block), :class => 'control-group' )
      end

    end

  end
end
