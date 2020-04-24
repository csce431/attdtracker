Feature: display list of courses filtered by year

  As an instructor,
  I need the ability to sort my courses by year
  So that I can quickly view current courses.

Background: instructors have been added to the teacher database
  Given the following instructors exist in the database:
  | name          | email               | department |
  | Jee, Rachel   | racheljee1@tamu.edu | CSCE       |
  | Shao, Tony    | ynottony@tamu.edu   | CSCE       |
  | Jiang, Reegan | rdj772@tamu.edu     | ECEN       |
  | Brown, Sausha | sausha_rae@tamu.edu | ARAB       |

  Then 4 seed instructors should exist

Scenario: restrict to instructors with 'CSCE' or 'ECEN' departments
  When I check the following departments: CSCE, ECEN
  When I uncheck the following departments: ARAB
  When I press "Filter"
  Then I should see "Jee, Rachel"
  And I should see "Jiang, Reegan"
  And I should not see "Brown, Sausha"

