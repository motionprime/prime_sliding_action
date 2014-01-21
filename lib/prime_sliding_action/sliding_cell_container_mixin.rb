module SlidingCellContainerMixin

  def self.included(base)
    base.class_eval do
      unless @sliding_cell_container_included
        @sliding_cell_container_included = true
        alias_method :init_container_element_old, :init_container_element
        def init_container_element(options = {})
          if has_sliding_actions?
            @container_element ||= begin
              options.merge!({
                screen: screen,
                section: self.weak_ref,
                has_drawn_content: true
              })
              options[:styles] ||= []
              options[:styles] = [:"#{table.name}_first_cell"] if table.data.first == self
              options[:styles] = [:"#{table.name}_last_cell"] if table.data.last == self
              MotionPrime::BaseElement.factory(:sliding_cell, options)
            end
          else
            init_container_element_old(options)
          end
        end
      end
    end
  end
end