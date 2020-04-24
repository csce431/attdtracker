Feature: display list of students sorted by first or last name

  As an instructor,
  I need the ability to sort my students by name
  So that I can quickly view students.

Background: students have been added to the course database
  Given the following students exist in the database:
  | first_name | last_name | email                 |
  | Anthony    | Shao      | ynottony@tamu.edu     |
  | Daniel     | Wang      | danieldrwang@tamu.edu |
  | Kevin      | Jiang     | kjiang@tamu.edu       |
  | Rachel     | Jee       | racheljee1@tamu.edu   |
  | Reegan     | Jiang     | rdj772@tamu.edu       |

  And I am on the Attendance page
  Then 5 seed students should exist

Scenario: sort first name alphabetically
Given I am on the Attendance page
When I follow "First Name"
Then I should see "Anthony" before "Rachel"

Scenario: sort last name alphabetically
When I follow "Last Name"
Then I should see "Jee" before "Shao"
