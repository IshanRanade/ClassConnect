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

// Gets all the departments given a university.
router.get('/departments', function(req, res) {
	var db = req.db;
	var universityNameReq = req.query.universityName;
	if (universityNameReq === undefined) {
		res.json({msg : "Please specify a univerisity"});
	} else {
		db.collection('departments').find({universityName : universityNameReq}).toArray(function (err, items) {
			if (items.length == 0) {
				res.json({msg : "This University does not exist!"});
			} else {
				console.log("success");
				res.json(items[0]); // only expecting one back
			}
		});
	}
});

// Gets all the courses given a university and a department.
router.get('/courses', function(req, res) {
	var db = req.db;
	var universityNameReq = req.query.universityName;
	var departmentNameReq = req.query.departmentName;
	db.collection('courses').find({universityName : universityNameReq}).toArray(function (err, items) {
		var courseFound = false;
		if (items.length == 0) { // no university found
			res.json({msg : "This University does not exist!"});
		} else {
			var departments = items[0].departments;
			res.json(departments);
		}
	});
});

router.get('/comments', function(req, res) {
	var universityNameReq = req.query.universityName;
	var departmentNameReq = req.query.departmentName;
	var courseNumberReq = req.query.courseNumber;
	if (universityNameReq === undefined) {
		res.json({msg : "This University does not exist!"});
	} else if (departmentNameReq === undefined) {
		res.json({msg : "Please specify a department name."});
	} else if (courseNumberReq === undefined) {
		res.json({msg : "Please specify a course number."});
	} else {
		var db = req.db;
		db.collection('comments').find({universityName : universityNameReq}).toArray(function (err, items) {
			if (items.length == 0) {
				res.json({msg : "This University does not exist!"});
			} else {
				var commentsFound = false;
				var departments = items[0].departments;
				for (var index in departments) {
					if (departments[index].departmentName == departmentNameReq && !commentsFound) { // found the right department
						var courses = departments[index].courses;
						for (var courseIndex in courses) { 
							if (courses[courseIndex].courseName == courseNumberReq && !commentsFound) { // found the right course number
								res.send(courses[courseIndex].comments);
								commentsFound = true;
								break;
							}
						}
					}
				}
				if (!commentsFound) {
					res.json({msg : "Comments not found, please try again."});
				}
			}
		});
	}
});

router.get('/replies', function(req, res) {
	var db = req.db;
	var universityNameReq = req.query.universityName;
	var postIdReq = req.query.postId;
	db.collection('repiles').find({university: {name : universityNameReq, comments : [{postId : postIdReq}]}}).toArray(function (err, items) {
		res.json(items);
	});
});

module.exports = router;