class Book < ActiveRecord::Base
  LimitOfISBN = 1000

  validates_presence_of   :name, :isbn, :price
  validates_uniqueness_of :isbn

  before_validation do
    candidate = LimitOfISBN.times.find do |isbn|
      not Book.exists?(isbn: isbn)
    end
    self.isbn = candidate
  end
end
