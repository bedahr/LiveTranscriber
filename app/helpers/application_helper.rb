module ApplicationHelper

  def button_to(body, url_options={}, html_options={})
    body = "#{icon(html_options[:icon], html_options[:icon_options] || {})} #{body}".html_safe if html_options[:icon]
    body = "#{body} <span class='caret'></span>".html_safe  if html_options[:caret]

    href = url_for(url_options) if url_options

    content_tag(:a, body, html_options.merge({ :href => href, :class => "btn #{html_options[:class]}"}))
  end

  def check_or_unchecked(value, title='')
    if value
      content_tag(:span, icon(:check),     :class => 'btn btn-success')
    else
      content_tag(:span, icon(:unchecked), :class => 'btn btn-danger')
    end
  end

  def icon(icons, options={})
    options[:class] = [ icons, options[:class] ].flatten.compact.collect { |k| "icon-#{k}" }.join(' ')
    content_tag(:i, '', options)
  end

  def flag(object)
    return unless object

    filename = object.is_a?(Language) ? object.short_code : object
    content_tag(:span, image_tag("flags/#{filename}.png"), :class => 'flag')
  end

  def box(title, &block)
    content_tag(:div, content_tag(:h4, title, :class => 'box-header round-top') + content_tag(:div, content_tag(:div, nil, { :class => 'box-content' }, true, &block), :class => 'box-container-toggle'), :class => 'box')
  end

  def dropdown_button(name, html_options={}, &block)
    output  = button_to(name, nil, { :caret => true, :class => 'dropdown-toggle', 'data-toggle' => 'dropdown' }.merge(html_options) )
    output += content_tag(:ul, capture(&block), :class => 'dropdown-menu') if block_given?
    output
  end

  def dropdown_link_to(body, url_options={}, html_options={})
    body = "#{icon(html_options[:icon])} #{body}".html_safe if html_options[:icon]
    link_to(body, url_options, html_options)
  end

  def divider
    content_tag(:li, '', :class => :divider)
  end

  def dump_table(obj, options={})
    options[:entry_name] ||= 'Record'
    options[:per_page]   ||= 1_000

    array = obj.to_a

    rows = []

    array.each do |record|
      value = record
      title = nil

      if record.is_a?(Array) && record.size == 2
        title = record.first.to_s.titlecase
        value = record.last
      end

      value = yield(value) if block_given?

      value = number_with_delimiter(value) if value.is_a?(Integer)

      if title
        rows << content_tag(:tr, content_tag(:td, title, :class => 'title top') + content_tag(:td, value))
      else
        rows << content_tag(:tr, content_tag(:td, value))
      end
    end

    array.any? ? content_tag(:table, rows.join.html_safe, :class => 'table hover') : ''
  end

  def alert(msg, klass, options={})
    msg = content_tag(:a, 'x', :href => '#', :class => 'close', 'data-dismiss' => 'alert').html_safe + msg if options[:close]
    content_tag(:div, msg, :class => "alert alert-#{klass}")
  end

  # Paginate helper using will_paginate manual navigation, plus InfinityScroll (Show More), plus Show All, plus page entries info
  def paginate(collection, options={})
    pagination   = will_paginate(collection, :container => false, :previous_label => "&laquo; Previous", :next_label => "Next &raquo;")
    page_entries = content_tag(:li, content_tag(:a, raw(page_entries_info(collection, options)), :href => '#'), :class => 'disabled')

    content_tag(:ul, [ pagination, page_entries ].join.html_safe, :class => 'pagination')
  end

  # Nicely formatted page_entries_info
  def page_entries_info(collection, options = {})
    entry_name = options[:entry_name] || (collection.empty? ? 'entry' : collection.first.class.name.underscore.gsub(/_|\//, ' '))

    if collection.total_pages < 2
      case collection.size
      when 0 then "No #{entry_name.titlecase.pluralize} found"
      when 1 then "<b>1</b> #{entry_name.titlecase}"
      else        "<b>#{collection.size}</b> #{entry_name.pluralize.titlecase}"
      end
    else
      %{<b>%s&nbsp;-&nbsp;%s</b> of <b>%s</b> #{entry_name.pluralize.titlecase}} % [
        number_with_delimiter(collection.offset + 1),
        number_with_delimiter(collection.offset + collection.length),
        number_with_delimiter(collection.total_entries)
      ]
    end
  end

end
