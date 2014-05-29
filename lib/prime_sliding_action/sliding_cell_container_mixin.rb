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
              if collection_section.data.first == self
                options[:styles] = [:"#{collection_section.name}_first_cell"]
              end
              if collection_section.data.last == self
                options[:styles] = [:"#{collection_section.name}_last_cell"]
              end
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