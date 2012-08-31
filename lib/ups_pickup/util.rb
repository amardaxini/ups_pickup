module UpsPickup
  module Util
    def set_yes_or_no_option(value)
      if value.nil? || value == 0 || value == false || value == "n" || value == "N"
        "N"
      elsif value == 1 || value == true || value == "y" || value == "Y"
         "Y" 
      else
       raise "Option can be [Y,N]"   
      end    
    end
    #Finding nested hash keys value  
    def deep_find(obj,key)
      if obj.respond_to?(:key?) && obj.key?(key)
        obj[key]
      elsif obj.respond_to?(:each)
        r = nil
        obj.find{ |*a| r=deep_find(a.last,key) }
        r
      end
    end
  end

end
class Hash
  def deep_fetch(key, default = nil)
    default = yield if block_given?
    (deep_find(key) or default) or nil
  end

  def deep_find(key)
    if key?(key)
      self[key]
    else  
      self.values.inject(nil) do |memo, v|             
        memo = v.deep_find(key) if v.respond_to?(:deep_find)       
        memo unless memo.nil?  
      end 
    end     
  end
end
