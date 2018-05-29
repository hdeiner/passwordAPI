Feature: UM Portal API - Passwords

  Scenario Outline: Conforms to password rules
    Given I want to change my password with the UM Portal
    When I try to set my new password to <newPassword>
    Then I then I should be told <passwordAdvice>

    Examples:
      | password     | passwordAdvice                                             |
      |  12345       | password must have letters in it                           |
      |  password    | password must have both upper and lower case letters in it |
      |  PASSWORD    | password must have both upper and lower case letters in it |
      |  pASSWORD    | password must have at least 1 special character in it      |
      |  pASSWORD!   | password must have at least 1 digit in it                  |
      |  pW1!        | password must be at least 8 characters long                |
      |  pass Word1? | password can not have any spaces in it                     |


  Scenario Outline: Password strength metric  (for now, length - 8 + special characters + numbers - sum of all consecutive Upper/lower/special/digit)
    Given I want to change my password with the UM Portal
    When I try to set my new password to <newPassword>
    Then I then I should be told that it has a strength of <passwordStrength>

    Examples:
      | password                   | passwordStrength |
      | passWord1?                 | 0                |
      | bFihJv!srBChibW4ay#eXEksdh | 13               |