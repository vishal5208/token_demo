from brownie import VishalToken, network, config
from scripts.helpful_scripts import get_account


def deploy_token():
    account = get_account()
    vishal = VishalToken.deploy(
        config["token_name"], config["token_symbol"], 18, account.address, {"from": account},  publish_source=config["networks"][network.show_active()].get("verify"),)
    print(vishal)


def main():
    deploy_token()
