# The Server

### Dependencies

* nodejs
* npm
* mongodb

### How to run

1. open terminal
2. navigate to directory
3. start mongo `sudo mongod`
4. type `npm install`
5. type `node index.js`

### Methods

`GET /flight` - post parameter id for a specific flight values

`POST /reached` - post parameter id to update the reached value of a flight to true

`POST /pictures` - post parameter id to add a picture to the pictures array of a flight