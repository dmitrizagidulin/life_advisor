# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActionItem.bucket.enable_index!
Answer.bucket.enable_index!
CurrentFocus.bucket.enable_index!
Goal.bucket.enable_index!
Question.bucket.enable_index!
Thought.bucket.enable_index!
Project.bucket.enable_index!
WebLink.bucket.enable_index!
ProjectGoal.bucket.enable_index!
