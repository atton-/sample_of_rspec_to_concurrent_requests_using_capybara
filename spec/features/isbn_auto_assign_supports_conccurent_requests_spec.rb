#!/usr/bin/env ruby
require 'rails_helper'

describe 'Auto Assign supports concurrent requests' do

  specify '2 requests' do
    # This test not passed on SQLite3
    before_book_numbers  = Book.count
    number_of_requests = 2
    requests = number_of_requests.times.map do |n|
      fork do
        visit new_book_path
        expect(new_book_path)
        fill_in 'Name', with: "book#{format('%02x', n).upcase}"
        fill_in 'Price',      with: n.to_s
        click_button 'Create Book'
      end
    end

    results = requests.map do |pid|
      Process.waitpid(pid)
      $?.exitstatus
    end
    ActiveRecord::Base.clear_active_connections!
    expect(Book.count).to eq(before_book_numbers+number_of_requests)
    expect(Book.pluck(:isbn).uniq.count).to eq(before_book_numbers+number_of_requests)
  end
end
