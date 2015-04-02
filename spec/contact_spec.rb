require "contact"

describe "Contacts" do

  contact = Contact.new("Ralph Nguyen", "ralph.nguyen@alphasights.com")

  it "have correct naming functions" do
    expect(contact.first_name).to eq('Ralph')
    expect(contact.first_initial).to eq('R')
    expect(contact.last_name).to eq('Nguyen')
    expect(contact.last_initial).to eq('N')
  end

  it "will match email to a pattern type or nil if impossible" do
    first_initial_dot_last_initial = Contact.new("Ralph Nguyen", "R.n@alphasights.com")
    expect(first_initial_dot_last_initial.email_pattern_type).to eq(:first_initial_dot_last_initial)

    first_name_dot_last_name = contact
    expect(first_name_dot_last_name.email_pattern_type).to eq(:first_name_dot_last_name)

    first_initial_dot_last_name = Contact.new("Ralph Nguyen", "r.nguyen@alphasights.com")
    expect(first_initial_dot_last_name.email_pattern_type).to eq(:first_initial_dot_last_name)

    first_name_dot_last_initial = Contact.new("Ralph Nguyen", "ralph.n@alphasights.com")
    expect(first_name_dot_last_initial.email_pattern_type).to eq(:first_name_dot_last_initial)

    no_match = Contact.new("Bill Clinton", "willyclinton@gmail.com")
    expect(no_match.email_pattern_type).to eq(nil)    
  end

  it "can have their organizations inferred by email" do
    expect(contact.infer_organization_from_email).to eq('alphasights.com')
  end

  it "should be eql to another Contact with same full_name and email" do
    identical_contact = Contact.new("Ralph Nguyen", "ralph.nguyen@alphasights.com")
    expect(identical_contact).to eq(contact)
  end

  it "#valid? checks for presence of full name and valid email address" do
    expect(contact.valid?).to eq(true)

    no_name = Contact.new("asdf@asdf.com")
    expect(no_name.valid?).to eq(false)

    bad_email = Contact.new("John Handy", "afsd$af@fdsfs@c.m")
    expect(bad_email.valid?).to eq(false)
  end

end
