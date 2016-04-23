var express = require('express')
var app = express()
var multer = require('multer')
var mongoose = require('mongoose')

// mongoose methods

var mongoose_url = "mongodb://localhost/test"

mongoose.connect(mongoose_url);

var conn = mongoose.connection

var flightSchema = new mongoose.Schema({
	long: Number,
	lat: Number,
	reached: Boolean,
	pictures: Array
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

// routes

app.get('/flight', function(req, res){
	Flight.findOne({ _id: req.body.id }, function(err, doc){
		res.send(doc)
	})
})

app.post('/flight', function(req, res){
	var flight = new Flight({
		long: req.body.long,
		lat: req.body.lat,
		reached: false,
		pictures: []
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
		doc.save()
	})
})

app.post('/pictures', upload.array('upload', 20), function(req, res){
	Flight.findOne({ _id: req.body.id }, function(err, doc){
		var pic = doc.pictures
		for(var i=0;i<req.files.length;i++){
			pic += "public/" + req.files[i].filename
		}
		doc.pictures = pic
		doc.save()
	})
})

app.listen(3000, function () {
  console.log('running on port 3000');
});