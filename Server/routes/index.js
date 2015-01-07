var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Express' });
});

router.get('/alldata', function(req, res) {
	var db = req.db;
	db.collection('alldata').find().toArray(function (err, items) {
        res.json(items);
    });
});

module.exports = router;
