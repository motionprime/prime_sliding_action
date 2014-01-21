module SlidingCellSectionMixin
  extend ::MotionSupport::Concern

  def sliding_action_buttons
    self.class.sliding_action_buttons || {}
  end

  def has_sliding_actions?
    sliding_action_buttons.present?
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