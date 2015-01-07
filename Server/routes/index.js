var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Express' });
});

router.get('/universities', function(req, res) {
	var db = req.db;
	db.collection('universities').find().toArray(function (err, items) {
        res.json(items);
    });
});

router.get('/departments', function(req, res) {
	var db = req.db;
	var universityNameReq = req.query.universityName;
	db.collection('departments').find({universities : [{universityName: universityNameReq}]}).toArray(function (err, items) {
		res.json(items);
	});
});

router.get('/courses', function(req, res) {
	var db = req.db;
	var universityNameReq = req.query.universityName;
	var courseNameReq = req.query.courseName;
	db.collection('courses').find({university: {name: universityNameReq, courses : [{name : courseNameReq}]}}).toArray(function (err, items) {
		res.json(items);
	});
});

router.get('/comments', function(req, res) {
	var db = req.db;
	var universityNameReq = req.query.universityName;
	var courseNameReq = req.query.courseName;
	db.collection('comments').find({university: {name : universityNameReq, course : [{name : courseNameReq}]}}).toArray(function (err, items) {
		res.json(items);
	});
});

router.get('/replies', function(req, re) {
	var db = req.db;
	var universityNameReq = req.query.universityName;
	var postIdReq = req.query.postId;
	db.collection('repiles').find({university: {name : universityNameReq, comments : [{postId : postIdReq}]}}).toArray(function (err, items) {
		res.json(items);
	});
});

module.exports = router;