
from flask import Flask, request
from dotenv import load_dotenv
from moralis import evm_api
import json
import os

load_dotenv()

app = Flask(__name__)
api_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub25jZSI6ImMwMjc4YzU1LTBmNmItNDgwNS1iZTEwLTJlODI3YTE5ODNkMSIsIm9yZ0lkIjoiMzQ4MzU1IiwidXNlcklkIjoiMzU4MDY4IiwidHlwZUlkIjoiZmM0MDIwZWItY2ViYi00MDFiLWJiNzItYTc3Y2IyYTVmOGQ0IiwidHlwZSI6IlBST0pFQ1QiLCJpYXQiOjE2ODk0MTIwMjcsImV4cCI6NDg0NTE3MjAyN30.na8_t2DJAlEcTZd_C5GZJUAfHNFmQoPsnwnZC2G7Mvw"


@app.route("/get_token_balance", methods=["GET"])
def get_tokens():
  chain=request.args.get("chain")
  address=request.args.get("address")

  params = {
    "address": address,
    "chain": chain
}

  result = evm_api.balance.get_native_balance(
    api_key=api_key,
    params=params,
)

  return result


@app.route("/get_transaction", methods=["GET"])
def get_transactions():
  chain=request.args.get("chain")
  address=request.args.get("address")

  params = {
    "address": address,
    "chain": chain
}

  result1= evm_api.transaction.get_wallet_transactions_verbose(
  api_key=api_key,
  params=params,
)

  return result1

@app.route("/get_user_nfts", methods=["GET"])
def get_nfts():
    address = request.args.get("address")
    chain = request.args.get("chain")
    params = {
        "address": address,
        "chain": chain,
        "format": "decimal",
        "limit": 100,
        "token_addresses": [],
        "cursor": "",
        "normalizeMetadata": True,
    }

    result = evm_api.nft.get_wallet_nfts(
        api_key=api_key,
        params=params,
    )

    # converting it to json because of unicode characters
    response = json.dumps(result, indent=4)
    print(response)
    return response


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)