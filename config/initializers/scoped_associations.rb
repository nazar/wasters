#adds ability to reference a named scope in associated...i.e :scope => named_scope_in_target class. See #Item class
module RailsExtensions
  module HasManyThroughWithScope
    def has_many_with_scope(association, options={})
      if (through = options[:through]) && (scope = options.delete(:scope))
        if conditions = through.to_s.classify.constantize.send(scope).proxy_options[:conditions]
          scope_conditions = conditions.inject({}) do |scope_conditions, (key, value)|
            scope_conditions["#{through}.#{key}"] = value
            scope_conditions
          end
          options[:conditions] = (options[:conditions] || {}).merge(scope_conditions)
        end
      end
      has_many_without_scope(association, options)
    end
  end
end

ActiveRecord::Base.extend(RailsExtensions::HasManyThroughWithScope)
ActiveRecord::Base.metaclass.instance_eval do
  alias_method_chain :has_many, :scope
end
