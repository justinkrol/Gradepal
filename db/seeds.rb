# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

user1 = User.create! email: 'dev@gradepal.com', password: 'password', password_confirmation: 'password'

user1.courses.create! code: 'SYSC 1005', name: 'Python Programming'
user1.courses.create! code: 'ECOR 1010', name: 'Engineering Core'
user1.courses.create! code: 'PHYS 1003', name: 'Physics I'
user1.courses.create! code: 'MATH 1004', name: 'Calculus'
user1.courses.create! code: 'MATH 1104', name: 'Algebra'

sysc = user1.courses.find_by(code: 'SYSC 1005')
  
sysc.components.create! name: 'Tests', weight: 25
sysc.components.create! name: 'Assignments', weight: 25
sysc.components.create! name: 'Final Exam', weight: 50

tests =  sysc.components.find_by(name: 'Tests')

tests.grades.create! name: 'Test 1', score: 35, max: 40
tests.grades.create! name: 'Test 2', score: 39, max: 40
