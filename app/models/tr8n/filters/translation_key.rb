#--
# Copyright (c) 2013 Michael Berkovich, tr8nhub.com
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++
#
#-- Tr8n::Filters::TranslationKey Schema Information
#
# Table name: will_filter_filters
#
#  id                  integer                        not null, primary key
#  type                character varying(255)         
#  name                character varying(255)         
#  data                text                           
#  user_id             integer                        
#  model_class_name    character varying(255)         
#  created_at          timestamp without time zone    not null
#  updated_at          timestamp without time zone    not null
#
# Indexes
#
#  index_will_filter_filters_on_user_id    (user_id) 
#
#++

class Tr8n::Filters::TranslationKey < Tr8n::Filters::Base
  
  def model_class
    Tr8n::TranslationKey
  end

  def default_filters
    super + [
      ["Verified Keys", "verified"],
      ["Unverified Keys", "unverified"]
    ]
  end

  def default_filter_conditions(key)
    super_conditions = super(key)
    return super_conditions if super_conditions

    case key
      when "verified"
        return [:verified_at, :is_provided]
      when "unverified"
        return [:verified_at, :is_not_provided]
    end
  end
  
end
