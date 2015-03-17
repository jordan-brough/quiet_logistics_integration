module Factories

  def self.shipment
    {
      "id" => "12836",
      "order_id" => "R154085346",
      "email" => "spree@example.com",
      "cost" => 5,
      "status" => "ready",
      "stock_location" => "default",
      "shipping_method" => "UPS Ground (USD)",
      "tracking" => "12345678",
      "shipped_at" => "2014-02-03T17:33:55.343Z",
      "shipping_address" =>  {
        "firstname" => "Joe",
        "lastname" => "Smith",
        "address1" => "1234 Awesome Street",
        "address2" => "",
        "zipcode" => "90210",
        "city" => "Hollywood",
        "state" => "California",
        "country" => "US",
        "phone" => "0000000000",
      },
      "items" => [
        {
          "name" => "Spree T-Shirt",
          "product_id" => "SPREE-T-SHIRT",
          "quantity" => 1,
          "price" => 30,
          "options" => {},
        },
      ],
      "line_items" => [
        {
          "name" => "Spree T-Shirt",
          "product_id" => "SPREE-T-SHIRT",
          "quantity" => 1,
          "price" => 30,
          "options" => {},
          "item_number" => 1,
          "sku" => "somesku",
        }
      ]
    }
  end

  def self.transfer_order_shipment
    JSON.parse(<<-JSON)
      {
        "id": "W600111112",
        "order_id": 600111112,
        "channel": "simparel",
        "updated_at": "2015-03-17T20:10:51Z",
        "order_type": "TO",
        "business_unit": "SOMEBUSINESS",
        "client_id": "SOMEBUSINESS",
        "comments": "",
        "carrier": "UPS",
        "service_level": "GROUND",
        "shipping_address": {
          "firstname": "Some Name",
          "lastname": "",
          "address1": "1234 Way",
          "address2": "",
          "city": "Fairfield",
          "country": "",
          "zipcode": "06824",
          "state": "CT"
        },
        "billing_address": {
          "firstname": "Some Name",
          "lastname": "",
          "address1": "1234 Way",
          "address2": "",
          "city": "Fairfield",
          "country": "",
          "zipcode": "06824",
          "state": "CT"
        },
        "items": [
          {
            "description": "PREMIUM GOLF CHINO - TURKISH COFF. - SL",
            "sku": "1234567",
            "quantity": 1,
            "price": 57.6,
            "line_number": 11,
            "UOM": "EA"
          },
          {
            "description": "PREMIUM GOLF CHINO - KHAKI - SL",
            "sku": "987654",
            "quantity": 1,
            "price": 57.6,
            "line_number": 12,
            "UOM": "EA"
          }
        ],
        "tracking": "1Z171V034341710225",
        "warehouse": "DVN",
        "status": "shipped",
        "shipped_at": "2014-11-18T14:27:59.90125Z"
      }
    JSON
  end
end
