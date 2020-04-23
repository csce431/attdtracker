Given /the following courses exist for a teacher/ do |courses_table|
   courses_table.hashes.each do |course|
      dept = (course[:course])[0..3]
      num = (course[:course])[5..7]
      sec = (course[:course])[11..13] 
      courses = Course.new
      courses.name = dept
      courses.number = num.to_i
      courses.section = sec.to_i
      courses.year = course[:year]
      courses.season = course[:semester]
      courses.save
   end
 end

Then /(.*) seed courses should exist/ do |seeds|
   Course.count.should be seeds.to_i
end

When /I (un)?check the following years: (.*)/ do |uncheck, year_list|
   year_list.split(", ").each do |s|  
      if uncheck
         uncheck("years[#{s}]")
      else 
         check("years[#{s}]")
      end  
   end
end

Then /I should see all the years/ do
    rows = Course.all.count
    expect(rows).to eq 6
end

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

Then /I should see all the years/ do
    rows = Teacher.all.count
    expect(rows).to eq 6
end

Given /the following students exist in the database/ do |students_table|
   students_table.hashes.each do |student|
      stud = Student.new
      stud.fname = student[:first_name]
      stud.lname = student[:last_name]
      stud.email = student[:email]
      stud.save
   end
end

Then /(.*) seed students should exist/ do |seeds|
   # Student.count.should be seeds.to_i
   expect(Student.count).to eq(seeds.to_i)
end

  Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
   expect(page.body.index(e1)).to be < page.body.index(e2)
 end