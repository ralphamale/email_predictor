require "email_predictor"

describe "Email Predictor" do
  initial_data_hash = {  "John Ferguson" => "john.ferguson@alphasights.com",  "Damon Aw" => "damon.aw@alphasights.com",  "Linda Li" => "linda.li@alphasights.com",  "Larry Page" => "larry.p@google.com",  "Sergey Brin" => "s.brin@google.com",  "Steve Jobs" => "s.j@apple.com"}
  predictor = EmailPredictor.new(initial_data_hash)

  describe "initialize method" do
    it "initializes with correct info" do
      initial_data_hash.each do |full_name, email_addr|
        contact = Contact.new(full_name, email_addr)
        expect(predictor.contacts.include?(contact)).to eq(true)
      end
    end

    it "does not add in identical contact information twice" do
      old_size = predictor.contacts.size
      predictor.contacts.add(Contact.new("John Ferguson", "john.ferguson@alphasights.com"))

      expect(old_size).to eq(predictor.contacts.size)
    end

    it "does not add an invalid contact" do
      initial_hash = {'Ralph Nguyen' => '$ralph.nguyen@gmail.com'}
      invalid_contact_predictor = EmailPredictor.new(initial_hash)
      invalid_contact = Contact.new('Ralph Nguyen', '$ralph.nguyen@gmail.com')
  
      expect(invalid_contact_predictor.contacts.include?(invalid_contact)).to eq(false)
    end
  end

  it "can convert name to a pattern" do
    full_name = "Ralph Nguyen"

    expect(predictor.name_to_pattern(full_name, :first_name_dot_last_name)).to eq('Ralph.Nguyen')
    expect(predictor.name_to_pattern(full_name, :first_name_dot_last_initial)).to eq('Ralph.N')
    expect(predictor.name_to_pattern(full_name, :first_initial_dot_last_name)).to eq('R.Nguyen')
    expect(predictor.name_to_pattern(full_name, :first_initial_dot_last_initial)).to eq('R.N')
    expect(predictor.name_to_pattern(full_name, :non_existent)).to eq(nil)
  end

  it "#most_common_patterns displays patterns in array, empty array if none" do
    expect(predictor.most_common_patterns('alphasights.com')).to eq([:first_name_dot_last_name] )
    expect(predictor.most_common_patterns('google.com')).to eq([:first_name_dot_last_initial, :first_initial_dot_last_name] )
    expect(predictor.most_common_patterns('notinhash.com')).to eq([])
  end

  describe "#email_predictions" do
    it "requires org_domain to be in the format of a domain" do
      expect { predictor.email_predictions('Ralph Nguyen', 'google') }.to raise_error("org_domain takes the domain of the organization. E.g., 'Google' becomes 'google.com'")
    end

    it "returns nil when no prediction can be made" do
      expect(predictor.email_predictions('Ralph Nguyen', 'nonexistentdomain.com')).to eq([])
    end

    it "correctly predicts emails" do
      expect(predictor.email_predictions('Ralph Nguyen', 'alphasights.com')).to eq(["ralph.nguyen@alphasights.com"])
      expect(predictor.email_predictions('Ralph Nguyen', 'google.com')).to eq(["ralph.n@google.com", "r.nguyen@google.com"] )
    end
  end
end