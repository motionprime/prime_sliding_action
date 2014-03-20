class SlidingCellView < MPCellWithSection
  attr_accessor :pan_recognizer, :tap_recognizer, :sliding_action_buttons

  def setSection(section)
    @section = section.try(:weak_ref)
    self.content_view.setSection(@section)
    if section
      # init section
      @table = @section.table.table_view
      @table.directionalLockEnabled = true

      unless @sliding_action_buttons_rendered
        @sliding_action_buttons_offset = 0
        @sliding_action_buttons = {}
        @section.sliding_action_buttons.each do |action, options|
          styles = [:base_action_button, :"#{@section.name}_action_button", :"#{@section.name}_action_button_#{action}"]
          button = @section.screen.add_view MPButton,
            top: 0,
            width: 80,
            left: 320 + @sliding_action_buttons_offset,
            height: cell_height,
            title_color: options[:title_color] || :white,
            title: options[:title],
            background_color: options[:background_color] || options[:color] || :red
          @section.screen.setup button, styles: styles
          @sliding_action_buttons_offset += button.width
          button.on :touch do
            button.off(:touch) if options[:unbind]
            @section.send(options[:action])
            hide_actions unless (options.has_key?(:hide_on_finish) && !options[:hide_on_finish])
          end

          @sliding_action_buttons[action] = button

          self.scroll_view.addSubview button
        end
        self.scroll_view.setContentSize CGSizeMake(320 + @sliding_action_buttons_offset, cell_height)

        @sliding_action_buttons_rendered = true
        @sliding_action_buttons_state = :hidden
      end
    else
      @sliding_action_buttons_rendered = nil
    end
  end

  def initialize_content
    self.scroll_view = self.subviews.first
    self.scroll_view.subviews.first.removeFromSuperview
    self.content_view = MPTableViewCellContentView.alloc.initWithFrame(CGRectMake(0,0,320, self.height))
    self.content_view.setBackgroundColor(:white.uicolor)
    self.content_view.autoresizingMask = UIViewAutoresizingFlexibleHeight

    self.scroll_view.addSubview(content_view)
    self.scroll_view.setDelegate self
    self.scroll_view.setScrollEnabled true
    self.scroll_view.setContentSize CGSizeMake(320, self.height)
    self.scroll_view.autoresizingMask = UIViewAutoresizingFlexibleHeight

    self.scroll_view.setShowsHorizontalScrollIndicator false
    self.scroll_view.setScrollsToTop false
    self.scroll_view.setPagingEnabled true

    self.pan_recognizer = UIPanGestureRecognizer.alloc.initWithTarget(self, action: 'pan')
    self.pan_recognizer.setMinimumNumberOfTouches 1
    self.pan_recognizer.setMaximumNumberOfTouches 1
    self.pan_recognizer.delegate = self
    self.addGestureRecognizer pan_recognizer

    self.tap_recognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action: 'tap')
    self.tap_recognizer.delegate = self
    self.addGestureRecognizer tap_recognizer
  end

  def pan
    offset = @sliding_action_buttons_offset || 0
    translation = pan_recognizer.translationInView self
    velocity = pan_recognizer.velocityInView self
    if pan_recognizer.state == UIGestureRecognizerStateEnded
      if velocity.x < -1000
        show_actions
      elsif velocity.x > 1000
        hide_actions
      elsif self.scroll_view.contentOffset.x > (offset / 2)
        show_actions
      else
        hide_actions
      end
    else
      if pan_recognizer.state == UIGestureRecognizerStateBegan
        @sliding_action_buttons_x = self.scroll_view.contentOffset.x
      end
      current_x = @sliding_action_buttons_x - translation.x
      if translation.x < 0 || current_x > 0
        self.scroll_view.setContentOffset CGPointMake(current_x, 0)
      end
    end
  end

  def tap
    if @sliding_action_buttons_state == :hidden && @table
      cell_index = @table.indexPathForCell(self)
      @table.delegate.tableView(@table, didSelectRowAtIndexPath: cell_index)
    else
      hide_actions
    end
  end

  def show_actions
    offset = @sliding_action_buttons_offset || 0
    self.scroll_view.setContentOffset(CGPointMake(offset, 0), animated: true)
    @sliding_action_buttons_state = :visible
  end

  def hide_actions
    self.scroll_view.setContentOffset(CGPointMake(0, 0), animated: true)
    @sliding_action_buttons_state = :hidden
  end

  def actions_visible?
    @sliding_action_buttons_state == :visible
  end

  def cell_height
    section ? section.container_options[:height] : self.height
  end

  def gestureRecognizer(gestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer: otherGestureRecognizer)
    if gestureRecognizer.is_a?(UIPanGestureRecognizer)
      yVelocity = (gestureRecognizer.velocityInView gestureRecognizer.view).y
      yVelocity.abs >= 10
    else
      true
    end
  end
end
