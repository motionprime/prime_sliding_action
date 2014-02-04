module SlidingCellSectionMixin
  extend ::MotionSupport::Concern
  include MotionPrime::HasNormalizer

  def sliding_action_buttons
    buttons = {}
    (self.class.sliding_action_buttons || {}).each do |key, value|
      buttons[key] = normalize_options(value.clone)
    end
    buttons
  end

  def has_sliding_actions?
    self.class.sliding_action_buttons.present?
  end

  module ClassMethods
    def sliding_action_buttons
      @sliding_action_buttons || {}
    end

    def add_sliding_action_button(name, options = {})
      @sliding_action_buttons ||= {}
      @sliding_action_buttons[name] = options
    end
  end
end

Prime::Section.send :include, SlidingCellSectionMixin