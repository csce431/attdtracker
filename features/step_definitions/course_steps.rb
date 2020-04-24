Given /the following instructors exist in the database/ do |instructors_table|
   instructors_table.hashes.each do |instructor|
      teachers = Teacher.new
      t_list = instructor[:name].split(", ")
      teachers.lname = t_list[0]
      teachers.fname = t_list[1]
      teachers.email = instructor[:email]
      teachers.department = instructor[:department]
      teachers.save
   end
 end

Then /(.*) seed instructors should exist/ do |seeds|
   Teacher.count.should be seeds.to_i
end

When /I (un)?check the following departments: (.*)/ do |uncheck, dept_list|
   dept_list.split(", ").each do |department|  
      if uncheck
         uncheck("departments[#{department}]")
      else 
         check("departments[#{department}]")
      end  
   end
end

Then /I should see all the departments/ do
   rows = Teacher.all.count
   expect(rows).to eq 4
end

Given /the following students exist in the database/ do |students_table|
   course = Course.new
   students_table.hashes.each do |student|
      stud = Student.new
      stud.fname = student[:first_name]
      stud.lname = student[:last_name]
      stud.email = student[:email]
      stud.save
   end
end

And /I am on the Attendance page/ do
   expect(page).to have_current_path(course_days_path("#{Course.last.id}"))
end

Then /(.*) seed students should exist/ do |seeds|
   # Student.count.should be seeds.to_i
   expect(Student.count).to eq(seeds.to_i)
end

  Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
   expect(page.body.index(e1)).to be < page.body.index(e2)
 end