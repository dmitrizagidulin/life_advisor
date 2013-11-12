require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  
  describe "when a new Question is created" do
    it "must not validate" do
      question = Question.new
      question.wont_be :valid?
    end
    
    it "must not be answered" do
      question = Question.new
      question.wont_be :answered
    end
  end
  
  test "New Question should have a Bump count of 0" do
    question = Question.new
    question.bump_count.must_equal 0
  end
  
  test "Bumping a new Question should result in a bump count of 1" do
    question = Question.new
    question.bump
    question.bump_count.must_equal 1
  end
  
  test "Questions should be sorted first by bump count, descending" do
    q0 = Question.new key: '0 bumps'
    
    q1 = Question.new key: '1 bumps'
    q1.bump
    
    q2 = Question.new key: '2 bumps'
    2.times { q2.bump }
    
    list = []
    list << q1
    list << q0
    list << q2
    
    list.sort!
    list[0].key.must_equal '2 bumps'
  end
end