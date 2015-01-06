var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Express' });
});

router.get('/alldata', function(req, res) {
	var db = req.db;
	var collection = db.get('alldata');
	collection.find({}, {}, function(e, docs) {
		res.render('alldata', {
			"alldata" : docs
		});
	});
});

module.exports = router;
