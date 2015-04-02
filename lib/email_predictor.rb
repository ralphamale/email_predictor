require 'set'
require './lib/contact'

class EmailPredictor
  attr_reader :contacts

  def initialize(initial_data_hash)
    @contacts = Set.new

    initial_data_hash.each do |full_name, email|
      contact = Contact.new(full_name, email)
      @contacts.add(contact) if contact.valid?
    end
  end

  def name_to_pattern(full_name, pattern)
    contact = Contact.new(full_name)

    case pattern
    when :first_name_dot_last_name
      "#{contact.first_name}.#{contact.last_name}"
    when :first_name_dot_last_initial
      "#{contact.first_name}.#{contact.last_initial}"
    when :first_initial_dot_last_name
      "#{contact.first_initial}.#{contact.last_name}"
    when :first_initial_dot_last_initial
      "#{contact.first_initial}.#{contact.last_initial}"
    end
  end

  def most_common_patterns(org) # Could be tie, that's why array is used
    coworkers = @contacts.clone.select { |contact| contact.organization == org }
    pattern_count = Hash.new(0)

    coworkers.each do |coworker|
      pattern_count[coworker.email_pattern_type] += 1
    end

    max = pattern_count.values.max
    pattern_count.delete(nil) # Disregard emails that don't conform to standard
    pattern_count.select { |pattern_type, count| count == max }.keys
  end

  def email_predictions(full_name, org_domain) # Returns array of possible email addresses
    if /^(?:[-A-Za-z0-9]+\.)+[A-Za-z]{2,6}$/.match(org_domain).nil?
      raise "org_domain takes the domain of the organization. E.g., 'Google' becomes 'google.com'"
    end
    
    emails = []

    most_common_patterns(org_domain).each do |pattern|
      emails << "#{name_to_pattern(full_name, pattern)}@#{org_domain}".downcase
    end

    emails
  end

end