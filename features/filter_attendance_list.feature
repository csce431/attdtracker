Feature: display list of courses filtered by year

  As an instructor,
  I need the ability to sort my courses by year
  So that I can quickly view current courses.

Background: courses have been added to a teacher database
  Given the following courses exist for a teacher:
  | course         | year | semester |
  | CHIN 101 - 500 | 2020 | Fall     |
  | JAPN 102 - 502 | 2020 | Spring   |
  | CSCE 121 - 800 | 2020 | Fall     |
  | ARAB 101 - 502 | 2019 | Spring   |
  | ENGL 210 - 401 | 2018 | Summer   |
  | CSCE 431 - 402 | 2017 | Spring   |

  Then 6 seed courses should exist

Scenario: restrict to courses with '2020' or '2019' years
  When I check the following years: 2020, 2019
  When I uncheck the following years: 2018, 2017 
  When I press "Filter"
  Then I should see "ARAB 101 - 502"
  And I should see "CSCE 121 - 800"
  And I should not see "ENGL 210 - 401"
  And I should not see "CSCE 431 - 402"

Scenario: all years selected
  When I check the following years: 2020, 2019, 2018, 2017 
  When I press "Filter"
  Then I should see all the years

