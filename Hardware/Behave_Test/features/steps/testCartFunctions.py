from behave import *
import requests
import yaml

cartIp = ""
cartUrl = ""

@given('the cart ip address')
def step_given_cart_ip_address(context):
    global cartIp, cartUrl
    with open("..\config.yaml", "r") as file:
        config = yaml.safe_load(file)
    cartIp = config.get("cart_ip")
    cartUrl = "http://" + cartIp + "/"


@when('the cart is polled')
def step_when_cart_is_polled(context):
    global cartUrl
    context.response = requests.get(cartUrl)  # Send a GET request to the cart URL

@then('the cart should return OK')
def step_then_cart_should_return_ok(context):
    assert context.response.status_code == 200, f"Expected status code 200, but got {context.response_status_code}"

@step('the content should match recovery state')
def step_and_content_should_match_recovery_state(context):
    global cartUrl
    assert context.response.content.decode('utf-8') == "Shopwise booted in recovery mode.", f"Expected 'recovery mode' message, but got \"{context.response.content.decode('utf-8')}\""

# Scenario: Magnetometer is operating within valid value ranges
#     Given the cart ip address
#     When the magnetometer is polled
#     Then the magnetometer should return a value within the valid range

@when('the magnetometer is polled')
def step_when_magnetometer_is_polled(context):
    global cartUrl
    context.response = requests.get(cartUrl + "magnetometer")  # Send a GET request to the cart URL

@then('the magnetometer should return a value within the valid range')
def step_then_magnetometer_should_return_valid_value(context):
    assert context.response.status_code == 200, f"Expected status code 200, but got {context.response_status_code}"
    direction = int(context.response.content.decode('utf-8'))
    # assert direction within 0 and 360
    assert direction >= 0 and direction <= 360, f"Expected direction within 0 and 360, but got {direction}"

# Scenario: Accelerometer is operating
#     Given the cart ip address
#     When the accelerometer is polled
#     Then the accelerometer status should return True
    
@when('the accelerometer is polled')
def step_when_accelerometer_is_polled(context):
    global cartUrl
    context.response = requests.get(cartUrl + "accelerometer")  # Send a GET request to the cart URL

@then('the accelerometer status should return True')
def step_then_accelerometer_status_should_return_true(context):
    assert context.response.status_code == 200, f"Expected status code 200, but got {context.response_status_code}"
    assert context.response.content.decode('utf-8') == "1", f"Expected '1', but got \"{context.response.content.decode('utf-8')}\""

# Scenario: System is able to be rebooted
#     Given the cart ip address
#     When the system is rebooted
#     Then the system should indicate that it is rebooting
    
@when('the system is rebooted')
def step_when_system_is_rebooted(context):
    global cartUrl
    context.response = requests.get(cartUrl + "restart")  # Send a GET request to the cart URL  

@then('the system should indicate that it is rebooting')
def step_then_system_should_indicate_rebooting(context):
    assert context.response.status_code == 200, f"Expected status code 200, but got {context.response_status_code}"
    assert context.response.content.decode('utf-8') == "Restarting device...", f"Expected 'Restarting device...', but got \"{context.response.content.decode('utf-8')}\""