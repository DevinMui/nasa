var express = require('express')
var app = express()
var multer = require('multer')
var mongoose = require('mongoose')
var bodyParser = require('body-parser')

// mongoose methods

var mongoose_url = "mongodb://localhost/test"

mongoose.connect(mongoose_url);

var conn = mongoose.connection

var flightSchema = new mongoose.Schema({
	long: Number,
	lat: Number,
	reached: Boolean,
	pictures: Array,
	soilMosture: Number,
	humidity: Number,
	temperature: Number,
	pressure: Number,
	baroTemp: Number
},
{
	timestamps: true
})

var Flight = mongoose.model('Flight', flightSchema)

// multer

var storage = multer.diskStorage({
	destination: function(req, file, cb){
		cb(null, 'public/uploads/')
	},
	filename: function(req, file, cb){
		crypto.pseudoRandomBytes(16, function (err, raw) {
      cb(null, raw.toString('hex') + Date.now() + '.jpg')
    });
	}
})

var upload = multer({storage: storage})

// config with express

app.use(express.static('public'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))
app.engine('html', require('ejs').renderFile);
app.set('view engine', 'ejs');

// routes

// this one is supposed to be more readable
app.get('/flight/:id', function(req, res){
	var id = req.params.id
	Flight.findOne({ _id: id }, function(err, doc){
		if(!err)
			res.render("flight", {"doc": doc})
		else
			res.send(err)
	})
})

app.get('/latest', function(req, res){
	Flight.findOne({}, {}, { sort: { 'createdAt': -1 } }, function(err, doc){ // gets latest one
		if(!err)
			res.send(doc)
		else
			res.send(err)
	})
})

app.get('/flight', function(req, res){
	Flight.findOne({ _id: req.body.id }, function(err, doc){
		if(!err)
			res.send(doc)
		else
			res.send(err)
	})
})

app.post('/flight', function(req, res){
	var flight = new Flight({
		long: req.body.long,
		lat: req.body.lat,
		reached: false,
		pictures: [],
		soilMosture: -1,
		humidity: -1,
		temperature: -1,
		pressure: -1,
		baroTemp: -1
	})
	flight.save(function(err, flight){
		if(err)
			res.send(err)
		else
			res.send(flight)
	})
})

app.post('/reached', function(req, res){
	Flight.findOne({ _id: req.body.id }, function(err, doc){
		doc.reached = true
		doc.soilMosture = req.body.soilMosture
		doc.humidity = req.body.humidity
		doc.temperature = req.body.temperature
		doc.pressure = req.body.pressure
		doc.baroTemp = req.body.baroTemp
		doc.save()
	})
})

app.post('/pictures', upload.array('upload', 20), function(req, res){
	Flight.findOne({ _id: req.body.id }, function(err, doc){
		var pic = doc.pictures
		for(var i=0;i<req.files.length;i++){
			pic += "/" + req.files[i].filename
		}
		doc.pictures = pic
		doc.save()
	})
})

app.listen(80, function () {
  console.log('running on port 3000');
});

/*
var latest = # http request
while true
	# http request
	if latest != request.latest
		# set waypoint
*/
