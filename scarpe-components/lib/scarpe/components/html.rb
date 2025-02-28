# frozen_string_literal: true

class Scarpe::Components::HTML
  CONTENT_TAGS = [
    :div,
    :p,
    :button,
    :ul,
    :li,
    :textarea,
    :a,
    :video,
    :strong,
    :style,
    :progress,
    :em,
    :code,
    :defs,
    :marker,
    :u,
    :line,
    :span,
    :svg,
    :h1,
    :h2,
    :h3,
    :h4,
    :h5,
  ].freeze
  VOID_TAGS = [:input, :img, :polygon, :source, :link, :path, :rect].freeze

  TAGS = (CONTENT_TAGS + VOID_TAGS).freeze

  class << self
    def render(&block)
      new(&block).value
    end
  end

  def initialize(&block)
    @buffer = ""
    block.call(self)
  end

  def value
    @buffer
  end

  def respond_to_missing?(name, include_all = false)
    TAGS.include?(name) || super(name, include_all)
  end

  def p(*args, &block)
    method_missing(:p, *args, &block)
  end

  def option(**attrs, &block)
    tag(:option, **attrs, &block)
  end

  def tag(name, **attrs, &block)
    if VOID_TAGS.include?(name)
      raise Shoes::Errors::InvalidAttributeValueError, "void tag #{name} cannot have content" if block_given?

      @buffer += "<#{name}#{render_attributes(attrs)} />"
    else
      @buffer += "<#{name}#{render_attributes(attrs)}>"

      if block_given?
        result = block.call(self)
      else
        result = attrs[:content]
        @buffer += result if result.is_a?(String)
      end
      @buffer += result if result.is_a?(String)

      @buffer += "</#{name}>"
    end

    nil
  end

  def select(**attrs, &block)
    tag(:select, **attrs, &block)
  end

  def method_missing(name, *args, &block)
    raise Scarpe::InvalidHTMLTag, "no method #{name} for #{self.class.name}" unless TAGS.include?(name)

    if VOID_TAGS.include?(name)
      raise Shoes::Errors::InvalidAttributeValueError, "void tag #{name} cannot have content" if block_given?

      @buffer += "<#{name}#{render_attributes(*args)} />"
    else
      @buffer += "<#{name}#{render_attributes(*args)}>"

      if block_given?
        result = block.call(self)
      else
        result = args.first
        @buffer += result if result.is_a?(String)
      end
      @buffer += result if result.is_a?(String)

      @buffer += "</#{name}>"
    end

    nil
  end

  private

  def render_attributes(attributes = {})
    return "" if attributes.empty?

    attributes[:style] = render_style(attributes[:style]) if attributes[:style]
    attributes.compact!

    return if attributes.empty?

    result = attributes.map { |k, v| "#{k}=\"#{v}\"" }.join(" ")
    " #{result}"
  end

  def render_style(style)
    return style unless style.is_a?(Hash)
    return if style.empty?

    style.map { |k, v| "#{k}:#{v}" }.join(";")
  end
end
