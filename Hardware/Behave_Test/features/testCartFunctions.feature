Feature: Validate proper operation of smart cart

    Check to see whether the cart is operating properly within the valid range of values

Scenario: Cart endpoint is present
    Given the cart ip address
    When the cart is polled
    Then the cart should return OK
    And the content should match recovery state

Scenario: Magnetometer is operating within valid value ranges
    Given the cart ip address
    When the magnetometer is polled
    Then the magnetometer should return a value within the valid range