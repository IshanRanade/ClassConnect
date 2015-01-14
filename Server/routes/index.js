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


// Gets all the courses given a university
router.get('/courses', function(req, res) {
	var db = req.db;
	var universityNameReq = req.query.universityName;
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

// Gets all the comments for a particular course given the university and course number.
// Test call: universityName = University of Washington
//		      departmentName = CSE
//			  courseNumber   = 143
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
		var courseNameReq = departmentNameReq + " " + courseNumberReq;
		db.collection("comments").find({courseName : courseNameReq}).toArray(function (err, items) {
			if (items.length == 0) {
				res.json([{msg : "No comments exist!"}]);
			} else {
				res.json(items);
			}
		});
	}
});

// Gives back the raw JSON used for testing.
router.get('/rawJSON', function(req, res) {
	var db = req.db;
	var universityNameReq = req.query.universityName;
	var collection = req.query.collection;
	db.collection(collection).find({universityName : universityNameReq}).toArray(function (err, result) {
		if (err) {
			throw err;
		}
		res.json(result[0]);
	});
});

// router.post('/comments', function(req, res) {
// 	var toPostJSON = req.body;
// 	var curCommentsJSON = findCommentsJSON(db, toPostJSON.universityName, toPostJSON.departmentName, toPostJSON.courseNumber);
//db.comments.find({universityName : 'University of Washington', 'departments.departmentName' : 'A A', 'departments.courses' : {"$elemMatch":{"$in":['198']}}}, {'departments.courses$':1, _id : 0})

function updateCommentsJSON(toUpdate, res, req) {
	var db = req.db;
	
}


// Gets all the replies given a particular comment and university
// Test call: universityName = University of Washington
//			  postId = fyg6e3
router.get('/replies', function(req, res) {
	var db = req.db;
	var universityNameReq = req.query.universityName;
	var postIdReq = req.query.postId;
	if (universityNameReq === undefined) {
		res.json({msg : "The University field is not specified."});
	} else if (postIdReq === undefined) {
		res.json({msg : "The post id is not specified."});
	} else {
		db.collection('replies').find({universityName : universityNameReq}).toArray(function (err, items) {
			var allComments = items[0].comments;
			var commentFound = false;
			for (var index in allComments) {
				if (allComments[index].postId == postIdReq && !commentFound) {
					res.json(allComments[index]);
					commentFound = true;
				}
			}
			if (!commentFound) {
				res.json({msg : "Replies not found for comment " + postIdReq + ", please try again"});
			}
		});
	}
});



module.exports = router;