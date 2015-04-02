# Email Predictor

To run with tests, go to directory and `bundle install` if necessary, and then you can run `rspec spec`

    initial_data_hash = {  "John Ferguson" => "john.ferguson@alphasights.com",  "Damon Aw" => "damon.aw@alphasights.com",  "Linda Li" => "linda.li@alphasights.com",  
    "Larry Page" => "larry.p@google.com",  "Sergey Brin" => "s.brin@google.com",  "Steve Jobs" => "s.j@apple.com"}
     => {"John Ferguson"=>"john.ferguson@alphasights.com", "Damon Aw"=>"damon.aw@alphasights.com", "Linda Li"=>"linda.li@alphasights.com", "Larry Page"=>"larry.p@google.com", "Sergey Brin"=>"s.brin@google.com", "Steve Jobs"=>"s.j@apple.com"} 
    
    predictor = EmailPredictor.new(initial_data_hash)
    
    predictor.email_predictions('Peter Wong', 'alphasights.com')
     => ["peter.wong@alphasights.com"] 
    
    predictor.email_predictions('Craig Silverstein', 'google.com')
     => ["craig.s@google.com", "c.silverstein@google.com"] 
     
    predictor.email_predictions('Steve Wozniak', 'apple.com')
     => ["s.w@apple.com"]
     
    predictor.email_predictions('Barack Obama', 'whitehouse.gov')
    => [] 