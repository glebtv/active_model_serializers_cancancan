module ActiveModel
  class Serializer
    module CanCan
      module ReflectionValue
        def value(serializer, include_slice)
          val = super(serializer, include_slice)
          unless authorize?
            return val
          end
          if val.kind_of?(ActiveRecord::Associations::CollectionProxy)
            val.select do |item|
              serializer.current_ability.can?(:read, item)
            end
          else
            if serializer.current_ability.can?(:read, val)
              val
            else
              nil
            end
          end
        end
      end
    end
  end
end

