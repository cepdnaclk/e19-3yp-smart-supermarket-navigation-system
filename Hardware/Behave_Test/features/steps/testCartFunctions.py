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

@given('the magnetometer is operating')
def step_given_magnetometer_is_operating(context):
    # TODO: Implement the step
    pass

@when('the magnetometer is polled')
def step_when_magnetometer_is_polled(context):
    # TODO: Implement the step
    pass

@then('the magnetometer should return a value within the valid range')
def step_then_magnetometer_should_return_valid_range(context):
    # TODO: Implement the step
    pass
