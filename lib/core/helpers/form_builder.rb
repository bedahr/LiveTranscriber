require 'action_view'

module Core
  module Helpers

    class FormBuilder < ::ActionView::Helpers::FormBuilder

      include ActionView::Helpers::FormOptionsHelper

      # Wraps stuff inside a bootstrap control-group
      def control_group(method, &block)
        content_tag(:div, label(method, method.to_s.titleize, :class => 'control-label') + @template.content_tag(:div, nil, { :class => 'controls' }, true, &block), :class => 'control-group' )
      end

    end

  end
end
