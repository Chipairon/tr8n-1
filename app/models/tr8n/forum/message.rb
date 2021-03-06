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
#-- Tr8n::Forum::Message Schema Information
#
# Table name: tr8n_forum_messages
#
#  id               integer                        not null, primary key
#  language_id      integer                        not null
#  topic_id         integer                        not null
#  translator_id    integer                        not null
#  message          text                           not null
#  created_at       timestamp without time zone    not null
#  updated_at       timestamp without time zone    not null
#  mentions         character varying(255)         
#
# Indexes
#
#  tr8n_lfm_l     (language_id) 
#  tr8n_lfm_ll    (language_id, topic_id) 
#  tr8n_lfm_t     (translator_id) 
#
#++

class Tr8n::Forum::Message < ActiveRecord::Base
  self.table_name = :tr8n_forum_messages
  attr_accessible :language_id, :topic_id, :translator_id, :message, :mentions
  attr_accessible :language, :translator, :topic

  belongs_to :language,               :class_name => "Tr8n::Language"
  belongs_to :translator,             :class_name => "Tr8n::Translator"
  belongs_to :topic,                  :class_name => "Tr8n::Forum::Topic", :foreign_key => :topic_id
  
  after_create :distribute_notification

  def toHTML
    return "" unless message
    msg = ERB::Util.html_escape(message.dup)
    message.scan(/(@[^\s]+)/).each do |frag|
      msg = message.gsub(frag.first, "<span class='tr8n_mentioned_translator'>#{frag.first}</span>")
    end
    msg.gsub("\n", "<br>").html_safe
  end

  def distribute_notification
    Tr8n::Notification.distribute(self)    
  end

end
