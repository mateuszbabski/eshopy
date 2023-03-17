# Eshopy

## Table of content:
* [Project description](#project-description)
* [Technologies](#technologies)
* [Setup](#setup)
* [Features](#features)
* [Contribution](#contribution)


## Project description
Project done for learning purposes. Simple UI done just to realized how LiveView works under the hood and it is all connected with backend api.  

## Technologies

- Elixir 1.14.3
- Phoenix 1.6.16
- Ecto 3.6
- Phoenix LiveView 0.18.15
- PostgreSQL

## Setup

#### Clone to repository
```
$ git clone https://github.com/mateuszbabski/eshopy
```

#### Go to the folder you cloned
```
$ cd eshopy
```

#### Instal dependencies
```
mix deps.get
```

#### Create and migrate database
```
mix ecto.setup
```

#### Start Phoenix server
```
mix phx.server
```

#### Visit [`localhost:4000`](http://localhost:4000)

## Features

- Full custom authentication proccess for a user including reset/forgot password
- Confirmation emails
- Adding, updating and deleting products available to sell
- Adding products to shopping cart, invoke shopping cart from db after logout
- Placing and order from shopping cart with additional informations about delivery address

To implement:
- Chat customer/customer-service
- Payment service
- Notifications about the orders.
- Reviews for shop and products

## Contribution

Feel free to fork project and work on it with me. I am open to any suggestions how to make it better.
