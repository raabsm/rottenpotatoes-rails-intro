class Movie < ActiveRecord::Base
  def self.all_ratings()
    return ['G','PG','PG-13','R']
  end
  
  def self.with_ratings(ratings)
    if ratings == nil
      return all()
    end
    
    return where("lower(rating) IN (?)", ratings)
  end
  
end
