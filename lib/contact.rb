class Contact
  attr_accessor :full_name, :email, :organization
  def initialize(full_name, email = nil, organization = nil)
    @full_name = full_name #Assuming its fine if there's no first name. We can at least have last name.
    @email = email
    @organization = organization || infer_organization_from_email
    # I'm storing organization assuming that speed/simplicity is more important than space, but could easily extract organization on the fly if necessary
  end

  def first_name
    full_name.rpartition(' ').first #will be nil if a one-word full name is provided. 
  end

  def first_initial
    first_name[0]
  end

  def last_initial
    last_name[0]
  end

  def last_name
    full_name.rpartition(' ').last
  end

  def email_pattern_type
    match_data = /(\w*)[.](\w*)@.*[.].*/.match(email)

    return nil if match_data.nil?
      
    before_dot = match_data[1]
    after_dot = match_data[2]

    if before_dot.casecmp(first_initial) == 0 && after_dot.casecmp(last_initial) == 0
      :first_initial_dot_last_initial
    elsif before_dot.casecmp(first_name) == 0 && after_dot.casecmp(last_name) == 0
      :first_name_dot_last_name
    elsif before_dot.casecmp(first_initial) == 0 && after_dot.casecmp(last_name) == 0
      :first_initial_dot_last_name
    elsif before_dot.casecmp(first_name) == 0 && after_dot.casecmp(last_initial) == 0
      :first_name_dot_last_initial
    end
  end

  def infer_organization_from_email
    email_match_data = /.*@(.*)/.match(email)
    email_match_data ? email_match_data[1] : nil
  end

  def ==(other)
    full_name == other.full_name && email == other.email
  end

  def eql?(other)
    self == other
  end

  def hash
    [full_name, email, organization].hash
  end

  def valid?
    # Found email validation regexp on StackOverflow
    !email.nil? && !(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.match(email).nil?) && !full_name.nil?
  end

end