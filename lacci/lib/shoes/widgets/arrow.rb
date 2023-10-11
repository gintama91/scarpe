# frozen_string_literal: true

module Shoes
  class Arrow < Shoes::Widget
    display_properties :left, :top, :width, :draw_context

    def initialize(*args)
      @left, @top, @width = args

      @left = convert_to_integer(@left, "left")
      @top = convert_to_integer(@top, "top")
      @width = convert_to_integer(@width, "width")

      @draw_context = Shoes::App.instance.current_draw_context

      super
      create_display_widget
    end

    private

    def convert_to_integer(value, attribute_name)
      begin
        value = Integer(value)
        raise InvalidAttributeValueError, "Negative number '#{value}' not allowed for attribute '#{attribute_name}'" if value < 0

        value
      rescue ArgumentError
        error_message = "Invalid value '#{value}' provided for attribute '#{attribute_name}'. The value should be a number."
        raise InvalidAttributeValueError, error_message
      end
    end

    def convert_to_float(value, attribute_name)
      begin
        value = Float(value)
        raise InvalidAttributeValueError, "Negative number '#{value}' not allowed for attribute '#{attribute_name}'" if value < 0

        value
      rescue ArgumentError
        error_message = "Invalid value '#{value}' provided for attribute '#{attribute_name}'. The value should be a number."
        raise InvalidAttributeValueError, error_message
      end
    end
  end
end
