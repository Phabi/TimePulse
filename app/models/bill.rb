# == Schema Information
#
# Table name: bills
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)
#  notes            :text
#  created_at       :datetime
#  updated_at       :datetime
#  due_on           :date
#  paid_on          :date
#  reference_number :string(255)
#

class Bill < ActiveRecord::Base            
  belongs_to :user
  has_many :work_units

  named_scope :overdue, lambda { { :conditions => [ "paid_on IS NULL AND due_on < ? ", Date.today ] } }
  named_scope :unpaid,  :conditions => { :paid_on => nil }
  named_scope :paid, :conditions => "paid_on IS NOT NULL"

  validates_presence_of :user_id   
  
  attr_accessible :notes, :due_on, :user, :user_id, :paid_on, :reference_number      
  
  def hours
    work_units.sum(:hours)
  end  
  
  def paid?
    !paid_on.nil?
  end
  
  # return a flattened, deduplicated array of all clients for work units in this bill
  def clients
    @clients ||= work_units.map{ |wu| wu.project }.uniq.map{ |p| p.client }.uniq    
  end
  
  
  
end